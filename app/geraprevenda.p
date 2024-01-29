
def new global shared var setbcod as int.

def input param par-fin as recid.
def input param par-clf as recid.
def input param videntificador as char.
def input param v-vencod as int.
def input param par-campanha as int.
def input param par-valorcupomdesconto as dec.
def input param pidbag  as int.
def output param rec-prevenda as recid.

def shared var vcupomb2b as int format ">>>>>>>>>9". /* helio 31012023 - cupom b2b */
def shared var vplanocota as int. /* helio 02082023 */

def shared var pmoeda as char format "x(30)".

def new global shared var vpromocod   as char. /* helio 09032022 - [ORQUESTRA 243179 - ESCOPO ADICIONAL] Seleção de moeda a vista na Pré-Venda  */

def buffer xestab for estab.

def shared temp-table wf-movim no-undo
    field wrec      as   recid
    field movqtm    like prevenprod.movqtm
    field lipcor    like liped.lipcor
    field movalicms as dec
    field desconto  as dec
    field movpc     like prevenprod.movpc
    field precoori  like prevenprod.movpc
    field vencod    like func.funcod
    field KITproagr   like produ.procod.

def shared temp-table wf-imei
    field wrec      as recid
    field imei      as char.

def shared temp-table tt-prodesc
    field procod like produ.procod
    field preco  like movim.movpc
    field preco-ven like movim.movpc
    field desco  as   log.

def shared temp-table tt-seguroPrestamista no-undo
    field wrec          as recid
    field procod        as int.

def {1} SHARED temp-table tt-seg-movim
    field seg-procod  as int             /* procod do seguro */
    field procod      like movim.procod  /* procod de venda */
    field ramo        as int
    field meses       as int
    field subtipo     as char
    field movpc       like movim.movpc
    field precoori    like movim.movpc
    field p2k-datahoraprodu as char
    field p2k-id_seguro     as int
    field p2k-datahoraplano as char
    index seg-movim is primary unique seg-procod procod.

def shared var etb-entrega like setbcod.
def shared var dat-entrega as date.
def shared var nome-retirada as char format "x(30)".
def shared var fone-retirada as char format "x(15)".

def var vprecod as int.
def var vmovseq as int.
def var vpedidoespecial as log.
def var vdat-ped-especial as date.
def var vobs-ped-especial as char.

/* PEDIDO ESPECIAL */
vpedidoespecial = no.
vdat-ped-especial = ?.
vobs-ped-especial = "".

    for each wf-movim by wf-movim.movalicms .
        find produ where recid(produ) = wf-movim.wrec no-lock.
        if produ.proipival = 1
        then do:
            vpedidoespecial = yes.
            leave.
        end.            
    end.
    if vpedidoespecial
    then do:
        message skip(1) 
                "O produto de pedido especial (PE) será gerado automaticamente. " skip
                "Caso a loja deseje cancelar o pedido, entrar em contato com o " skip
                "   time de compras pelo e-mail pedidoespecial@lebes.com.br.   " skip(2)      
                " ATENÇÃO: Para produto PE descontinuado não será gerado pedido. " skip(1) /* helio 27112023 */
        view-as alert-box.                         
        vdat-ped-especial = today.    
        vobs-ped-especial = "PEDIDOESPECIAL=SIM".
    end.
    
vprecod = 1.
do on error undo:
    find last prevenda where prevenda.etbcod = setbcod exclusive no-error.
    if avail prevenda
    then do:
        vprecod = prevenda.precod + 1.
    end. 
    release prevenda.
    create prevenda. 
    prevenda.etbcod = setbcod. 
    prevenda.precod = vprecod. 
    prevenda.DtInclu = today.
    prevenda.HorIncl = time.
    
    rec-prevenda = recid(prevenda).
end.

find finan where recid(finan) = par-fin no-lock.
find clien where recid(clien) = par-clf no-lock.

do on error undo:
    release prevenda.
    find prevenda where recid(prevenda)= rec-prevenda exclusive no-error.

    find xestab where xestab.etbcod = prevenda.etbcod no-lock.

    prevenda.clicod  = clien.clicod.
    prevenda.fincod  = finan.fincod.
    prevenda.crecod  = if finan.fincod = 0 then 1 else 2.
    prevenda.identificador = videntificador.
    prevenda.vencod  = v-vencod.
    prevenda.idbag   = pidbag.

    prevenda.pedidoespecial     = vpedidoespecial.
    prevenda.dat-ped-especial   = vdat-ped-especial.
    prevenda.obs-ped-especial   = vobs-ped-especial.

    if etb-entrega <> 0 and
       etb-entrega <> setbcod 
    then do:
        prevenda.etb-entrega    = etb-entrega.
        prevenda.fone-retirada  = fone-retirada.
        prevenda.nome-retirada  = nome-retirada.
        prevenda.dat-entrega    = dat-entrega.
    end.        

    prevenda.cupomb2b = vcupomb2b.
    prevenda.campanha               = par-campanha.
    prevenda.valorcupomdesconto     = par-valorcupomdesconto.
    prevenda.planocota              = vplanocota.

    prevenda.pmoeda                 = pmoeda.
    prevenda.promocod               = vpromocod.
    
    vmovseq = 0.    
    for each wf-movim.
        vmovseq = vmovseq + 1.
        find produ where recid(produ) = wf-movim.wrec no-lock.
    
        create prevenprod.
        prevenprod.EtbCod           = prevenda.EtbCod.
        prevenprod.PreCod           = prevenda.PreCod.
        prevenprod.movseq           = vmovseq.
        prevenprod.procod           = produ.procod.
        prevenprod.movpc            = wf-movim.movpc.
        prevenprod.movqtm           = wf-movim.movqtm.
        prevenprod.precoori         = wf-movim.precoori.
        prevenprod.vencod           = wf-movim.vencod.       

        assign
            prevenprod.movdes = 0.
        find first tt-prodesc where tt-prodesc.procod = prevenprod.procod
                                and tt-prodesc.desco
                   no-lock no-error.
        if avail tt-prodesc
        then
            if tt-prodesc.preco > tt-prodesc.preco-ven
            then assign
                    prevenprod.movdes = tt-prodesc.preco - tt-prodesc.preco-ven
                    prevenprod.movpc  = prevenprod.movpc + prevenprod.movdes.
    
        if prevenda.cupomb2b <> 0 and  prevenda.cupomb2b <> ? /* helio 06032023 - colocado teste de so quand for b2b */
        then do.
            /* helio 03022023 - nao estava enviando o desconto */
            prevenprod.movpc  = prevenprod.precoori.
            prevenprod.movdes = prevenprod.precoori - prevenprod.movpc.
        end. 
        
        prevenprod.movtot           = prevenprod.movqtm * prevenprod.movpc.


        /* GE / RFQ */
        find first tt-seg-movim where tt-seg-movim.seg-procod = produ.procod no-error.
        if avail tt-seg-movim
        then do:
            
            prevenprod.garantia       = yes.
            prevenprod.procodproduto = tt-seg-movim.procod.
            prevenprod.meses   = tt-seg-movim.meses.
            prevenprod.subtipo = tt-seg-movim.subtipo.
            prevenprod.p2k-datahoraprodu = substr(tt-seg-movim.p2k-datahoraprodu, 1, 8).
            prevenprod.p2k-datahoraplano = tt-seg-movim.p2k-datahoraplano .
            prevenprod.p2k-id_seguro     = string(tt-seg-movim.p2k-id_seguro).  
        
        
        end.
        
        
        find first tt-seguroprestamista where 
            tt-seguroprestamista.procod = produ.procod
             no-lock no-error.

        if not avail tt-seguroprestamista /* Seguro Prestamista nao faz parte dototal */
        then do:
            prevenda.protot             = prevenda.protot   + prevenprod.movtot.
        end.
        else do:
             prevenprod.seguroprestamista = yes.
        end.
        
        if produ.pronom begins "CHEQUE PRESENTE" or 
           produ.pronom begins "CARTAO PRESENTE" or 
           produ.procod = 10000  
        then do:
            prevenprod.presente = yes.
        end.            

        find first wf-imei where wf-imei.wrec = wf-movim.wrec no-lock no-error.
        if avail wf-imei
        then prevenprod.imei = wf-imei.imei.

        /* iompostos */
        prevenprod.movalicms = produ.proipiper.
        prevenprod.sittributaria = "T".

    
        if produ.proipiper = 99 
        then do:
            assign prevenprod.sittributaria = "F"
                   prevenprod.movalicms = 0. 
        end.
        else do:
            if xestab.ufecod = "RS" 
            then do:
                prevenprod.movalicms = 17.
            end.        
            if xestab.ufecod = "SC"  
            then do:
                prevenprod.movalicms = 17. /* helio 13/04/2022 a pedido milena */
                /*run aliquotaicms.p (produ.procod, 0, xestab.ufecod, xestab.ufecod, output valiquota).*/
            end.    
            if xestab.ufecod = "PR"  
            then do:
                prevenprod.movalicms = 19. /* helio 13/04/2022 a pedido milena */
            end.    
        
        end.
    
        find clafis where clafis.codfis = produ.codfis no-lock no-error.
        prevenprod.imposto = 0.
        if avail clafis and clafis.dec1 > 0
        then assign prevenprod.imposto = clafis.dec1 + clafis.dec2.
    
    end.   

end.


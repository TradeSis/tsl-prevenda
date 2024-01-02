def new shared var vapiconsultarproduto as log format "Ligado/Desligado".
def new shared var p-supervisor as char.
def new shared var pmoeda as char format "x(30)".
def new global shared var vpromocod   as char. /* helio 09032022 - [ORQUESTRA 243179 - ESCOPO ADICIONAL] Sele��o de moeda a vista na Pr�-Venda  */
vpromocod = "".

def var rec-prevenda as recid.
def var vpromocavista as log.

def var vdescricaoFornecedor as char.

{admcab.i}
{dftempWG.i new}  
{wc-consultaestoque.i new}
{wc-consultaimei.i new}
{wc-consultamargemdesconto.i new}
{setbrw.i}.
{inc-def-pre.i}
{garan-rfq.i new} 


def NEW shared temp-table tt-seguroPrestamista no-undo
    field wrec          as recid
    field procod        as int.

 DEFINE new shared TEMP-TABLE ttclien NO-UNDO       serialize-name 'creditoCliente'
    field tipo    as char format "x(18)"
    field clicod    as int serialize-name 'codigoCliente'
    field cpfCNPJ    as char format "x(18)"    serialize-name 'cpfCNPJ'
    field clinom    as char format "x(40)" serialize-name 'nomeCliente'
    field limite      as dec
    field vctoLimite  as date
    field saldoLimite  as dec
    field comprometido as dec
    field comprometidoTotal as dec
    field comprometidoPrincipal as dec
    field comprometidoNormal as dec
    field comprometidoNovacao as dec
    /* #092022 */
    field dataUltimaCompra as date
    field quantidadeContratos as int
    field quantidadeParcelasPagas as int
    field quantidadeParcelasEmAberto as int
    field valorParcelasAtraso as dec
    field quantidadeAte15Dias as int
    field quantidadeAte45Dias as int
    field quantidadeAcima45Dias as int
    /* #092022 */
    index cli is unique primary clicod asc tipo desc.


{seguroprest.i}

def temp-table ttst no-undo
    field ncm   like produ.codfis format "99999999"
    index x is unique primary ncm asc.

if search("../etc/st062022.txt") <> ?
then do:    
    input from ../etc/st062022.txt.
    repeat:
        create ttst.
        import ttst.
    end.
    input close.
end.
for each ttst where ttst.ncm = 0.
    delete ttst.
end.    



def var vprosit as log format "SIM/NAO". 
def var vpe     as log format "SIM/NAO".
def var vvex    as log format "SIM/NAO".
def var vtipomix as char format "x(6)".
def var vleadtime as char format "x(4)".
def var vstatusitem as char format "x(13)".
def var vmixloja  as char format "x(5)". 
def var vfabcod as char format "x(8)".
def var vtempogar as char format "x(03)".

def var vdescontinuado   as log format "SIM/NAO".

def var vmix    as log format "SIM/NAO".
def var vloop   as int.


     form with frame f-senha.
     form with frame f-exclusao.
     
     def var ppreco_total    as dec.
     def var ppreco_unitario as dec.
     def var apreco_total    as dec.
     def var apreco_unitario as dec.
     def var npreco_total    as dec.
     def var npreco_unitario as dec.
     def var vindbldes as log.

     def var aux1 as dec.
     def var aux2 as log.
     
     
      def var vbarramentolibera as log.
      def var vgerentelibera    as log.
      def var vsupervisorlibera as log.
      def var p-libregional as log.
        def var vbarr-desc as dec.
    def var vagrupador as log.
    
def new shared temp-table wf-imei
    field wrec      as recid
    field imei      as char.

/* KIT */
def var vlistaFilhos as char.
def buffer fprodu for produ.
def buffer festoq for estoq.
def var vqtdKIT as int.
def var aux-procod  like produ.procod.
FUNCTION acha2 returns character
    (input par-oque as char, 
     input par-onde as char). 
      
    def var vx as int. 
    def var vret as char.  
    vret = ?.  
    do vx = 1 to num-entries(par-onde,"|"). 
        if num-entries( entry(vx,par-onde,"|"),"#") = 2 and
                entry(1,entry(vx,par-onde,"|"),"#") = par-oque
        then do: 
            vret = entry(2,entry(vx,par-onde,"|"),"#"). 
            leave. 
        end. 
    end. 
    return vret. 
END FUNCTION.
 
def var vdescontoMaximoPermitido as dec.


def buffer sclase for clase.
def var vmostradet as log.

/*#3*/
def var vsenhamax   as log.
def var vdescmed    as dec.
def var vdescmed31    as dec.
def var vdescmed41    as dec.

def var vdescmax     as dec.
def var vdescmax31     as dec.
def var vdescmax41      as dec.

/*#3*/ 
def var vparam-WG as char.
def var perc-desc as dec.

def new shared workfile wf-plani    like plani.
def new shared workfile wf-titulo   like titulo.
def new shared workfile wf-contrato like contrato.
def new shared workfile wf-contnf   like contnf.

def var vpromocao as char.
def var vtextopromocao as char.

def var vpercmax like plani.platot.

def new shared var vplano11 as log.

def var sal-aberto as dec init 0.
def var vlimcrd   as dec init 0.
def var lim-calculado as dec init 0.

def var parcela-especial as dec.
def var vpromoc as char. 
def buffer l-produ for produ.
def var vdiscre as log.
def new global shared var scartao as char.
def var v-cmp as int.
def var vmc as char.
def var vmen-cre as char.
def var vdtvenbr as char format "x(15)".
def var vdtvenbd as char format "x(15)".
def var vdtvenbp as char format "x(15)".
def var dat-vencto as date.
def buffer bclase for clase.
def new shared temp-table tt-valpromo
    field tipo   as int
    field forcod as int
    field nome   as char
    field valor  as dec
    field recibo as log 
    field despro as char
    field desval as char.

def var val-price as log.
def var cel-numero as char format "(xxx)xxxx-xxxx".
def new shared var etb-entrega like setbcod.
def new shared var dat-entrega as date.
def new shared var dat-entrega1 as date.
def new shared var p-dtentra as date.
def new shared var p-dtparcela as date.
def new shared var nome-retirada as char format "x(30)".
def new shared var fone-retirada as char format "x(15)".

def var parametro-in as char.
def var parametro-out as char.
def var libera-plano as log.
def var validaplano as log.
def var vpreco-plano as log init no.
def var vp00 as log init no. 
def var vp42 as log init no.
def var vp43 as log init no.
def var vp87 as log init no.
def var val-prazo as dec.
def var vsenha-sup as log init no.
def var vqtpro as int.
def var vlibera as log.
def var vbloq-promo as log.
def var vtotven as dec.
def var vrecarga as log.
def var vproduto as log.
def var ventradadiferenciada as log.

/** CARTAO PRESENTE 
def new shared temp-table tt-cartpre
    field seq    as int
    field numero as int
    field valor  as dec.
***/

def new shared temp-table tt-prodesc
    field procod     like produ.procod
    field preco      like movim.movpc
    field preco-ven  like movim.movpc
    field desco  as   log.
    
/** Chamado 16177 - supervisor**/
def new shared temp-table tt-senauto
    field procod     like produ.procod
    field preco-ori  like movim.movpc
    field desco      as   log init no
    field senauto    as   dec format ">>>>>>>>>>"
    index i-pro is primary unique procod.

def new shared temp-table tpb-contrato like contrato.
def new shared temp-table tpb-contnf
        field etbcod  like contnf.etbcod
        field placod  like contnf.placod
        field contnum like contnf.contnum
        field marca   as   char format "x".

def new shared temp-table tt-liped like com.liped.

def var vparam as char.
def var v-arquivo as char.
def var valt-brinde as log.
def var vchqpres as log.
def var vdesfaz as log.

def new shared var vnumero-chp  like titulo.titnum.
def new shared var vvalor-chp   like titulo.titvlcob.
def new shared var vnumero-chpu like titulo.titnum.
def new shared var vvalor-chpu  like titulo.titvlcob.

def var vnumero-chpu-aux as int format ">>>>>>>9".
def var vdescper as dec format ">>9.99 %".
def var vescd as char format "x(15)" extent 3
                 init ["1. Valor     ", "2. Percentual", "3. Funcion�rio"].
def var vtipo-desc as int.
def var vusacartao as int.
def var vqtdcel    as int.
def var vqtdchip   as int.
def var vprocel    as log.
def var vprochip   as log.
def var vqtdcartao as int.

def var vusabone as int.
def var vqtdtenis as int.
def var vprobone as log.
def var vqtdbone as int.

def var vprocod-menor as recid.
def var vprocod-maior as recid.
def var vmovpc-menor as dec.
def var vmovpc-maior as dec.
def var vqtdpro as int.

def temp-table tt-promo
    field rec-pro as recid
    field movpc   like movim.movpc
    field prpromo as dec.

def var maior_valor like movim.movpc.
def var menor_valor like movim.movpc.
def var qtd_inverno as int.
def var xx as char.
def var preco_des like movim.movpc.
def var qtd_movim as int.
def var vcor-15 as char format "x(15)".
def var vcor-20 as char format "x(20)".
def var vcor-151 as char format "x(5)".
def var vcor-152 as char format "x(5)".
def var vletras as char 
    init "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z".
def var vnumeros as char 
    init "0,1,2,3,4,5,6,7,8,9".

def var i-cont as int.
def var vopecod like operadoras.opecod.
def var vpreco-calculado like movim.movpc.
/*def var preco_ori      like movim.movpc.*/
def var vmoecod like moeda.moecod.
def var vfuncod like func.funcod.
def buffer dprodu for produ.
def var vsenha  as char.
def var dsresp as log init no.
def buffer bfunc for func.
def var vlogs as char.
def var vinfo-VIVO as char.
def var v-utiliza-preco-plano-plaviv as log initial no.

def new shared temp-table tt-planos-vivo
    field procod like produ.procod
    field tipviv as   int
    field codviv as   int
    field pretab as   dec
    field prepro as   dec.

def var valor-dif             like plani.platot.
def var vult-p                like produ.procod.
def var vv as int.
def var recpla                as recid.
def var varq                  as char.
/*DESATIVADO-HELIO def var spacote               as char.                          
def var spacpre               as char. 
def var vnumeracao-automatica as log.  */
def var par-valor as char. 
def var vlipcor-bonus like liped.lipcor format "x(20)".
def buffer bbprodu for produ.
def buffer bbestoq for estoq.
def new shared temp-table tt-bonusviv like bonusviv.
def new shared var vtipviv like habil.tipviv.
def new shared var vcodviv like habil.codviv.
def var vccid    as int. /* #1 */

vende-garan = no.
run lemestre.p (input "ativa-garantia", output par-valor).     
vende-garan = par-valor = "SIM".
vende-seguro = no.
run lemestre.p (input "VENDE-SEGURO", output par-valor).     
vende-seguro = par-valor = "SIM".


def temp-table twf-movim like wf-movim.

def buffer bwf-movim for wf-movim.
def var vprocod1 like com.produ.procod.
def var vetbcod1 like ger.estab.etbcod.

scli = 0.
def var vnumero like plani.numero.
def var vserie  like plani.serie.
def var vok as log.
def var vdia as int.
def var parametro as char format "x(20)".
def var funcao          as char format "x(20)".
def var vgera like geranum.clicod.
def var par-men     as char.
def var vcredito as char.
def new shared var vdata-teste-promo as date init ?.
def var vmensagem as char format "x(45)".

empty temp-table tt-descfunc.

form
    space(1) vmensagem
    with frame f-chp row 19 side-label overlay column 23
                width 58 no-box no-label.

form
    skip(1)
    par-men
    skip(1)
    with frame ferro
        centered color normal/message row 10 no-label.

def var vprocod-bonus     as dec format ">>>>>>>>>>>>9".

assign
    vopv[1]     = 01
    vopv[2]     = 02
    vopv[3]     = 03
    vopv[4]     = 04
    vopv[5]     = 05
    vopcre[1]   = "F5 = Crediario/Vista"
    vopcre[2]   = /*"[C]= Cartao Credito"*/ "[B]= Black Friday"
    vopcre[3]   = "[E]= Exclui Produto".

form regua1 with frame f-regua1
        row 19 no-labels side-labels column 1 centered title "Operacoes".

form produ.pronom   format "x(30)"
        help "ENTER=Altera  F4=Encerra"
    wf-movim.movqtm         format ">>>9" column-label "Qtd"
    wf-movim.movpc          column-label "Preco"
    with frame f-desc
        centered down title " Produtos da Nota Fiscal " overlay row 5.

def var vtipo-ag as char.
vtipo-ag = "AG2".

    
def var volta-preco as log init no.                 
def var vclichar as char.

bl-princ:
repeat with centered row 3 side-label width 80 1 down
        no-box color message frame fcli:

    vapiconsultarproduto = YES. /* LIGADO */
    p-supervisor = "".
    vpromocod = "".
    
    for each twf-movim: delete twf-movim. end. for each wf-imei. delete wf-imei. end.
    
    if volta-preco = yes
    then  do:
        run volta-preco.
        run p-atu-frame.
    end.

    for each wbonus: delete wbonus. end.
    for each tt-bonusviv: delete tt-bonusviv. end.

    hide frame fsenha no-pause.
    vmens = "Digite o CPF ou Leia o codigo do cliente" /*CARTAO 16112022 helio - retirado*/.
    /*verus
    disp vmens with frame f-mensagem width 80.
    */
    hide frame f-desti no-pause. /* 23012023 helio - ajuste projeto cupom desconto b2b */
    hide message no-pause.
    message vmens.
    
    assign /*vclicod = scli*/ 
           vult-p  = 0
           vinfo-VIVO = ""
           vitem   = 0 
           vbonus  = 0 
           vmoecod = "".
    
    if vclicod = 0  or
       vclicod = 1
    then do on error undo:
        scartao = "".
        /* helio 16112022 novo codigo por clien.ciccgc */
        update vclichar label "CPF" format "x(11)".
        
        if vclichar <> "" and
           vclichar <> "0" 
        then do:   
            /* helio 16112022*/ 
            find clien where clien.ciccgc = vclichar no-lock no-error.         
            if avail clien 
            then do: 
                vclicod = clien.clicod. 
            end.
            else do:
                find clien where clien.clicod = int(vclichar) no-lock no-error.
                if avail clien
                then vclicod = clien.clicod.
            end.

        disp vclichar.
        sal-aberto = 0.
        lim-calculado = 0.
        vlimcrd = 0.
        
        if vclicod > 0
        then do:
            find clien where clien.clicod = vclicod no-lock no-error.
            if not avail clien
            then do:
                message "Cliente nao cadastrado." view-as alert-box.
                undo.
            end.
            
            vclichar = clien.ciccgc.
            
            disp vclichar
                clien.clinom no-label format "x(40)"
                clien.clicod no-label .
            find cpclien where cpclien.clicod = vclicod no-lock no-error.
        
            if vclicod > 1
            then do:
                vdiscre = no.
                run credito.
                if lim-calculado <= 100 /*clien.limcrd < 200*/
                then do:
                    /*vmen-cre = "      FAVOR ATUALIZAR O CADASTRO".
                    run mens-credito.
                    leave bl-princ.
                    */
                end.
                else do:
                    vmen-cre = "      PARABENS, SEU LIMITE � DE R$ " + 
                            string(vlimcrd,">>,>>9.99").
                    run mens-credito.
                    vdiscre = yes.
                    run credito.
                    disp string(day(clien.dtnasc),"99") + "/" +
                         string(month(clien.dtnasc),"99")
                         label "       Aniversario" format "x(6)"
                         clien.dtcad label "Cliente desde"
                                format "99/99/9999"
                                with frame f-aniver 1 down no-box side-label.

                    v-cmp = 0.
                    disp "" at 1 with frame ffff1
                        no-label no-box. 
                    pause 0.
                    
                    /*** HELIO DESATIVADO - ESTA ERRADO
                    if (clien.medatr > 0 and
                        clien.medatr < today - dat-vencto)
                       or clien.medatr = ? and dat-vencto < today
                    then do:
                        vmens = "                    " +
                         "Parcela(s) em aberto desde " +
                        string(dat-vencto,"99/99/9999") .
                        hide message no-pause.
                        message vmens.
                        /*verus
                            disp vmens with frame f-mensagem width 80.
                            */
                    end.  
                     ***/
                    
                    pause.
                end.
            end.
        end. 
        end.
        else do:
            if vclichar = ""
            then vclicod = 0.
            else vclicod = int(vclichar).
            find clien where clien.clicod = vclicod no-lock no-error.
            vclichar = string(vclicod).
            disp vclichar
                 clien.clinom no-label.
         end.       
    end.
    else do:
        find clien where clien.clicod = vclicod no-lock no-error.
        vclichar = string(vclicod).
        disp vclichar
             clien.clinom no-label.
    end.
    hide frame f-regua1 no-pause.
    hide frame f-vende  no-pause.
/*verus    hide frame f-desti  no-pause.*/

    vmens = "Caixa Aberto  -  F10 = Troca Cliente" .
    hide message no-pause.
    message vmens.
    /*verus
    disp vmens with frame f-mensagem.
    */

    /*
    display "OPERACOES" format "x(20)" with frame f-opcom-titulo
            row 14 color message.
    pause 0.
    */
    def var vtitulo-opcom as char init "     OPERACOES".
    display vtitulo-opcom format "x(21)"
    /*
            vopcre[1]
            vopcre[2]
            vopcre[3]*/
            "F5 = Crediario/Vista"
            "[L]= Lista Produtos"
            "[S]= Cartao Presente"
            "[G]= Garantia/RFQ"
        with frame f-opcom row 17 no-label 1 column column 2 color white/red
            no-box /*title "OPERACOES"*/.
    color disp message vtitulo-opcom with frame f-opcom.
    pause 0.

    view frame f-chp.
    view frame f-produ1.
    
    bl-plano:
    do on error undo.
        hide frame f-finan no-pause.
        view frame f-opcom.
        repeat with 1 down on endkey undo, return:
            /*17.01.2020 verus - resgate cupomdesconto */
            for each wf-movim.
                wf-movim.movpc    = wf-movim.movpc + (wf-movim.desconto / wf-movim.movqtm). 
                wf-movim.desconto = 0.
            end.
            run p-atu-frame.
            /*17.01.2020 verus - resgate cupomdesconto */
            
            /****verus
            hide frame f-mensagem no-pause.
            disp vmens no-label format "x(80)"
              with frame f-mens1 color message row screen-lines
             overlay no-box width 80.
             ****/
             
            hide frame f-exclusao no-pause.
            /* helio 12112021
            display vopcre with frame f-opcom.
            */
            clear frame fsenha all.
            hide frame fsenha no-pause.

            vmens = "Inclua Produtos ou Tecle [R] para ver DISPONIBILIDADE"
            + " ou [O] para OUTRAS OPCOES".

            hide message no-pause.
            message vmens.
            vmostradet = yes.
            update vprocod
                   go-on (F5 F6 B b F9 F10 E e A a P p L l S s r R o O G g)
                        with frame f-produ.
            if vprocod = 0
            then undo.
            
            
            assign vusacartao = 0 
                   vqtdcel    = 0 
                   vqtdchip   = 0
                   vqtdcartao = 0
                   vqtdtenis = 0
                   vqtdbone = 0
                   vchqpres = no.

            find produ where produ.procod = int(vprocod) no-lock no-error.
            if not avail produ
            then do:
                find first produ where produ.proindice = input vprocod
                                 no-lock no-error.
                if avail produ
                then vprocod = produ.procod.
            end.
            find produ where produ.procod = int(vprocod) no-lock no-error.
            if not avail produ
                then do:
                    find first produ where produ.proindice = input vprocod
                                     no-lock no-error.
                    if not avail produ
                    then do:                 
                        sresp = yes.
                        message "Produto nao Cadastrado!".
                        undo.
                    end.
                    else if vprocod = 0
                         then undo, retry.
                end.

            if avail produ and keyfunction(lastkey) = "return" 
            then do: 
            
                /* HELIO 27062022 Projeto Normativas ST Mercadorias */
                find first ttst no-error.
                if avail ttst
                then do:
                    find first ttst where ttst.ncm = produ.codfis no-error.
                    if avail ttst
                    then do:
                        if produ.proipiper = 99 /* ST */
                        then do on error undo:
                            find current produ exclusive.
                            produ.proipiper = 17.
                        end.
                        find current produ no-lock.
                    end.
                end.    
                                

                /** **/
                /* CHAMA API pdv/consultarProduto */
                run pdvapiconsultarproduto.p (setbcod, produ.procod).
                find current produ no-lock.
                
                if produ.proseq = 99 and setbcod = 65
                then .
                else if produ.proseq = 99
                then do:
                    message "Venda bloqueada para produto INATIVO."
                    view-as alert-box.
                    vprocod = 0.
                    undo.
                end.
                    
                /* helio 02082021 - mensagem */ 
                if produ.descontinuado 
                then do: 
                    sresp = no. 
                    run message.p  
                        (input-output sresp,  
                        input     "          PRODUTO DESCONTINUADO.        "  + 
                        "                                        "  +     
                        "    S� seguir com a venda se o mesmo    "  + 
                        " estiver dispon�vel no estoque na loja. "   + 
                        "                                        "  + 
                        "                CONTINUAR ?             ", 
                        input "").          
                    if sresp = no  
                    then undo. 
                end. 
                /* 02/08/2021 - mix por integracao barramento */                      
                vmix    = no. 
                do vloop = 1 to num-entries(produ.indicegenerico,"|"): 
                    if entry(vloop,produ.indicegenerico,"|") = "MIX#" + string(setbcod) 
                    then vmix = yes.
                end. 
                if not vmix and produ.catcod = 31 
                then do:
                    find first wf-movim where wf-movim.wrec = recid(produ) no-error.
                    if not avail wf-movim
                    then do: 
                        sresp = no.
                        run message.p  
                            (input-output sresp, 
                                input     "  Voce esta vendendo um produto que    " + 
                                          "     NAO PERTENCE AO MIX DA LOJA,      " +
                                          "                                       "  +   
                                          " preferencialmente devera ser entregue " +
                                          "            o mostruario.              " + 
                                          "Duvidas contate o setor Compras Moveis." +
                                          "                                       "  +
                                          "               CONTINUAR ?             ",
                                  input "").         
                        if sresp = no 
                        then undo.
                    end.         
                end. 

                /** TESTA KIT **/
                if acha2("KIT",produ.indicegenerico) = "SIM"
                then do:
                    if acha2("COMPONENTE",produ.indicegenerico) = "AGRUPADOR"
                    then do :
                        vlistaFilhos = acha2("FILHOS",produ.indicegenerico).
                        
                        do vi = 1 to num-entries(vlistaFilhos).
                            find fprodu where 
                                fprodu.procod = int(entry(vi,vlistaFilhos))
                                    no-lock no-error.
                            if not avail fprodu
                                   then next.

                            run pdvapiconsultarproduto.p (setbcod, fprodu.procod).
                        
                            vqtdKIT = 
                                int(acha2("QTDVENDA",fprodu.indicegenerico)).
                            if vqtdKIT = ? or vqtdKIT = 0
                            then vqtdKIT = 1.       
                            find festoq where
                                festoq.procod = fprodu.procod and
                                festoq.etbcod = setbcod 
                                no-lock no-error.
                            find first wf-movim where 
                                         wf-movim.wrec = recid(fprodu)
                                         no-lock no-error.
                            if not avail wf-movim 
                            then do:   
                                create wf-movim. 
                                assign wf-movim.wrec      = recid(fprodu)
                                       wf-movim.movalicms = 17
                                       wf-movim.movpc     = 0.01.
                                       
                                    wf-movim.KITproagr = produ.procod.
                                           
                              end.
                              assign wf-movim.movqtm   = wf-movim.movqtm 
                                            + vqtdKIT.
                              if avail festoq
                              then do: 
                                wf-movim.precoori = festoq.estvenda. 
                                wf-movim.movpc    = festoq.estvenda.
                              end.       
                            
                        end.
                        run p-atu-frame.
                        next.
                    end.
                    if acha2("COMPONENTE",produ.indicegenerico) = "FILHO"
                    then do :
                        if acha2("VENDAAVULSA",produ.indicegenerico) = "NAO"
                        then do : 
                            
                           aux-procod = 
                            int(acha2("AGRUPADOR",produ.indicegenerico)).
                           find bprodu where bprodu.procod = aux-procod
                           no-lock no-error.
                            if avail bprodu
                           then 
                           message "Produto Componente do CODIGO"
                                 aux-procod
                                 bprodu.pronom SKIP(2)
                                 "VENDA NAO PERMITIDA"
                                 view-as alert-box.
                           next. 
                        end.            
                    end.                    
                end.
                /* KIT */
                            
                if (produ.pronom begins "SALDO" or
                   produ.pronom begins "PRODUTO PROMOCIONAL") AND
                   setbcod <> 65 and setbcod <> 107 and setbcod <> 128
                   /* Alteradas as filiais de saldo em 28/10/14 */
                then do:
                    message color red/with
                    "Venda bloqueada para produtos de SALDO ou PROMOCIONAL"
                    view-as alert-box.
                    next.
                END.
                if (produ.pronom begins "CARTAO PRESENTE" or
                    produ.procod = 10000)
                then do:
                    find first wf-movim where wf-movim.wrec <>
                                    recid(produ) no-lock no-error.
                    if avail wf-movim
                    then do:
                        message "Cartao Presente deve ser vendido separado".
                        pause 2 no-message.
                        next.
                    end.
                end.
            end.

            find produ where produ.procod = int(vprocod) no-lock no-error.
            find estoq where estoq.etbcod = setbcod 
                         and estoq.procod = int(vprocod) no-lock no-error.
             
            def var vestatual_cd   as   dec. 
            def var vpedid_abe     like liped.lipqtd. 
            def var vestoq_fil     like estoq.estatual.
            
            /* Projeto Rollout M�veis no Profimetrics
               nao vai ser implantada esta parte do projeto
            if avail estoq and estoq.estloc <> ""
            then do.                
                vestatual_cd  = int(entry(1,estoq.estloc,"|")).
                vpedid_abe    = int(entry(2,estoq.estloc,"|")).
                vestoq_fil    = int(entry(3,estoq.estloc,"|")).
                if produ.descontinuado = yes and 
                   produ.proipival <> 1 and
                   vestatual_cd <= 0 and
                   vpedid_abe   <= 0 and
                   vestoq_fil   <= 0
                then do on endkey undo.    
                    message color red/with
                        "Venda bloqueada para produtos DESCONTINUADOS. " skip
                        "Filial " setbcod       skip
                        "Saldo CD =" vestatual_cd   skip
                        "Pedidos =" vpedid_abe          skip
                        "Saldo Filial =" vestoq_fil
                        view-as alert-box.
                        next.
                end.
                if produ.descontinuado = yes and
                   produ.proipival <> 1 and  
                   vestatual_cd <= 0 and
                   vpedid_abe   <= 0 and
                   vestoq_fil   > 0
                then do.    
                    message color red/with
                        "ENTREGA DE MOSTRUARIO. "  skip
                        "Filial " setbcod          skip
                        "Saldo CD =" vestatual_cd   skip
                        "Pedidos =" vpedid_abe         skip
                        "Com estoque Filial =" vestoq_fil
                        view-as alert-box.
                end.
            end. 
            */

            /**/
            vrecarga = no.
            vproduto = no.
            for each wf-movim:
                find produ where recid(produ) = wf-movim.wrec no-lock.
                if produ.fabcod = 5146 and 
                   produ.pronom begins "TENIS"
                then vqtdtenis = vqtdtenis + wf-movim.movqtm.
                if produ.procod = 479262
                then vqtdbone = vqtdbone + wf-movim.movqtm.

                if produ.procod = 404973
                then vqtdcel = vqtdcel + wf-movim.movqtm.
                if produ.procod = 404913
                then vqtdcartao = vqtdcartao + wf-movim.movqtm.

                if (produ.pronom begins "CHEQUE PRESENTE" or
                    produ.pronom begins "CARTAO PRESENTE" or
                    produ.procod = 10000)
                then vchqpres = yes.

                if produ.pronom matches "*RECARGA*"
                then vrecarga = yes.
                else vproduto = yes.
            end.

            find produ where produ.procod = int(vprocod) no-lock no-error.
            if avail produ
            then do:
                if ((not produ.pronom matches "*RECARGA*") and vrecarga) or
                   (produ.pronom matches "*RECARGA*" and vproduto)
                then do.
                    message "Venda com produto e recarga nao permitida"
                        view-as alert-box.
                    next.
                end.
                
                if produ.fabcod = 5146 and 
                   produ.pronom begins "TENIS"
                then vqtdtenis = vqtdtenis + 1.
                
                if produ.procod = 479262
                then vqtdbone = vqtdbone + 1.
                
                if produ.procod = 404973
                then vqtdcel = vqtdcel + 1.

                if produ.procod = 404913
                then vqtdcartao = vqtdcartao + 1.
            end.
            
            if vchqpres = yes and keyfunction(lastkey) = "return"
            then do:
                message "Cartao Presente deve ser vendido separado".
                pause 2 no-message.
                next.
            end.
            
            if vprocod <> vult-p
            then do:
                /************************************************************
                  Solicita plano apenas para produto que n�o possui a palavra 
                   CHIP no nome.
                ************************************************************/
                  
                if produ.corcod = "CUP"
                   and not produ.pronom matches ("*chip*") 
                   and keyfunction(lastkey) = "Return"
                then do:
                    release plaviv.    

                    run esc-ope.p (output vopecod). 
                    

                    find operadoras where 
                         operadoras.opecod = vopecod no-lock no-error.
                    
                    disp vopecod label "Operadora....." format ">>>9"
                         operadoras.openom format "x(10)" no-label  
                                  when avail operadoras
                                  with frame f-plaviv.
                    pause 0.
                    run esc-pro.p (input vopecod, output vtipviv).
                    
                    disp skip
                         vtipviv label "Servi�o......." format ">>>9"
                         with frame f-plaviv.
                           
                    find promoviv where promoviv.opecod = vopecod 
                                    and promoviv.tipviv = vtipviv 
                                    no-lock no-error.
                    if not avail promoviv
                    then do:
                        message "Servi�o n�o encontrado.".
                        pause.
                        undo.
                    end.
                    
                    disp promoviv.provivnom no-label when avail promoviv
                         with frame f-plaviv.
                    pause 0.

                    /* Se o Servi�o selecionado N�O � pr�-pago */
                    if promoviv.provivnom <> "PRE PAGO"
                    then do:
                        run esc-pla.p(input vtipviv, 
                                  input vopecod,
                                  output vcodviv).
                        disp skip 
                             vcodviv label "Plano........."  format ">>>9"
                             with frame f-plaviv centered side-labels.
                        find planoviv where 
                             planoviv.codviv = vcodviv no-lock no-error.
                        if not avail planoviv
                        then do:
                            message "Plano nao encontrado.".
                            pause.
                            undo.
                        end.
                        disp planoviv.planomviv no-label with frame f-plaviv.
                        pause 2 no-message.
                    
                        find plaviv where plaviv.tipviv = promoviv.tipviv
                                      and plaviv.codviv = planoviv.codviv
                                      and plaviv.procod = int(vprocod)
                                      and plaviv.exportado = true
                                      no-lock no-error.
                        if avail plaviv and
                           (plaviv.dtini = ? or
                            plaviv.dtfin = ? or
                            plaviv.dtini > today or
                            plaviv.dtfin < today)
                        then do:
                            if today > plaviv.dtfin
                            then release plaviv.
                            else if today < plaviv.dtini
                            then release plaviv.
                            else release plaviv.
                        end.

                        /**************************************************
                            Valida se plano de telefonia � v�lido para
                            a Filial
                         **************************************************/
                        
                        if avail plaviv
                        then find first plaviv_filial
                                  where plaviv_filial.tipviv = plaviv.tipviv
                                    and plaviv_filial.codviv = plaviv.codviv
                                    and plaviv_filial.procod = plaviv.procod
                                    and plaviv_filial.etbcod = setbcod
                                        no-lock no-error.
                        if not avail plaviv_filial
                        then find first plaviv_filial
                                  where plaviv_filial.tipviv = plaviv.tipviv
                                    and plaviv_filial.codviv = plaviv.codviv
                                    and plaviv_filial.procod = plaviv.procod
                                    and plaviv_filial.etbcod = 0
                                        no-lock no-error.
                        if not avail plaviv_filial
                            and avail plaviv             
                        then do:
                            release plaviv.
                            release plaviv_filial.
                        end.
                        
                        if avail plaviv and
                            ((plaviv.tipviv = 2 and plaviv.codviv = 5) or
                             (plaviv.tipviv = 5 and plaviv.codviv = 5))
                        then do:
                            sresp = no.
                            message "Deseja incluir o Bonus?" update sresp.
                            if sresp
                            then do:
                            do on error undo:
                              update skip
                                     vprocod-bonus label "Celular Bonus."
                                     with frame f-plaviv centered side-labels.

                              if vprocod-bonus = 404751 or
                                 vprocod-bonus = 403619 or
                                 vprocod-bonus = 403786 or
                                 vprocod-bonus = 403793
                              then.
                              else do:
                                  message "Este produto nao esta liberado para ~Bonus". undo.
                              end.
                        
                              find bbprodu where
                                   bbprodu.procod = int(vprocod-bonus)
                                   no-lock no-error.
                              if not avail bbprodu
                              then do:
                                message "Produto nao Cadastrado".
                                undo.
                              end.
                              disp bbprodu.pronom no-label 
                                format "x(40)" skip with frame f-plaviv.
                              
                              find bbestoq where bbestoq.etbcod = setbcod and
                                                 bbestoq.procod = bbprodu.procod
                                                 no-lock no-error.
                              if not avail bbestoq
                              then do:
                                message "Produto sem estoque".
                                undo.
                              end.
                              
                              find first wf-movim where 
                                         wf-movim.wrec = recid(bbprodu)
                                         no-lock no-error.
                              if not avail wf-movim
                              then do:
                                  create wf-movim.
                                  assign wf-movim.wrec      = recid(bbprodu)
                                         wf-movim.movalicms = 17
                                         wf-movim.movpc     = 0.01.
                              end.

                              assign wf-movim.movqtm   = wf-movim.movqtm + 1
                                     wf-movim.precoori = bbestoq.estvenda
                                     wf-movim.movpc    = 0.01.
                              
                              
                              find tt-bonusviv where
                                   tt-bonusviv.tipviv   = plaviv.tipviv  and
                                   tt-bonusviv.codviv   = plaviv.codviv  and
                                   tt-bonusviv.procod   = int(vprocod)   and
                                   tt-bonusviv.probonus = bbprodu.procod 
                                   no-error.
                              if not avail tt-bonusviv
                              then do:
                                create tt-bonusviv.
                                assign tt-bonusviv.tipviv = plaviv.tipviv
                                       tt-bonusviv.codviv = plaviv.codviv
                                       tt-bonusviv.procod = int(vprocod)
                                       tt-bonusviv.probonus = bbprodu.procod
                                       tt-bonusviv.exportado = no.
                              end.
                              
                              vlipcor-bonus = "".
                              if bbprodu.corcod = "PED" or
                                 bbprodu.corcod = "CUP"
                              then do:
                                do on error undo:
                                    update vlipcor-bonus format "x(20)"
                                           label "ESN Bonus....."
                                           with frame f-plaviv.
                                    if vlipcor-bonus = ""
                                    then undo.
                                    wf-movim.lipcor = vlipcor-bonus.
                                end.    
                              end.
                            end.
                            end.
                        end.
                        
                        vult-p = vprocod.    
                        hide frame f-plaviv no-pause.

                        if avail plaviv
                        then do:
                            run grava-notobs3.                 

                            find first tt-planos-vivo where
                                       tt-planos-vivo.procod = int(vprocod) and
                                       tt-planos-vivo.tipviv = plaviv.tipviv and
                                       tt-planos-vivo.codviv = plaviv.codviv
                                    no-error.
                            if not avail tt-planos-vivo
                            then do:
                                create tt-planos-vivo.
                                assign tt-planos-vivo.procod = int(vprocod)
                                       tt-planos-vivo.tipviv = plaviv.tipviv
                                       tt-planos-vivo.codviv = plaviv.codviv
                                       tt-planos-vivo.pretab = plaviv.pretab
                                       tt-planos-vivo.prepro = plaviv.prepro.
                            end. 
                        end.
                    end.
                    else assign vult-p = vprocod.
                end.
                else release plaviv.
            end.
            if lastkey = keycode("G") or lastkey = keycode("g")
            then do:
                if not vende-garan
                then next.
                find first wf-movim no-lock no-error.
                if not avail wf-movim
                then do:
                    message "Venda Sem Mercadoria".
                    pause.
                    next.
                end.
                run segur_pre.p.
                run p-atu-frame.
                next.
            end.

            if lastkey = keycode("L") or lastkey = keycode("l")
            then do:
                find first wf-movim no-error.
                if not avail wf-movim
                then do:
                    message "Venda Sem Mercadoria".
                    pause.
                    undo, retry.
                end.                
                vmens = "Consultando Produtos Incluidos na Pre-Venda.".
                hide message no-pause.
                message vmens.
                /*verus
                disp vmens  with frame f-mensagem.
                */
                /*pause 0*/
                run list_pre.p.
                next.
            end.
            
            if lastkey = keycode("T") or lastkey = keycode("t")
            then do on endkey undo, retry: 
                {tecla-t.i}
            end.

            if lastkey = keycode("S") or lastkey = keycode("s")
            then do on endkey undo, retry: 
                {tecla-s.i}
            end.
            
            if lastkey = keycode("P") or lastkey = keycode("p")
            then do on endkey undo, retry:
                {tecla-p.i}
            end.
         
            if lastkey = keycode("a") or lastkey = keycode("A")
            then do:
                
                run fluxo-desconto.
                
                run p-atu-frame.
                next.
                
            end. /* if lastkey = keycode("A") */
             

            if lastkey = keycode("r") or lastkey = keycode("R")
            then do:
                run estoque-disponivel.
                next.
            end.
            if lastkey = keycode("o") or lastkey = keycode("O")
            then do:
                find first wf-movim no-error.
                if avail wf-movim
                then run outras-opcoes.
                next.
            end.
            if lastkey = keycode("e") or lastkey = keycode("E")
            then do:
                update v-procod
                    with frame f-exclusao row 6 overlay side-label centered
                        width 80 color message  no-box .
                
                find produ where produ.procod =  v-procod no-lock no-error.
                if not avail produ
                then do:
                     message "Produto nao Cadastrado".
                     undo.
                end.

                find first wf-movim where
                           wf-movim.wrec = recid(produ) no-error.
                if not avail wf-movim
                then do:
                    message "Produto nao pertence a esta nota".
                    undo.
                end.

                if wf-movim.movalicms = 98 /* #2 */
                then do.
                    message "Produto nao pode ser excluido" view-as alert-box.
                    undo.
                end.

                display
                    produ.pronom format "x(30)" no-label
                    with frame f-exclusao.

                if wf-movim.KITproagr <> 0
                then do:
                    if acha2("VENDAAVULSA",produ.indicegenerico) = "NAO"
                    then do:
                        find bprodu where bprodu.procod = wf-movim.KITproagr
                            no-lock.
                    
                        message "Produto Componente do CODIGO"
                                 wf-movim.KITproagr
                                 bprodu.pronom
                                 view-as alert-box.
                        message "Excluir O PRODUTO AGRUPADOR" 
                            wf-movim.KITproagr
                            update sresp.
                        if sresp
                        then do:
                            aux-procod = wf-movim.kitproagr.
                            for each bwf-movim where 
                                bwf-movim.kitproagr = aux-procod.
                                delete bwf-movim.
                            end.    
                            run p-atu-frame.
                            next.
                        end.     
                        else undo.
                    end.
                end.                
                if wf-movim.movqtm <> 1
                then do :
                    update vqtd validate( vqtd <= wf-movim.movqtm,
                        "Quantidade invalida" )
                        label "Qtd" format ">>>9" with frame f-exclusao.
                end.
                else do:
                    vqtd = 1.
                    display vqtd with frame f-exclusao.
                    if vende-garan
                    then run exclui-segprod (produ.procod, 0).
                end.
                
                find first wf-movim where
                           wf-movim.wrec = recid(produ) no-error.
                if avail wf-movim
                then
                    if wf-movim.movqtm = vqtd
                    then do:
                          find first tt-prodesc where 
                               tt-prodesc.procod = produ.procod   and
                               tt-prodesc.desco  = yes  no-lock no-error.
                        if avail tt-prodesc
                        then delete tt-prodesc. 
                        delete wf-movim.
                    end.
                        
                    else wf-movim.movqtm = wf-movim.movqtm - vqtd.
                run p-atu-frame.
                next.
            end.

            if lastkey = keycode("F5")
            then do:
                for each wf-movim no-lock,
                    first produ where recid(produ) = wf-movim.wrec
                            no-lock by produ.procod:
                    create twf-movim.
                    buffer-copy wf-movim to twf-movim.
                end.    
                for each wf-movim: delete wf-movim. end. 
                for each twf-movim:
                    create wf-movim.
                    buffer-copy twf-movim to wf-movim.
                end.
                    
                def var v-verchip as log init no.
                def var v-qtdchip as int.
                def var v-verchip2 as log init no.
                def var v-qtdchip2 as int.

                /*** vivo gsm ***/
                def var vvalida-cel as log init no.
                def var vvalida-chip as log init no.
                def var v-verchip-vivo as log init no.
                def var v-qtdchip-vivo as int.
                
                def var v-verchip2-vivo as log init no.
                def var v-qtdchip2-vivo as int.
                def var vpro405690 as log init no.
                
                assign v-qtdchip-vivo = 0
                       v-verchip-vivo = no.

                /*** vivo gsm ***/
 
                assign v-qtdchip = 0
                       v-verchip = no.
                
                for each wf-movim:
                    find produ where recid(produ) = wf-movim.wrec no-lock.
                    
                    if produ.pronom begins "TELEFONE TIM"
                    then assign v-qtdchip = v-qtdchip + 1
                                v-verchip = yes.

                    if produ.clacod = 107
                    then assign v-qtdchip-vivo = v-qtdchip-vivo + 1
                                v-verchip-vivo = yes.

                    if produ.clacod = 107
                    then vvalida-cel = yes.
                    
                    if produ.clacod = 108
                    then vvalida-chip = yes.

                    if produ.procod = 405690 or
                       produ.procod = 413529 or
                       produ.procod = 405661 or
                       produ.procod = 405662
                    then vpro405690 = yes.
                end.

                if vpro405690 = no
                then
                    if vvalida-cel = no and vvalida-chip = yes
                    then do:
                        message "Venda de CHIP somente com TELEFONE.".
                        pause 2 no-message.
                        undo, retry.
                    end.
                
                if v-verchip
                then do:
                    assign v-qtdchip2 = 0
                           v-verchip2 = no.

                    for each wf-movim:
                        find produ where recid(produ) = wf-movim.wrec no-lock.
                        if produ.pronom begins "TIM CHIP"
                        then assign v-qtdchip2 = v-qtdchip2 + 1
                                    v-verchip2 = yes.
                    end.

                    if not v-verchip2
                    then do:
                        if v-qtdchip <> v-qtdchip2
                        then do:
                            if v-qtdchip > v-qtdchip2
                            then do:
                                message "A quantidade de Telefones e maior que a quantidade de CHIPS". pause 2 no-message.
                                undo, retry.
                            end.
                            else
                            if v-qtdchip > v-qtdchip2
                            then do:
                                message "A quantidade de CHIPS e maior que a quantidade de TELEFONES". pause 2 no-message.
                                undo, retry.
                            end.
                        end.
                    end.
                end.
                
                if v-verchip-vivo
                then do:        
                    assign v-qtdchip2-vivo = 0
                           v-verchip2-vivo = no.

                    for each wf-movim:
                        find produ where recid(produ) = wf-movim.wrec no-lock.
                        if produ.clacod = 108
                        then assign v-qtdchip2-vivo = v-qtdchip2-vivo + 1
                                    v-verchip2-vivo = yes.

                        if produ.procod = 405690
                        then vpro405690 = yes.
                    end.

                    if not v-verchip2-vivo
                    then do:
                        if v-qtdchip-vivo <> v-qtdchip2-vivo
                        then do:
                            if v-qtdchip-vivo > v-qtdchip2-vivo
                            then do:
                                message "A quantidade de Telefones e maior que ~~a quantidade de CHIPS". pause 2 no-message.
                                undo, retry.
                            end.
                            else
                            if v-qtdchip-vivo > v-qtdchip2-vivo
                            then do:
                                message "A quantidade de CHIPS e maior que a qu~~antidade de TELEFONES". pause 2 no-message.
                                undo, retry.
                            end.
                        end.
                    end.
                end.
                
                vopcod = vopv[2].
                vmostradet = no.
                hide frame fdet no-pause.
                leave.
            end.
            
            find estoq where estoq.procod = int(vprocod)
                         and estoq.etbcod = setbcod
                       no-lock no-error.
            
                find produ where produ.procod = int(vprocod) 
                           no-lock no-error.
                if not avail produ
                then do:
                    find first produ where produ.proindice = input vprocod
                                     no-lock no-error.
                    if not avail produ
                    then do:                 
                        message "Produto nao Cadastrado!!".
                        undo.
                    end.
                    else if vprocod = 0
                         then undo, retry.
                end.

                display produ.pronom with frame f-produ.
                
                find estoq where estoq.procod = produ.procod
                             and estoq.etbcod = setbcod
                           no-lock no-error.
                if not available estoq
                then do.
                        message "Sem registro de ESTOQUE" view-as alert-box.
                        next.
                end.
                if not produ.pronom begins "CARTAO PRESENTE" and
                   not produ.pronom begins "FRETE" and
                   estoq.estvenda = 0
                then do.
                    message "Produto sem PRECO" view-as alert-box.
                    next.
                end.

                vpreco = estoq.estvenda.
                vtextopromocao = "".
                if estoq.estbaldat <> ? and
                   estoq.estprodat <> ?
                then do:
                    if estoq.estbaldat <= today and
                       estoq.estprodat >= today
                    then do:
                        vpreco = estoq.estproper.   
                        vtextopromocao = "Preco Promocional de " + string(estoq.estbaldat,"99/99/9999") + " ate " + string(estoq.estprodat,"99/99/9999") + " R$ " +
                                        trim(string(estoq.estproper,"->>>>>>>>>>9.99")).
                    end.    
                end.
                else do:
                    if estoq.estprodat <> ?
                    then if estoq.estprodat >= today
                         then do:
                            vpreco = estoq.estproper.
                            vtextopromocao = "Preco Promocional ate " + string(estoq.estprodat,"99/99/9999") + " R$ " +
                                        trim(string(estoq.estproper,"->>>>>>>>>>9.99")).

                         end.   
                end.

                hide message no-pause.
                
                find first wf-movim where wf-movim.wrec = recid(produ)
                                    no-lock no-error.
                if avail wf-movim
                then vpreco = wf-movim.movpc.
                
                assign v-utiliza-preco-plano-plaviv = no.
                
                if avail plaviv
                then do:
                    assign vpreco = plaviv.prepro.
                    
                    assign v-utiliza-preco-plano-plaviv = yes.
                    
                    find first tt-promo where tt-promo.rec-pro = recid(produ)
                                        no-lock no-error.
                    if not avail tt-promo
                    then do:
                        create tt-promo.
                        assign tt-promo.rec-pro = recid(produ).
                    end.
                    if avail tt-promo and tt-promo.prpromo <> vpreco
                    then  assign tt-promo.prpromo = vpreco.
                end.

                display vpreco with frame f-produ. 

                /*** PRECO ESPECIAL ***/
                vpromoc = "".
                vlibera = no.
                
                if v-utiliza-preco-plano-plaviv = no
                then do on error undo , next:
                        parametro-in = "PRECO-ESPECIAL=S|PRODUTO=" +
                                    string(produ.procod) + "|".
                        run promo-venda.p(input parametro-in ,
                                          output parametro-out).

                        if acha("PROMOCAO",parametro-out) <> ? 
                        then vpromoc = acha("promocao",parametro-out).
                        else vpromoc = "".
                        
                        /*HELIO 11112022 - teste promocao limite quantidade*/
                        def var vqtdSolicitada as int.
                        def var vpromocaoLimite as char.
                        
                        vqtdSolicitada = 0.
                        find first wf-movim where wf-movim.wrec = recid(produ)
                                         no-error.
                        if avail wf-movim
                        then do: 
                            vqtdSolicitada = wf-movim.movqtm + 1.
                        end.        
                        else do:
                            vqtdSolicitada = 1.                    
                        end.
                        
                        vpromocaoLimite = "false".
                        if vpromoc <> ""
                        then do:
                            {lojapi-verificapromqtd.i vpromoc produ.procod vqtdSolicitada}
                        end.
                        
                        
                        if vpromocaoLimite = "false"
                        then do:                        
                            if acha("LIBERA-PRECO",parametro-out) <> ?
                            then vlibera = yes.
                            if acha("PRECO-ESPECIAL",parametro-out) <> ? and
                                dec(acha("PRECO-ESPECIAL",parametro-out)) > 0
                            then vpreco = dec(acha("PRECO-ESPECIAL",parametro-out)).
                        end.
               end.

                 /******/
               display vpreco with frame f-produ.
                
                find first wf-movim where wf-movim.wrec = recid(produ)
                                    no-lock no-error.
                if not avail wf-movim
                then do:
                    create wf-movim.
                    wf-movim.wrec  = recid(produ).
                    wf-movim.movalicms = 17.
                    wf-movim.movpc = vpreco.
            
                    if (produ.corcod = "PED" or
                        produ.corcod = "CUP") or
                       (produ.pronom matches("*RINCAO*") and
                                   produ.fabcod = 10242999) 
                    then do:
                      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO, retry:
                        if keyfunction(lastkey) = "end-error"
                        then do:
                            delete wf-movim.
                            vcor-20 = "".
                            vcor-15 = "".
                            leave.
                        end.
                        hide frame f-senha no-pause.
                        
                        if produ.pronom matches "*CHIP*"
                        then do:
                            update vcor-20 label "Caracteristica"
                                        format "x(20)"
                                        with frame f-cor side-label centered
                                                row 12 overlay
                                        title " Produto - " + string(vprocod).
                            run p-tbprice-ccid.
                            wf-movim.lipcor = vcor-20.
                        end.
                        else do:
                            if avail operadora
                            then DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO, retry:
                                if keyfunction(lastkey) = "end-error"
                                    then do:
                                    delete wf-movim.
                                    vcor-20 = "".
                                    vcor-15 = "".
                                    leave.
                                end.                                
                                
                                vcor-15 = "".
                                update vcor-15 label "Serial - ESN/IMEI"
                                        format "x(15)"
                                       with frame f-cor3 side-label centered
                                                row 12 overlay
                                        title " Produto - " + string(vprocod).
                                sresp = yes.
                                if vcor-15 <> ""
                                then do:
                                run esn_imei.p(input vcor-15, output sresp).
                                if sresp = no
                                then do:
                                    message color red/with
                                        "CAMPO OBRIGATORIO Serial - ESN/IMEI"
                                         skip
                                        "Favor informar os dados corretamente"
                                        view-as alert-box.
                                    undo.    
                                end.        
                                vparam = "".
                                vparam = "TIPO=" + trim(operadora.openom) 
                                        + "|SERIAL=" + vcor-15.
                                val-price = yes.
                                
                                sresp = yes.

                                run agil-price (input vcor-15,  /* verus */
                                                output sresp).
 
                                if keyfunction(lastkey) = "end-error"
                                   /* or not sresp */
                                then undo, retry.
                                
                                if val-price = no 
                                then undo.
                                end.
                                find first wf-imei where wf-imei.wrec  = wf-movim.wrec no-error.
                                if not avail wf-imei
                                then do:
                                    create wf-imei.
                                    wf-imei.wrec = wf-movim.wrec.
                                end.     
                                wf-imei.imei = vcor-15.
                            end.
                            else do:
                                if produ.pronom matches("*RINCAO*") and
                                   produ.fabcod = 10242999
                                then do on error undo:
                                    update vcor-151 label "Caracteristica - Cor Assento"
                                           format "x(5)" 
                                      with frame f-cor31 side-label centered
                                        row 12 overlay
                                        title " Produto - " + string(vprocod).

                                    if length(vcor-151) < 5 or
                                   lookup(substr(vcor-151,1,1),vletras) = 0 or
                                   lookup(substr(vcor-151,2,1),vnumeros) = 0 or
                                   lookup(substr(vcor-151,3,1),vnumeros) = 0 or
                                   lookup(substr(vcor-151,4,1),vnumeros) = 0 or
                                   lookup(substr(vcor-151,5,1),vnumeros) = 0
                                    then do:
                                        message "Cor Assento Invalida".
                                        undo.
                                    end.
                                    
                                    update vcor-152 label " Cor Encosto"
                                           format "x(5)" 
                                       with frame f-cor31.

                                    if length(vcor-152) < 5 or
                                   lookup(substr(vcor-152,1,1),vletras) = 0 or
                                   lookup(substr(vcor-152,2,1),vnumeros) = 0 or
                                   lookup(substr(vcor-152,3,1),vnumeros) = 0 or
                                   lookup(substr(vcor-152,4,1),vnumeros) = 0 or
                                   lookup(substr(vcor-152,5,1),vnumeros) = 0
                                    then do:
                                        message "Cor Encosto Invalida".
                                        undo.
                                    end.                                    
                                    
                                    vcor-15 = "Assento=" + vcor-151 + "|"
                                            + "Encosto=" + vcor-152.
                                    
                                    disp vcor-15 with frame f-cor2.
                                end.
                                if vcor-151 <> "" and vcor-152 <> ""
                                then disp vcor-15 with frame f-cor2 side-label
                                          centered row 12 overlay
                                          title " Produto - " + string(vprocod).
                                else
                                update vcor-15 label "Caracteristica"
                                        format "x(20)"
                                        with frame f-cor2 side-label centered
                                                row 12 overlay
                                        title " Produto - " + string(vprocod).
                                        
                                wf-movim.lipcor = vcor-15.
                            end.
                        end.
                      end. 
                    end.
                    
                end.

                
                assign
                    wf-movim.movqtm   = wf-movim.movqtm + 1
                    wf-movim.precoori = estoq.estvenda
                    wf-movim.vencod   = v-vencod
                    wf-movim.movpc    = vpreco.

                if wf-movim.movqtm >= 1   /* 555859 - Duas Garantias em produtos iguais PR� VENDA */
                then do:
                    parametro-in = "DESCONTO-ITEM=S|PRODUTO=" +
                                   string(produ.procod) + "|".
                    run promo-venda.p(input parametro-in,output parametro-out).
                    /* vender GE/RFQ */
                    if vende-garan
                    then do:
                        run vende-segprod (produ.procod, wf-movim.precoori, wf-movim.movpc).
                    end.    
                end.
                else
                    if vende-garan
                    then run exclui-segprod (produ.procod, 0).
           

            vprotot = 0.
            v-qtd = 0.
            
            clear frame f-produ1 all no-pause.
            
            vitem = 0.
            
            /*** CHP ***/
            if produ.pronom begins "CHEQUE PRESENTE" or
               produ.pronom begins "CARTAO PRESENTE" or
               produ.procod = 10000
            then do:
                do on error undo:
                    update vpreco with frame f-produ.
                    if vpreco < 10
                    then do:
                        message "Valor minimo do Cartao Presente = 10 Reais"
                                view-as alert-box.
                        undo.
                    end.
                    if vpreco > 200
                    then do:
                        message "Valor maximo do Cartao Presente = 200 Reais"
                                view-as alert-box.
                        undo.
                    end.
                    wf-movim.movpc = vpreco.
                end.
            end.
            /***********/
            
            vprobone = no.
            vprocel  = no.
            vprochip = no.

            /**   **/
            for each wf-movim:
                find produ where recid(produ) = wf-movim.wrec no-lock.

                    find first tt-promo where
                               tt-promo.rec-pro = wf-movim.wrec no-error.
                    if not avail tt-promo
                    then do:
                         find estoq where estoq.etbcod = setbcod and
                                          estoq.procod = produ.procod 
                                    no-lock no-error.
                         create tt-promo.
                         assign tt-promo.rec-pro = wf-movim.wrec
                                tt-promo.movpc = estoq.estvenda.
                         if estoq.estprodat <> ? and
                            estoq.estprodat >= today
                         then do:
                            if estoq.estbaldat = ? or
                                estoq.estbaldat <= today
                            then  tt-promo.prpromo = estoq.estproper.
                         end.           
                    end.
            end.
            /** **/                           
/****
            for each wf-movim:
                find produ where recid(produ) = wf-movim.wrec no-lock.
                    find tt-promo where tt-promo.rec-pro = wf-movim.wrec.
                    wf-movim.movpc = tt-promo.movpc.
            end.
***/            
            run p-promo-venda-tim.

            if vqtdbone <= vqtdtenis /*Promo Tryon*/
            then do:
                vusabone = vqtdbone.
                for each wf-movim:
                    find produ where recid(produ) = wf-movim.wrec no-lock.
                    if produ.procod = 479262
                    then wf-movim.movpc = 1.

                    if produ.pronom begins "TENIS" and produ.fabcod = 5146
                    then do:
                        if vusabone <> 0
                        then do:
                            wf-movim.movpc = wf-movim.movpc - 
                                        (vusabone / wf-movim.movqtm).
                            vusabone = 0.
                        end.                        
                    end.
                end.
            end.

            vmovpc-menor  = 0.
            vprocod-menor = 0.
            vmovpc-maior  = 0.
            vprocod-maior = 0.
            vqtdpro       = 0.
            
                for each wf-movim:
                    find produ where recid(produ) = wf-movim.wrec no-lock.
                    find tt-promo where tt-promo.rec-pro = wf-movim.wrec
                                no-lock no-error.
                    if not avail tt-promo then next.
                    /** descomentado a pedido do compras **/

                    if tt-promo.prpromo > 0
                        and v-utiliza-preco-plano-plaviv = no
                    then do:
                        if /*setbcod <> 100 and
                           setbcod <> 101 and*/
                           vpromoc <> "2932" and
                           vpromoc <> "2939"
                        then wf-movim.movpc = tt-promo.prpromo.
                    end.
                    else pause 0.  
                end.
            
            run p-atu-frame.
        end.
        
        if keyfunction(lastkey) = "end-error"
        then do:
            hide frame f-desti no-pause.
            clear frame fcli.
            undo bl-princ.
        end.
        
        vdown = 0.
        
        clear frame f-mensagem all.
        hide frame f-mensagem no-pause.
        /**verusview frame f-mensagem.*/
        vplatot = vprotot.

        find first wf-movim no-lock no-error.
        if not available wf-movim
        then do:
            hide frame f-desti no-pause.
            undo bl-princ, retry bl-princ.
        end.

        vcont = 0.
        pause 0.

        assign vent  = 0
               vsem  = 0
               v-atr = 0
               vpromocao = "".

        /*17.01.2020 verus - resgate cupomdesconto */
        {inc-fim-pre.i}
        /*17.01.2020 verus - resgate cupomdesconto */
        
        for each tt-liped:
            delete tt-liped.
        end.    
        etb-entrega = 0.
        dat-entrega = ?.
        vnumero-chp = "".
        vvalor-chp = 0.
        

        for each tt-prodesc.
            delete tt-prodesc.
        end.

        /** Chamado 16177 - supervisor **/
        for each tt-senauto:
            delete tt-senauto.
        end.
        /** **/
        
        sresp = no.

        clear frame f-produ1 all no-pause.
        /* CARTAO PRESENTE
        vnumero-chpu = "". vvalor-chpu = 0. vmensagem = "".

        for each tt-cartpre:
            delete tt-cartpre.
        end.

        vnumero-chpu-aux = 0.
        clear frame f-chp all no-pause.
        hide frame f-chp no-pause.
        */
        
        leave bl-plano.
    end.  
    if keyfunction(lastkey) = "END-ERROR"
    THEN.
    ELSE   leave bl-princ.
end.


procedure credito:
    dat-vencto = today.
    sal-aberto = 0.
    
    def var phttp_code as int.
    def var presposta as char.
    sal-aberto = 0.

    empty temp-table ttclien.
       
    run apilimites-consulta.p (input dec(clien.ciccgc), output phttp_code, output presposta).
    
    vok = no.
    find first ttclien where ttclien.tipo = "GLOBAL" no-error.
    if avail ttclien and phttp_code = 200
    then do:
        sal-aberto = comprometidoPrincipal.
        if ttclien.vctolimite >= today
        then do:
            vlimcrd = ttclien.limite.
            lim-calculado = ttclien.saldoLimite.
        end.
     end.
    
    
    
    if lim-calculado > 100 and vdiscre
    then
    disp vlimcrd label "Credito"
         sal-aberto   label "Saldo aberto "
         lim-calculado label "Credito calculado"
            with frame f1 side-label width 80
                    title "C R E D I T O" overlay
                    row 4.





end procedure.



procedure outras-opcoes:
    /***
    message color red/with "OPCAO NAO DISPONIVEL" VIEW-AS ALERT-BOX.
    return. 
    ***/

    def buffer bc-estab for estab.
    def var pro-entrega like produ.procod.
    def buffer eestab for estab.
    def var p-ok as log.
    def var p-es as log.
    def var p-qt as int.
    p-qt = 0.
    p-ok = yes.
    p-es = no.
    for each wf-movim no-lock:
            find produ where recid(produ) = wf-movim.wrec no-lock no-error.
            if not avail produ then next.
            if produ.proipiper = 98
            then next.
            p-qt = p-qt + 1. 
            if produ.catcod <> 31
            then do:
                p-ok = no.
                p-es = no.
                leave.
            end.
            if produ.proipival > 0
            then p-es = yes.
    end. 

    if p-ok and p-qt > 0
    then do:
        def var vsel as char extent 5 format "x(30)".
        vsel[1] = "ENTREGA EM OUTRA FILIAL".
        vsel[2] = "PROGRAMACAO DE ENTREGA ".
        form vsel[1] at 1 vsel[2] vsel[3] vsel[4] vsel[5] 
         at 1  with frame f-sel.
        disp vsel with frame f-sel centered 1 column no-label overlay row 10.
        choose field vsel with frame f-sel.
        if frame-index = 1
        then do on error undo:
            hide frame f-sel no-pause.
            do:
            update etb-entrega at 16
                validate(etb-entrega <> 0,"Filial nao existe")
                label "Filial entrega"
                with frame f-entrega overlay row 10 side-label
                width 70 centered title " Dados para entrega ".
            
            {lojapi-verificafilial.i etb-entrega}
            
            find first bc-estab where 
                       bc-estab.etbcod = etb-entrega and
                       bc-estab.etbcod <> 22 and
                       bc-estab.etbnom begins "DREBES-FIL"
                       NO-LOCK NO-ERROR.
            if not avail bc-estab
            then do:
                message color red/with
                "Entrega somente podera ser feita em outra filial."
                view-as alert-box.
                undo, retry.
            end.           
            do on error undo:
            update dat-entrega at 6  
                    validate(dat-entrega > today,"Data Invalida")
                 label "Data previsao de entrega" format "99/99/9999"
               with frame f-entrega.
            if dat-entrega = ? or
               dat-entrega > today + 30
            then do:
                message color red/with
                skip
                "Agendamento maximo = 30 dias" today + 30
                skip
                view-as alert-box .
                undo, retry.
            end. 
            end.
            do on error undo:
            update nome-retirada    at 5
                    label "Nome Responsavel retirada" 
                    validate(nome-retirada <> "","Campo obrigatorio.")
                    help "Informe o nome do responsavel pela retirada."
                    with frame f-entrega.
            end.
            do on error undo:
            update fone-retirada        at 1
                   label "Telefone Responsavel retirada"
                   validate(fone-retirada <> "","Campo obrigatorio.")
                   help "Informe o Telefone do responsavel pela retirada."
                   with frame f-entrega.
            end.        
            find eestab where eestab.etbcod = etb-entrega no-lock.
            if etb-entrega = setbcod
            then dat-entrega = ?.
            end.
        end.
        if frame-index = 2
        then do on error undo:
        message "Entrega futura DESATIVADA: Para casos excepcionais, favor comunicar o Performance." view-as alert-box.
        undo, retry.  /*Desabilitado em 03/2017 chamado 734503*/
        end.
    end.
    else message color red/with "Indisponivel para produtos de MODA."
        view-as alert-box.

end procedure.


procedure volta-preco:
    for each wf-movim :
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ then next.
        find estoq where estoq.etbcod = setbcod and
                         estoq.procod = produ.procod no-lock no-error.
        wf-movim.movpc = estoq.estvenda.
        wf-movim.precoori = estoq.estvenda.
    end.
end procedure.


procedure agil-price:
    
    def input parameter  p-imei as char.
    def output parameter cel-ok as log.
    
    /* CHAMADA AO BARRAMENTO */
    
    run wc-consultaimei.p (setbcod, p-imei).

    cel-ok = no.
    
    find first ttimei no-error.
    if not avail ttimei
    then do:
        find first ttretornoimei no-error.
        if avail ttretornoimei
        then do:
            hide message no-pause.
            message "barramento consultaimei" ttretornoimei.tstatus ttretornoimei.descricao.
            pause 2 no-message.
        end.
    end.
    else do:
        cel-ok = ttimei.tstatus = "DISPONIVEL".
        
        message "Imei: " ttimei.codigoimei "Ultimo Local Rastreado: " ttimei.ultimoLocalRastreado "Status:" ttimei.tstatus.
        pause 1 no-message.
         
    end.
end procedure.



procedure p-promo-venda-tim:

    if vqtdcartao <= vqtdcel
    then do: 
        vusacartao = vqtdcartao.
        
        for each wf-movim:          
            find produ where recid(produ) = wf-movim.wrec no-lock. 
            if produ.procod = 404913
            then wf-movim.movpc = 1.  
            
            if produ.procod = 404973
            then do: 
                if vusacartao <> 0 
                then do: 
                    wf-movim.movpc = wf-movim.movpc - 
                                     (vusacartao / wf-movim.movqtm).
                    vusacartao = 0. 
                end.                        
            end.
        end.
    end.

end procedure.


procedure grava-notobs3:
    
    vinfo-VIVO = vinfo-VIVO
         + "TIPVIV"  + string(plaviv.procod) + "=" + string(plaviv.tipviv) 
         + "|CODVIV" + string(plaviv.procod) + "=" + string(plaviv.codviv) 
         + "|PRETAB" + string(plaviv.procod) + "=" + string(plaviv.pretab) 
         + "|PREPRO" + string(plaviv.procod) + "=" + string(plaviv.prepro)
         + "|".

end procedure.




procedure p-libera-prod:

    def output parameter p-libera as log.
    
    if produ.catcod = 41
    then p-libera = yes.
    
    if produ.clacod = 104 or 
       produ.clacod = 108 or
       produ.clacod = 181 or
       produ.clacod = 193
    then p-libera = yes.
    
    if produ.clacod = 107 and produ.procod = 405657
    then p-libera = yes.
 
    if produ.procod = 10218  or produ.procod = 401265 or
       produ.procod = 405027 or produ.procod = 405033 or 
       produ.procod = 2290   or produ.procod = 402490 or
       produ.procod = 405767 or produ.procod = 402783 or 
       produ.procod = 405097 or produ.procod = 405098 or
       produ.procod = 400859 or produ.procod = 406338 or
       produ.procod = 406308 or produ.procod = 2281   or
       produ.procod = 405739 or produ.procod = 405840 or
       produ.procod = 100517 or produ.procod = 405682
    then p-libera = yes.    

    if produ.pronom matches "*Tapete Clemant*"
    then p-libera = yes.
 
    if produ.procod = 405712 or produ.procod = 402132 or 
       produ.procod = 403834 or produ.procod = 405682 or 
       produ.procod = 403092 or produ.procod = 1252   or 
       produ.procod = 405442 or produ.procod = 403727 or 
       produ.procod = 403728 or produ.procod = 403729 or 
       produ.procod = 403707 or produ.procod = 403704 or 
       produ.procod = 403730 or produ.procod = 403731 or 
       produ.procod = 403732 or produ.procod = 403733 or 
       produ.procod = 403734 or produ.procod = 403735 or 
       produ.procod = 403736 or produ.procod = 403700 or 
       produ.procod = 403737 or produ.procod = 403686 or 
       produ.procod = 403738 or produ.procod = 403739 or 
       produ.procod = 403740 or produ.procod = 403703 or 
       produ.procod = 403741 or produ.procod = 403742 or 
       produ.procod = 403742 or produ.procod = 403743 or 
       produ.procod = 403744 or produ.procod = 403692 or 
       produ.procod = 403745 or produ.procod = 403746 or 
       produ.procod = 403698 or produ.procod = 403747 or 
       produ.procod = 403748 or produ.procod = 403749 or 
       produ.procod = 403699 or produ.procod = 403696 or 
       produ.procod = 403750 or produ.procod = 403695 or 
       produ.procod = 403751 or produ.procod = 403752 or 
       produ.procod = 403753 or produ.procod = 402490 or
       produ.procod = 403754 or produ.procod = 403755 or 
       produ.procod = 403756 or produ.procod = 403757 or 
       produ.procod = 403758 or produ.procod = 403759 or 
       produ.procod = 403708 or produ.procod = 403701 or 
       produ.procod = 403760 or produ.procod = 403761 or 
       produ.procod = 403762 or produ.procod = 403763 or 
       produ.procod = 403697 or produ.procod = 403764 or 
       produ.procod = 403765 or produ.procod = 403766 or 
       produ.procod = 403702 or produ.procod = 403767 or 
       produ.procod = 403768 or produ.procod = 403769 or 
       produ.procod = 403770 or produ.procod = 403771 or 
       produ.procod = 403803 or produ.procod = 403804 or 
       produ.procod = 404787 or produ.procod = 404788 or 
       produ.procod = 404641 or produ.procod = 405004 or 
       produ.procod = 405101 or produ.procod = 405251 or 
       produ.procod = 405253 or produ.procod = 405252 or 
       produ.procod = 405399 or produ.procod = 405400 or 
       produ.procod = 405401 or produ.procod = 405931 or 
       produ.procod = 405767 or produ.procod = 406455 or 
       produ.procod = 406456 or produ.procod = 405705 or 
       produ.procod = 405711 or produ.procod = 401265 or 
       produ.procod = 405027 or produ.procod = 405033 or 
       produ.procod = 2290   or produ.procod = 405767
    then p-libera = yes.       

    if produ.procod = 402783 or produ.procod = 405097 or 
       produ.procod = 405098 or produ.procod = 400859 or 
       produ.procod = 406338 or produ.procod = 406308 or 
       produ.procod = 405739 or produ.procod = 405840 or 
       produ.procod = 100517 or produ.procod = 405682 or 
       produ.procod = 10218  or produ.procod = 405712 or 
       produ.procod = 402132 or produ.procod = 403834 or 
       produ.procod = 403037 or produ.procod = 405488 or 
       produ.procod = 405489 or produ.procod = 405903 or 
       produ.procod = 405711 or produ.procod = 405249 or 
       produ.procod = 405509 or produ.procod = 405862 or 
       produ.procod = 401969 or produ.procod = 405748 or 
       produ.procod = 401342 or produ.procod = 406338 or 
       produ.procod = 100514 or produ.procod = 405739 or 
       produ.procod = 401873 or produ.procod = 405033 or 
       produ.procod = 405046 or produ.procod = 405034 or 
       produ.procod = 405031 or produ.procod = 405053 or 
       produ.procod = 405049 or produ.procod = 405038 or 
       produ.procod = 405048 or produ.procod = 405032 or 
       produ.procod = 405051 or produ.procod = 405044 or 
       produ.procod = 405037 or produ.procod = 405050 or 
       produ.procod = 405039 or produ.procod = 405043 or 
       produ.procod = 405035 or produ.procod = 405036 or 
       produ.procod = 405042 or produ.procod = 405846 or 
       produ.procod = 405737 or produ.procod = 405654 or 
       produ.procod = 406339 or produ.procod = 400859 or 
       produ.procod = 406338 or produ.procod = 406308 or 
       produ.procod = 405739 or produ.procod = 405840 or 
       produ.procod = 100517 or produ.procod = 405682 or 
       produ.procod = 403560 or produ.procod = 405925 or 
       produ.procod = 406383 or produ.procod = 406382 or 
       produ.procod = 405841 or produ.procod = 406348 or 
       produ.procod = 405331 or produ.procod = 404919 or 
       produ.procod = 405320 or produ.procod = 405046 or 
       produ.procod = 405034 or produ.procod = 405031 or 
       produ.procod = 405033 or produ.procod = 405053 or 
       produ.procod = 405049 or produ.procod = 405038 or 
       produ.procod = 405048 or produ.procod = 405032 or 
       produ.procod = 405051 or produ.procod = 405044 or 
       produ.procod = 405037 or produ.procod = 405050 or 
       produ.procod = 405039 or produ.procod = 405043 or 
       produ.procod = 405035 or produ.procod = 405036 or 
       produ.procod = 405052 or produ.procod = 405846 or
       produ.procod = 405737 or produ.procod = 406370 or 
       produ.procod = 402898
    then p-libera = yes.   
        
    if produ.procod = 405248 and (setbcod = 76 or setbcod = 77 or setbcod = 78)
    then p-libera = yes.
    
    if produ.procod = 406370 or
       produ.procod = 948    or produ.procod = 403037 or
       produ.procod = 400859 or produ.procod = 405877 or
       produ.procod = 405853 or produ.procod = 400903 or
       produ.procod = 403423
    then p-libera = yes.

    if produ.procod = 406079 or
       produ.procod = 405170 or
       produ.procod = 403560 or
       produ.procod = 406502 or
       produ.procod = 405925 or
       produ.procod = 405841 or
       produ.procod = 406371
    then p-libera = yes.

    if produ.procod = 400859 or
       produ.procod = 403161 
    then p-libera = yes.

    if produ.procod = 405320 or
       produ.procod = 403560 or
       produ.procod = 406727 or
       produ.procod = 405925 or
       produ.procod = 405841 or
       produ.procod = 403792 or
       produ.procod = 405953 or
       produ.procod = 406383 or
       produ.procod = 406382 or
       produ.procod = 406348 or
       produ.procod = 406502 or
       produ.procod = 406728
    then p-libera = yes.

    if produ.procod = 405923 or
       produ.procod = 404906 or
       produ.procod = 405753
    then p-libera = yes.
 
    if today >= 02/15/2008
    then do:
        if produ.clacod = 107
        then do:
            if produ.procod <> 405928 and
               produ.procod <> 405720 and
               produ.procod <> 405794 and
               produ.procod <> 405704 and
               produ.procod <> 406509 and
               produ.procod <> 405657 and
               produ.procod <> 406703 and
               produ.procod <> 405659 and
               produ.procod <> 405880 and
               produ.procod <> 407019
            then p-libera = yes.
        end.
    end.

    if produ.procod = 405231 or
       produ.procod = 405690 or
       produ.procod = 407409
    then p-libera = yes.

    if produ.procod = 405248
    then p-libera = yes.
    
end procedure.

procedure p-atu-frame:

    hide frame f-exclusao no-pause.
    clear frame f-produ1 all no-pause.
    
    def var xprocod as int.
    
    xprocod = ?.
    
    vprotot = 0.
    v-qtd = 0.
    vitem = 0.
    for each wf-movim /*with frame f-produ1 */ by wf-movim.wrec:
        vitem = vitem + 1.
        find produ where recid(produ) = wf-movim.wrec no-lock.
        disp
            produ.procod 
            produ.pronom
            wf-movim.movqtm
            wf-movim.precoori when wf-movim.precoori > wf-movim.movpc
            wf-movim.movpc
            (wf-movim.movqtm * wf-movim.movpc) @ vsubtotal
            with frame f-produ1.
        down with frame f-produ1.
        pause 0.
        vprotot = vprotot + (wf-movim.movqtm * wf-movim.movpc).
        v-qtd = v-qtd + wf-movim.movqtm.
        find first tt-seg-movim where tt-seg-movim.seg-procod = produ.procod no-error.
        if not avail tt-seg-movim /* n�o faz para seguro */
           and produ.proipiper <> 98 /* Servico */
        then xprocod = produ.procod.
    end.
    display vprotot with frame f-produ.
    pause 0.


    find produ where produ.procod = xprocod no-lock no-error.
    if avail produ and vmostradet
    then do:
        vprosit = produ.proseq = 0.
        vvex    = no.
        vpe     = produ.proipival = 1.
        vmix    = no.
        vdescontinuado = produ.descontinuado.
        vfabcod = "".
         
        vtipomix = acha2("TIPOMIX",produ.indicegenerico).
        if vtipomix = ? then vtipomix = "".
        vleadtime = acha2("LEADTIME",produ.indicegenerico).
        if vleadtime = ? then vleadtime = "".
        vstatusitem = acha2("statusItem",produ.indicegenerico).
        if vstatusitem = ? then vstatusitem = "".
        if vstatusitem = "BC" then vstatusitem = "Susp.Compra". 
        if vstatusitem = "DE" then vstatusitem = "Descontinuado". 
        
        
        vmixloja = acha2("MIX" + string(setbcod),produ.indicegenerico).
        if vmixloja = ? then vmixloja = "".
        
        do vloop = 1 to num-entries(produ.indicegenerico,"|"):
            if entry(vloop,produ.indicegenerico,"|") = "MIX#" + string(setbcod)
            then vmix = yes.
            if entry(vloop,produ.indicegenerico,"|") = "VEX#SIM"
            then vvex = yes.
            
        end.
        find categoria of produ no-lock no-error.
        find fabri     of produ no-lock no-error.
        find sclase    of produ no-lock no-error.
         vfabcod = string(produ.fabcod).   
         if vfabcod = ? then vfabcod = "".
        /* helio 22122021    fase II.3 */
        vdescricaoFornecedor = acha2("descricaoFornecedor",produ.indicegenerico).
        if vdescricaoFornecedor = ? or vdescricaoFornecedor = ""
        then vdescricaoFornecedor = if avail fabri
                                    then fabri.fabfant
                                    else "".
        /**/
        /* helio 02082023 */
        vtempogar = "".
            find first produaux where produaux.procod = produ.procod and 
                                      produaux.nome_campo = "TempoGar"
                                      no-lock no-error.
            vtempogar = if avail produaux
                        then produaux.valor_campo
                        else "".
        /**/
        
        disp
            categoria.catnom when avail categoria
                format "x(16)" label "CATEG" colon 7  

            /* helio 22122021    fase II.3 
             *fabri.fabfant when avail fabri
             */
             vdescricaoFornecedor
                format "x(16)" label "FORNE" colon 34
                
           sclase.clanom when avail sclase
                format "x(16)" label "SUBCLA" colon 60

           /* helio 08/12/2021  fase II.2 */
           vstatusItem colon 7 label "STATUS"                               

           /* helio 08/12/2021  fase II.2
           *vdescontinuado  colon 7 label "DESCON"*/
                    
           /* helio 08/12/2021  fase II.2
           *vprosit colon 20 label "ATIVO"  */
           
           vmix colon 34 label "MIX"    
            vmixloja colon 50 label "QTD MIX"
           
           /* helio 08/12/2021  fase II.2
           * vtipomix colon 65 label "TipoMIX" */

            /* helio 08/12/2021  fase II.2 */
              vleadtime colon 70 label "PRZ ENTREGA"                     

            vpe colon 7 label "PE"
           vvex colon 20 label "VEX"
           /* helio 22122021    fase II.3 
            *   vfabcod colon 50 label "FORNE"
            */
           /* helio 02082023 */
           vtempogar label "Tempo Gar"
           /**/
                with frame 
                    fdet
                    row 14
                    no-box
                    centered 
                    color messages
                    width 78
                    side-labels 
                    overlay.
    end.
    
end procedure.


procedure promomov-casadinha-junho:

    def buffer b-wf-movim for wf-movim.    
    def var vpro-brind like produ.procod.
    def var vbri405753 as log init no.
    def var vbri403337 as log init no.
    def var vbri405512 as log init no.
    def var vbri403336 as log init no.
    def var vbri405996 as log init no.
    def var vbri403624 as log init no.
    def var vbri405796 as log init no.
    def var vbri407182 as log init no.
    def var vbri406720 as log init no.
    def var vbri405303 as log init no.
    def var vbri406438 as log init no.
    def var vbri407189 as log init no.
    def var vbri407188 as log init no.
    def var vbri402916 as log init no.
    def var vbri407311 as log init no.
    def var vbri405034 as log init no.
    def var vqtd403336 as int init 0.
    def var vqtd405996 as int init 0.
    def var vqtd403624 as int init 0.
    def var vqtd405796 as int init 0.
    def var v1 as log  init no.
    def var v2 as log  init no.
    def var v3 as log  init no.
    def var v4 as log  init no.
    def var vok as log init no.
    def var vbrindeja  as int.
    def var vqtdbrinde as int.

    vpreco-plano = no.
    def var vvalven as dec init 0.
    for each wf-movim:
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if produ.procod = 406720
        then next.
        vvalven = vvalven + (wf-movim.movpc * wf-movim.movqtm).
    end.
    for each wf-movim:  
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ
        then next.
        if produ.clacod = 61
        then do:
            vpro-brind = produ.procod. 
            vbri405034 = yes.
            vqtdbrinde = 1.
        end.
        if produ.clacod = 81
        then do:
            vpro-brind = produ.procod. 
            vbri407189 = yes.
            vbri407188 = yes.
            vqtdbrinde = 1.
        end.
        if produ.clacod = 173
        then do:
            vpro-brind = produ.procod. 
            vbri405303 = yes.
            vbri406438 = yes.
            vqtdbrinde = 1.
        end.
        if (produ.clacod = 131 or
            produ.clacod = 132 or
            produ.clacod = 133 or
            produ.clacod = 134 or
            produ.clacod = 135 or
            produ.clacod = 136 or
            produ.clacod = 137 or
            produ.clacod = 138 or
            produ.clacod = 139 or
            produ.procod = 100494) 
        then do:
            vpro-brind = produ.procod. 
            vbri406720 = yes.
            vqtdbrinde = 1.
        end.
        if produ.procod = 405197 or
           produ.procod = 405319
        then do:
            vpro-brind = produ.procod.
            vbri405753 = yes.
            vqtdbrinde = 1.
        end.    
        if produ.procod = 403624 or
           produ.procod = 405796
        then do:    
            vpro-brind = produ.procod.
            vbri403337 = yes.
            vbri405512 = yes.
            vqtdbrinde = 1.
        end.
        if produ.procod = 405852
        then do:
            vpro-brind = produ.procod. 
            vbri407182 = yes.
            vqtdbrinde = 1.
        end.
        if produ.procod = 2290 or
           produ.procod = 403090 or
           produ.procod = 405798 or
           produ.procod = 401569 or
           produ.procod = 407005 or
           produ.procod = 401406 or
           produ.procod = 401984 or
           produ.procod = 401985 or
           produ.procod = 401986 or
           produ.procod = 402042 or
           produ.procod = 402043 or
           produ.procod = 403060 or
           produ.procod = 403861 or
           produ.procod = 404292 or
           produ.procod = 404676 or
           produ.procod = 404677 or
           produ.procod = 404678 or
           produ.procod = 404679 or
           produ.procod = 404757 or
           produ.procod = 404758 or
           produ.procod = 404978 or
           produ.procod = 405573 or
           produ.procod = 405611 or
           produ.procod = 405684 or
           produ.procod = 405705 or
           produ.procod = 405711 or
           produ.procod = 405723 or
           produ.procod = 405999 or
           produ.procod = 406000 or
           produ.procod = 406359 or
           produ.procod = 406508 or
           produ.procod = 406562 or
           produ.procod = 406563 or
           produ.procod = 406564 or
           produ.procod = 406567 or
           produ.procod = 406568 or
           produ.procod = 406569 or
           produ.procod = 406570 or
           produ.procod = 406571 or
           produ.procod = 406596 or
           produ.procod = 406597 or
           produ.procod = 406599 or
           produ.procod = 406651 or
           produ.procod = 406680 or
           produ.procod = 406836 or
           produ.procod = 406838 or
           produ.procod = 406845 or
           produ.procod = 406867 or
           produ.procod = 407018 or
           produ.procod = 407062 or
           produ.procod = 407065 or
           produ.procod = 407066 or
           produ.procod = 407096 or
           produ.procod = 407097 or
           produ.procod = 407098 or
           produ.procod = 407099 or
           produ.procod = 407387
        then do:
            vpro-brind = produ.procod.       
            vbri407311 = yes.
            vqtdbrinde = 1.
        end.

        if produ.procod = 402695 or
           produ.procod = 402741 or
           produ.procod = 402755 or
           produ.procod = 404961 or
           produ.procod = 404961 or
           produ.procod = 404968 or
           produ.procod = 404971 or
           produ.procod = 404969 
        then do:
            vpro-brind = produ.procod.       
            vbri403336 = yes.
            vbri405996 = yes.
            vqtdbrinde = 1.
            vqtd403336 = vqtd403336 + 1.
            v1 = yes.
        end.
        if produ.procod = 401171 or
           produ.procod = 401229 or
           produ.procod = 401177 or
           produ.procod = 401170 or
           produ.procod = 401187
        then do:
            vpro-brind = produ.procod.       
            vbri403624 = yes.
            vbri405796 = yes.
            vqtdbrinde = 1.
            vqtd403624 = vqtd403624 + 1.
            v1 = yes.
        end.
        if produ.procod = 401633 or
           produ.procod = 402041 or
           produ.procod = 402946 or
           produ.procod = 404842 or 
           produ.procod = 403388 or
           produ.procod = 404808 or
           produ.procod = 404809 or
           produ.procod = 403380 or
           produ.procod = 402040 or
           produ.procod = 405937 or
           produ.procod = 404977 or
           produ.procod = 404978 or
           produ.procod = 405538 or
           produ.procod = 405530 or
           
           produ.procod = 405534 or
           produ.procod = 407048 or
           produ.procod = 407450 or
           produ.procod = 407047 or
           produ.procod = 403066 or
           produ.procod = 404633 or
           produ.procod = 405723 or
           produ.procod = 406648 or
           produ.procod = 406649 or
           produ.procod = 407049 or
           produ.procod = 407057 or
           produ.procod = 405825 or
           produ.procod = 405835 or
           produ.procod = 405832 or
           produ.procod = 405828 or
           produ.procod = 405797 or
           produ.procod = 400435 or
           produ.procod = 407309 or
           produ.procod = 405264
        then do:
            vpro-brind = produ.procod.
            vbri402916 = yes.
            vqtdbrinde = 1.
        end.    
    end.
    validaplano = yes. 
    for each wf-movim:
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ then next.
        
        if produ.procod = 405248
        then do:
                vp42 = yes.
                vp43 = yes.
                vp87 = yes.
                vp00 = yes.
                vpreco-plano = yes.
        end.
        else if vbri405753  or vbri403337 or vbri405512
        then do:        
            if produ.procod = 405753 or
               produ.procod = 403337 or
               produ.procod = 405512
            then do:
                wf-movim.movpc = 1.
                wf-movim.movqtm = 1.
                /*vp42 = yes.
                vp43 = yes.
                vp87 = yes.*/
            end.
            if produ.procod = vpro-brind
            then wf-movim.movpc = wf-movim.movpc - 1.
        end.
        else if vbri403336 or
                vbri405996
        then do:
            if produ.procod = 403336 or
               produ.procod = 405996
            then do:
                if vqtd403336 > 3 or
                   vqtd405996 > 3
                then do:
                   wf-movim.movqtm = 1.
                   wf-movim.movpc  = 1.
                   vp42 = yes.
                   vp43 = yes.
                   vp87 = yes.
                   vpreco-plano = yes.
                end.
            end. 
            if produ.procod = vpro-brind
            then do:
                if vqtd403336 > 3 or
                   vqtd405996 > 3
                then wf-movim.movpc = wf-movim.movpc - 1.
            end.
        end.    
        if vbri403624 or vbri405796
        then do:
            if produ.procod = 403624 or
               produ.procod = 405796
            then do:
                if vqtd403624 > 4 or
                   vqtd405796 > 4
                then do:
                   wf-movim.movqtm = 1.
                   wf-movim.movpc  = 1.
                   vp42 = yes.
                   vp43 = yes.
                   vp87 = yes.
                end.
            end. 
            if produ.procod = vpro-brind
            then do:
                if vqtd403624 > 4 or
                   vqtd405796 > 4
                then wf-movim.movpc = wf-movim.movpc - 1.
            end.
        end.
        else if vbri407182  or vbri406720 or
                vbri405303  or vbri407189 or
                vbri402916  or vbri407311 or
                vbri405034
        then do:
            if produ.procod = 407182 or
               produ.procod = 406720 or
               produ.procod = 405303 or
               produ.procod = 406438 or
               produ.procod = 407189 or
               produ.procod = 407188 or
               produ.procod = 402916 or
               produ.procod = 407311 or
               produ.procod = 405034 or
               produ.procod = 405031 or
               produ.procod = 405033 or
               produ.procod = 405053 or
               produ.procod = 405049 or
               produ.procod = 405038 or
               produ.procod = 405048 or
               produ.procod = 405032 or
               produ.procod = 405044 or
               produ.procod = 405037 or
               produ.procod = 405039 or
               produ.procod = 405043 or
               produ.procod = 405035 or
               produ.procod = 405036 or
               produ.procod = 405052 or
               produ.procod = 405846 
             then do:
                vp42 = yes.
                vp43 = yes.
                vp87 = yes.
                vpreco-plano = yes.
            end.   
        end.
    end.
end procedure.
 
/****************************/

procedure val-prazo-promo:
    val-prazo = vliqui.
    def var val-produto as dec init 0.
    for each wf-movim:
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ
        then next.
        if produ.procod = 406720
        then val-produto  = wf-movim.movpc.
    end.    
    if val-produto > 0
    then do:
        run gercpg1.p( input vfincod, 
                       input val-produto, 
                           input 0, 
                           input 0, 
                           output vliqui, 
                           output ventra,
                           output vparce). 
        val-prazo = val-prazo - vliqui.
    end.
end procedure.

procedure valpropromo:
    volta-preco = no.
        sresp = no.
        if vpreco-plano
        then do:
            for each wf-movim :
                find produ where recid(produ) = wf-movim.wrec no-lock.
                if today <= 06/30/08
                then do:
                    if produ.procod = 405248
                    then do:
                        if finan.fincod = 42
                        then wf-movim.movpc = 11.20.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 12.
                            else if finan.fincod = 87
                                then wf-movim.movpc = 10.60.
                        volta-preco = yes.
                        sresp = yes.
                    end.

                    if produ.procod = 407182 and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 52.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 49.
                            else if finan.fincod = 87
                                then wf-movim.movpc = 46.
                        sresp = yes.
                    end.            
                    if produ.procod = 406720 and sresp = no  and
                        val-prazo >= 300
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 67.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 49.
                            else if finan.fincod = 87
                                then wf-movim.movpc = 46.
                        sresp = yes.
                    end.
                    if (produ.procod = 405303 or
                        produ.procod = 406438) and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 92.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 86.
                            else if finan.fincod = 87
                            then wf-movim.movpc = 82.
                        sresp = yes.
                    end.
                    if (produ.procod = 407189 or
                        produ.procod = 407188) and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 66.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 61.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 59.
                        sresp = yes.
                    end.
                    if produ.procod = 402916 and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 132.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 124.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 118.
                        sresp = yes.
                    end.
                    if produ.procod = 407311 and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 46.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 43.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 41.
                        sresp = yes.
                    end.
                    if (produ.procod = 405034 or
                        produ.procod = 405031 or
                        produ.procod = 405033 or
                        produ.procod = 405053 or
                        produ.procod = 405049 or
                        produ.procod = 405038 or
                        produ.procod = 405048 or
                        produ.procod = 405032 or
                        produ.procod = 405044 or
                        produ.procod = 405037 or
                        produ.procod = 405039 or
                        produ.procod = 405034 or
                        produ.procod = 405035 or
                        produ.procod = 405036 or
                        produ.procod = 405052 or
                        produ.procod = 405846) and sresp = no
                    then do:
                        /*wf-movim.movqtm = 1.*/
                        if finan.fincod = 42
                        then wf-movim.movpc = 254.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 237.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 226.
                        sresp = yes.
                    end.
                end.
                if today <= 04/30/08
                then do:
                if produ.procod = 407182 and sresp = no
                then do:
                    wf-movim.movqtm = 1.
                    if finan.fincod = 42
                    then wf-movim.movpc = 52.
                    else if finan.fincod = 43
                        then wf-movim.movpc = 48.
                        else if finan.fincod = 87
                            then wf-movim.movpc = 46.
                    sresp = yes.
                end.            
                if produ.procod = 406338 and sresp = no
                then do:
                    wf-movim.movqtm = 1.
                    if finan.fincod = 42
                    then wf-movim.movpc = 78.66.
                    else if finan.fincod = 43
                        then wf-movim.movpc = 73.56.
                        else if finan.fincod = 87
                            then wf-movim.movpc = 70.07.
                    sresp = yes.
                end.
                if produ.procod = 403083 and sresp = no
                then do:
                    wf-movim.movqtm = 1.
                    if finan.fincod = 42
                    then wf-movim.movpc = 198.
                    else if finan.fincod = 43
                        then wf-movim.movpc = 185.
                        else if finan.fincod = 87
                            then wf-movim.movpc = 177.
                    sresp = yes.
                end.
                end.
                if today <= 05/31/08
                then do:
                    if produ.procod = 402916 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 132.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 123.44.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 117.50.
                        sresp = yes.
                    end.
                    if produ.procod = 407182 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 52.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 48.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 46.
                        sresp = yes.
                    end.
                    if produ.procod = 402828 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 65.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 61.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 58.
                        sresp = yes.
                    end.
                    if produ.procod = 405303 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 92.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 86.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 81.
                        sresp = yes.
                    end.
                    if produ.procod = 406438 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 92.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 86.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 81.
                        sresp = yes.
                    end.
                    if produ.procod = 406066 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 21
                        then wf-movim.movpc = 139.
                        else if finan.fincod = 24
                            then wf-movim.movpc = 150.
                                else if finan.fincod = 88
                                    then wf-movim.movpc = 133.
                        sresp = yes.
                    end.
                    if produ.procod = 405248 and sresp = no
                    then do:
                        if finan.fincod = 42 or
                           finan.fincod = 43 or
                           finan.fincod = 87
                        then wf-movim.movpc = 11.80.
                        volta-preco = yes.
                        sresp = yes.
                    end.
                end.
                /**
                if today <= 06/30/08
                then do:
                    if produ.procod = 407182 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 52.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 49.
                            else if finan.fincod = 87
                                then wf-movim.movpc = 46.
                        sresp = yes.
                    end.            
                    if produ.procod = 406720 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 67.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 49.
                            else if finan.fincod = 87
                                then wf-movim.movpc = 46.
                        sresp = yes.
                    end.
                    if (produ.procod = 405303 or
                        produ.procod = 406438) and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 92.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 86.
                            else if finan.fincod = 87
                            then wf-movim.movpc = 82.
                        sresp = yes.
                    end.
                    if (produ.procod = 407189 or
                        produ.procod = 407188) and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 66.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 61.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 59.
                        sresp = yes.
                    end.
                    if produ.procod = 402916 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 132.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 61.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 59.
                        sresp = yes.
                    end.
                    if produ.procod = 407311 and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 47.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 44.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 42.
                        sresp = yes.
                    end.
                    if (produ.procod = 405034 or
                        produ.procod = 405031 or
                        produ.procod = 405033 or
                        produ.procod = 405053 or
                        produ.procod = 405049 or
                        produ.procod = 405038 or
                        produ.procod = 405048 or
                        produ.procod = 405032 or
                        produ.procod = 405044 or
                        produ.procod = 405037 or
                        produ.procod = 405039 or
                        produ.procod = 405034 or
                        produ.procod = 405035 or
                        produ.procod = 405036 or
                        produ.procod = 405052 or
                        produ.procod = 405846) and sresp = no
                    then do:
                        wf-movim.movqtm = 1.
                        if finan.fincod = 42
                        then wf-movim.movpc = 254.
                        else if finan.fincod = 43
                            then wf-movim.movpc = 237.
                                else if finan.fincod = 87
                                    then wf-movim.movpc = 226.
                        sresp = yes.
                    end.
                end.
                ***/
            end.
        end.
        else do:
                for each wf-movim :
                    find produ where recid(produ) = wf-movim.wrec no-lock.
                    if today <= 06/30/08
                    then do:
                        if (produ.procod = 407489 or
                            produ.procod = 407492) and weekday(today) = 2
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 259.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 259.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 259.
                            sresp = yes.
                        end.
                        if (produ.procod = 403128 or
                            produ.procod = 405935) and weekday(today) = 3
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 289.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 289.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 289.
                            sresp = yes.
                        end.
                        if (produ.procod = 402455 or
                            produ.procod = 407326) and weekday(today) = 4
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 269.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 269.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 269.
                            sresp = yes.
                        end.
                        if (produ.procod = 407569 or
                            produ.procod = 407570) and weekday(today) = 5
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 329.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 329.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 329.
                            sresp = yes.
                        end.
                        if (produ.procod = 405682 or
                            produ.procod = 405683) and weekday(today) = 6
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 999.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 999.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 999.
                            sresp = yes.
                        end.
                        if  produ.procod = 407547 and weekday(today) = 7
                        then do:
                            wf-movim.movqtm = 1.
                            if finan.fincod = 42
                            then wf-movim.movpc = 559.
                            else if finan.fincod = 43
                                then wf-movim.movpc = 559.
                                    else if finan.fincod = 87
                                        then wf-movim.movpc = 559.
                            sresp = yes.
                        end.
                    end.
                end.
            end.
            if sresp = yes
            then do:
                run p-atu-frame.
                sresp = no.
            end.
end procedure. 


procedure p-descmed-barramento: 

def input parameter p-procod as int.
def input parameter p-valorProduto as dec.
def input parameter p-valorDesconto as dec.
def output parameter p-descontoMaximoPermitido as dec.
def output parameter p-lib    as log.
def output parameter p-libregional as log.


for each ttconsultamargemdescontoEntrada. delete ttconsultamargemdescontoEntrada. end.
for each ttmargemdescontoproduto. delete ttmargemdescontoproduto. end.
for each ttmargemdesconto. delete ttmargemdesconto. end.
create ttconsultamargemdescontoEntrada.
ttconsultamargemdescontoEntrada.codigoLoja      = string(setbcod).
ttconsultamargemdescontoEntrada.codigoProduto   = string(p-procod).
ttconsultamargemdescontoEntrada.valorProduto     = string(p-valorproduto).
ttconsultamargemdescontoEntrada.valorDescontoSolicitado = string(p-valordesconto).
ttconsultamargemdescontoEntrada.codigoOperador  = string(sfuncod).

run apimargemdesconto.p.  /* nova api */

p-libregional = no.
p-lib = no.
p-descontoMaximoPermitido = 0.
for each ttmargemdescontoproduto where ttmargemdescontoproduto.codigoProduto = string(p-procod).
    p-descontoMaximoPermitido = dec(ttmargemdescontoproduto.valorMaximoPermitido).
    p-lib = ttmargemdescontoproduto.autorizaDesconto = "true".
    p-libregional = ttmargemdescontoproduto.autorizaDescontoRegional = "true".
end.


end procedure.


procedure mens-plano:
    def var vl as int.
    repeat while vl < 10:
        form vmp as char format "x(58)" with row 13
            column 23 no-box no-labels 
            frame f-mp overlay.
        color disp message vmp with frame f-mp.
        pause 1 no-message.
        disp vmen-pla @  vmp with frame f-mp.
        pause 1 no-message.
        hide frame f-mp no-pause.
        vl = vl + 1.
        if keyfunction(lastkey) = "RETURN"
        then leave.
    end.           
end procedure.

procedure mens-credito:
    def var vl as int.
    repeat while vl < 3:
        form v1 as char format "x(55)" 
             vmc as char format "x(55)" 
             v2 as char format "x(55)"
             with /*row 16*/
            centered no-box no-labels  row 8
            frame f-mc  .
        color disp message v1 vmc v2 with frame f-mc.
        pause 1 no-message.
        disp vmen-cre @  vmc with frame f-mc.
        pause 1 no-message.
        hide frame f-mc no-pause.
        vl = vl + 1.
        if keyfunction(lastkey) = "RETURN"
        then leave.
    end.           
    hide frame f-mc no-pause.
end procedure.

procedure estoque-disponivel:

    def var vdisponivel like estoq.estatual.
    def var vtransito   like estoq.estatual.
    
    def var vest-filial like estoq.estatual.
    def buffer bprodu for produ.
    form "                       DISPONIBILIDADE DO PRODUTO " skip
         " " skip
         vprocod label "Produto"
         with frame est-disp.
     
    if vprocod = 0
    then update vprocod   with frame est-disp overlay.
    disp vprocod with frame est-disp.

    /* CHAMADA AO BARRAMENTO */
    run wc-consultaestoque.p (setbcod, int(vprocod)).

    find first ttestoque no-error.
    if not avail ttestoque
    then do:
        find first ttretorno no-error.
        if avail ttretorno
        then do:
            hide message no-pause.
            message "barramento consultaestoque" ttretorno.tstatus ttretorno.descricao.
            pause 2 no-message.
        end.
    end.
    else do:
        vdisponivel = 0.
        vtransito   = 0.
        for each ttestoque where int(codigoEstabelecimento) <> setbcod and
                                 int(codigoEstabelecimento) >= 900.
            vdisponivel = vdisponivel + int(ttestoque.qtdDisponivel).
        end.            
        find first ttestoque where int(codigoEstabelecimento) = setbcod no-error.
        vest-filial = if avail ttestoque
                      then int(ttestoque.qtdDisponivel)
                      else 0.
        vtransito = if avail ttestoque
                    then int(ttestoque.qtdTransito)
                    else 0.          
        disp vprocod   at 8
             produ.pronom no-label
             skip(1)
             vest-filial at 1 label "    Estoque Filial" format "->>>,>>9"
             skip(1)
             vtransito   at 1 label "Em Transito Filial" format "->>>,>>9"
             skip(1)
             vdisponivel at 1 label "Disponivel Deposit"     format "->>>,>>9"
             with frame est-disp overlay row 8
             width 80 15 down color message no-box side-label.
        pause 30.             
    end.
    
end procedure.

procedure gercpg:
    
    def var wtot as dec.
    def var wdev as dec.
    def var wbon as dec.
    def var wliq as dec.
    def var went as dec.
    def var wpar as dec.
    def var vprodu as int.
    def var vmovpc as dec.
    def var vbrinde as dec.
    def var vconf as log.
    
    assign
        vliqui = 0
        vparce = 0
        vprodu = 0
        vmovpc = 0
        vbrinde = 0
        vconf  = yes.
    
    sretorno = "".
    if ventradadiferenciada
    then sretorno = "Entrada=" + string(ventra).
    else ventra = 0.    
    vprotot = 0.
    for each wf-movim:
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ then next.

        /*find first tt-seguroPrestamista where tt-seguroPrestamista.wrec = wf-movim.wrec no-error.
        if avail tt-seguroPrestamista
        then next.*/
        
        if vprodu = 0 or
           wf-movim.movpc > vmovpc
        then vprodu = produ.procod.
        if wf-movim.movpc = 1
        then vbrinde = vbrinde + (wf-movim.movpc * wf-movim.movqtm).
        if produ.catcod <> 41
        then vconf = no.
        vprotot = vprotot + (wf-movim.movpc * wf-movim.movqtm).
    end.       
    
    if true or vconf or ventradadiferenciada
    then do:

        run gercpg1.p( input vfincod, 
                           input vprotot, 
                           input vdevval, 
                           input vbonus, 
                           output vliqui, 
                           output ventra,
                           output vparce). 

    end.
    else
    for each wf-movim:
        find produ where recid(produ) = wf-movim.wrec no-lock no-error.
        if not avail produ then next.

        /*find first tt-seguroPrestamista where tt-seguroPrestamista.wrec = wf-movim.wrec no-error.
        if avail tt-seguroPrestamista
        then next.*/
    
        if wf-movim.movpc = 1 then next.
        
        wtot = wf-movim.movpc * wf-movim.movqtm.
        if vdevval > 0
        then wdev = vdevval * (wtot / vprotot).
        else wdev = 0.

        if vbonus > 0
        then wbon = vbonus * (wtot / vprotot).

        scli = produ.procod.
        if vbrinde > 0 and
           vprodu = produ.procod
        then do:
            wtot = wtot + vbrinde.
            vbrinde = 0.
        end.
        parcela-especial = 0.

        run gercpg1.p( input vfincod, 
                       input wtot, 
                       input wdev, 
                       input wbon, 
                       output wliq, 
                       output went,
                       output wpar).
        scli = 0.               
        
        if parcela-especial > 0
        then wpar = parcela-especial.
        
        if not ventradadiferenciada
        then ventra = ventra + went.
        assign
            vliqui = vliqui + wliq
            vparce = vparce + wpar
            wtot = 0
            wdev = 0
            wbon = 0
            wliq = 0
            went = 0
            wpar = 0.
    end. 
end procedure.


procedure p-tbprice-ccid:
    
    def buffer btbprice for tbprice.
    def buffer bclase for clase.
    
    bl_ccid:
    repeat:
        update vccid format ">>>>>>>>>>>>>>>>>>>9" label "ICCID" /* #1 */
            with frame f-ccid overlay row 10
            title "Informe o ICCID do CHIP." side-labels centered .
        
        find first btbprice where btbprice.tipo = "ccid"
                              and btbprice.serial = string(vccid)
                            no-lock no-error. /* #1 */
        if avail btbprice
        then do:
            message "ICCID j� cadastrado" view-as alert-box.
            undo, retry.
        end.                  
        else do:
            run iccid.p (string(vccid), produ.clacod, output sresp). /* #1 */
            if not sresp
            then undo,retry.
            /** DESATIVADO
            create tp-tbprice.
            assign tp-tbprice.tipo        = "CCID"
                   tp-tbprice.serial      = string(vccid) /* #1 */
                   tp-tbprice.nota_compra = produ.procod.
            **/       
            leave bl_ccid.
        end.
    end.    
end procedure.


procedure senha_gerente.
    def output parameter par-ok  as log.

    DO ON ERROR UNDO:
        hide frame f-senha no-pause.    
        if keyfunction(lastkey) = "END-ERROR"
        then do:
            vfuncod = 0.
            vsenha = "".
            par-ok = no.
            next.
        end.
        
        do on error undo.
            if keyfunction(lastkey) = "END-ERROR"
            then do:
                vfuncod = 0.
                vsenha = "".
                par-ok = no. 
                hide frame f-senha no-pause.    

                next.
            end.

            vfuncod = 0. vsenha = "". par-ok = no.
        
            update vfuncod label "Matricula" 
                   vsenha  label "Senha" blank 
                   with frame f-senha side-label centered color message row 16
                        title " Senha Gerente ".

            find bfunc where bfunc.etbcod = setbcod
                         and bfunc.funcod = vfuncod no-lock no-error. 
            if not avail bfunc 
            then do:
                message "Funcionario Invalido".
                pause 3 no-message.
                par-ok = no.
                undo, retry.
            end.  
            if bfunc.funmec = no 
            then do:
                message "Funcionario nao e gerente". 
                pause 3 no-message. 
                par-ok = no.
                undo, retry. 
            end.     
            if vsenha <> bfunc.senha 
            then do:
                message "Senha invalida".
                pause 3 no-message.  
                par-ok = no.
                undo, retry. 
            end.
        end.
        par-ok = yes.
    END.        

    hide frame f-senha no-pause.
end procedure.

procedure verifica-bloqueio-desconto:
    /**
    def var varquivo as char.
    def var ver-procod like produ.procod. 
    **/
    
    vindbldes = no.
    
    /*HELIO*/
    {lojapi-verificabloqdesconto.i produ.procod}
        

end procedure.


procedure fluxo-desconto. /* helio 18/03/2021 */

                update v-procod
                       with frame f-exclusao /* row 6 overlay side-label centered
                                width 80 color message no-box*/ .
                find produ where produ.procod = v-procod no-lock no-error.
                if not avail produ
                then do:
                    hide message no-pause.
                    message "(1) produto nao cadastrado".
                    undo.
                end.    
                vindbldes = no.
                run verifica-bloqueio-desconto.
                if vindbldes
                then do:
                    hide message no-pause.
                    message "(7) desconto nao permitido. lista de bloqueados."
                        view-as alert-box.
                    undo.                   
                end.

            vagrupador = no.
                
                find first wf-movim where wf-movim.wrec = recid(produ) no-error.
                if not avail wf-movim
                then do:
                    find first wf-movim where wf-movim.KITproagr = produ.procod no-lock no-error.
                    if not avail wf-movim
                    then do:
                        hide message no-pause.
                        message "(2) produto nao pertence a esta nota" .
                        undo.
                    end.
                    else do:
                        vagrupador = yes.
                    end.
                end. 

            if vagrupador
            then do:
                aux2 = no.
                for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                    find fprodu where recid(fprodu) = bwf-movim.wrec no-lock.
                    find first tt-prodesc where 
                                   tt-prodesc.procod = fprodu.procod   and
                                   tt-prodesc.desco  = yes  no-lock no-error.
                    if avail tt-prodesc
                    then do:
                        aux2 = yes.
                    end.
                end.
                if aux2
                then do:
                        hide message no-pause.
                        message "(6) produto ja recebeu desconto.".
                        undo.
                end.                
            end.
            else do:
                if wf-movim.movalicms = 98 /* #2 */
                then do.
                    hide message no-pause.
                    message "(3) Produto nao pode ser alterado" view-as alert-box.
                    undo.
                end.

                if wf-movim.KITproagr <> 0 
                then do:
                    find first tt-prodesc where 
                           tt-prodesc.procod = wf-movim.KITproagr   and
                           tt-prodesc.desco  = yes  no-lock no-error.
                    if avail tt-prodesc
                    then do:
                        hide message no-pause.
                        message "(4) produto AGRUPADOR ja recebeu desconto.".
                        undo.
                    end.
                    
                    if acha2("VENDAAVULSA",produ.indicegenerico) = "NAO"
                    then do:
                        find bprodu where bprodu.procod = wf-movim.KITproagr
                            no-lock.
                        hide message no-pause.
                        message "(5) use codigo do agrupadoro " wf-movim.KITproagr bprodu.pronom.
                        undo.
                    end.
                end.                
                
                
                
                find first tt-prodesc where 
                               tt-prodesc.procod = produ.procod   and
                               tt-prodesc.desco  = yes  no-lock no-error.
                if avail tt-prodesc
                then do:
                    hide message no-pause.
                    message "(6) produto ja recebeu desconto.".
                    undo.
                end.

                
                /*HELIO 14112022*/
                /*RETIRADo em 14112022
                *if wf-movim.movpc < wf-movim.precoori                                
                *then do:
                *    hide message no-pause.
                *    message "PRODUTO COM PRECO PROMOCIONAL, DESCONTO NAO PERMITIDO".
                *    UNDO.                
                *end.
                */
                
            end.
                
                
                vtipo-desc = 0.
                display vescd no-label 
                    with frame f-escd centered row 9 overlay
                        title " DESCONTO ".
                
                choose field vescd with frame f-escd.
                
                vtipo-desc = frame-index. /*1=Valor/2=Percentual/3=Funcionario*/
                
                if vtipo-desc = 3 and (vclicod = 0 or vclicod = 1)
                then do:
                    hide message no-pause.
                    message "(8) opcao disponivel somente para cliente identificado.". 
                    undo.
                end.

                display produ.pronom format "x(30)" no-label 
                    with frame f-exclusao.
            
            if not vagrupador
            then do:    
                vqtd = wf-movim.movqtm.
                ppreco_total     = wf-movim.movpc * wf-movim.movqtm.
                ppreco_unitario  = wf-movim.movpc.

                display produ.pronom format "x(30)" no-label 
                        vqtd 
                        wf-movim.movpc format ">>>>>9.99" label "Preco" 
                        skip(1) 
                        ""
                    with frame f-exclusao.
                
            end.
            else do:
             
                find first  bwf-movim where bwf-movim.kitproagr = produ.procod.
                find fprodu where recid(fprodu) = bwf-movim.wrec no-lock.
                vqtdKIT =  int(acha2("QTDVENDA",fprodu.indicegenerico)).
                            if vqtdKIT = ? or vqtdKIT = 0
                            then vqtdKIT = 1.       

                vqtd = bwf-movim.movqtm / vqtdKIT. 
                ppreco_total  = 0. 
                for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                    ppreco_total = ppreco_total  + (bwf-movim.movpc * bwf-movim.movqtm). 
                end. 
                ppreco_unitario = ppreco_total / vqtd. 
                
                disp     
                    vqtd  
                    ppreco_unitario @ wf-movim.movpc with frame f-exclusao.
            end.
                            
                 
                do on error undo, retry:
                    
                    if vtipo-desc = 2
                    then do:
                        if vagrupador
                        then do:
                        
                            vdescper = 0. 
                            pause 0.
                            update vdescper 
                                with frame fdesc.
                            hide frame fdesc no-pause. 
                            if vdescper <> 0 
                            then do:
                                apreco_total = 0.
                                for each bwf-movim where bwf-movim.kitproagr = produ.procod.
                                    bwf-movim.movpc = (bwf-movim.precoori - ((bwf-movim.precoori * vdescper) / 100)).
                                    apreco_total = apreco_total  + (bwf-movim.movpc * bwf-movim.movqtm). 
                                end. 
                                apreco_unitario = apreco_total / vqtd. 
                            end.    
                        end.
                        else do:
                            vdescper = 0.
                            pause 0.
                            update vdescper label "Desconto de "
                                   with frame fdesc centered side-labels overlay
                                            row 7.
                            hide frame fdesc no-pause.
                            if vdescper <> 0
                            then do:
                                wf-movim.movpc = 
                                    (wf-movim.precoori - ((wf-movim.precoori * vdescper) / 100)).
                                apreco_unitario = wf-movim.movpc.
                                apreco_total    = wf-movim.movpc * wf-movim.movqtm.    
                            end.                                    
                        end.
                    end.
                    if vtipo-desc = 1
                    then do:
                        if vagrupador 
                        then do:
                            prompt-for wf-movim.movpc label "Preco" format ">>>>>9.99" with frame f-exclusao.
                            
                            vdescper = 100 - (input frame f-exclusao wf-movim.movpc / (ppreco_unitario) * 100).
                            if vdescper <> 0 
                            then do:
                                apreco_unitario = input frame f-exclusao wf-movim.movpc.
                                apreco_total = 0.
                                for each bwf-movim where bwf-movim.kitproagr = produ.procod.
                                    bwf-movim.movpc = (bwf-movim.precoori - ((bwf-movim.precoori * vdescper) / 100)).
                                    apreco_total = apreco_total  + (bwf-movim.movpc * bwf-movim.movqtm). 
                                end. 
                            end.
                        end.
                        else do:
                            update wf-movim.movpc with frame f-exclusao. 
                            apreco_unitario = wf-movim.movpc. 
                            apreco_total    = wf-movim.movpc * wf-movim.movqtm.    

                        end.    
                    end.    

                    if vtipo-desc = 3
                    then do:
                        
                        find first tt-descfunc no-lock no-error.
                        if not avail tt-descfunc
                        then do:
                            run descfunc.p (clien.ciccgc).
                            find first tt-descfunc no-lock no-error.
                        end.
                        
                        if avail tt-descfunc
                            and tt-descfunc.tem_cadastro = no
                        then do:
                            message "CPF n�o cadastrado na base de Clientes, "
                                    "fa�a o cadastro e entre em contato "
                                    "com o RH para alterar o tipo "
                                    "para Funcion�rio" view-as alert-box.
                            undo.
                        end.

                        if avail tt-descfunc
                            and tt-descfunc.tem_cadastro = yes
                            and tt-descfunc.tipo_funcionario = no
                        then do:
                            message "CPF n�o � de um funcion�rio."
                                        view-as alert-box.
                            undo.
                        end.

                        if avail tt-descfunc
                            and tt-descfunc.tem_cadastro = yes
                            and tt-descfunc.tipo_funcionario = yes
                        then do:
                            if vagrupador
                            then do:
                                apreco_total = 0.
                                for each bwf-movim where bwf-movim.kitproagr = produ.procod.
                                    find fprodu where recid(fprodu) = bwf-movim.wrec
                                                  no-lock.
                                    if fprodu.catcod = 31
                                    then assign bwf-movim.movpc = bwf-movim.movpc
                                        - (bwf-movim.movpc * tt-descfunc.desc31 / 100).
                                    else if fprodu.catcod = 41
                                    then assign bwf-movim.movpc = bwf-movim.movpc
                                        - (bwf-movim.movpc * tt-descfunc.desc41 / 100).
                                    apreco_total = apreco_total  + (bwf-movim.movpc * bwf-movim.movqtm). 
                                end. 
                                apreco_unitario = apreco_unitario / vqtd. 
                            end.
                            else do:
                                find fprodu where recid(fprodu) = wf-movim.wrec
                                              no-lock.
                                if fprodu.catcod = 31
                                then assign wf-movim.movpc = wf-movim.movpc
                                    - (wf-movim.movpc * tt-descfunc.desc31 / 100).
                                else if fprodu.catcod = 41
                                then assign wf-movim.movpc = wf-movim.movpc
                                    - (wf-movim.movpc * tt-descfunc.desc41 / 100).
                                apreco_unitario = wf-movim.movpc.
                                apreco_total    = wf-movim.movpc * wf-movim.movqtm.    
                            
                            end.                                    
                        end.
                        
                    end. /* fim 3 */

                    perc-desc = 100 - (apreco_unitario / ppreco_unitario * 100).
                    
                    if vagrupador = no
                    then do:
                        if produ.procod = 10000 and wf-movim.movpc > 200
                        then do: 
                    
                            hide message no-pause. 
                            wf-movim.movpc = wf-movim.precoori.
                            message "(9) valor maximo do Cartao Presente = 200 Reais".
                            undo.
                        end.
                        disp wf-movim.movpc with frame f-exclusao.                        
                    end.
                    else do:
                        disp 
                            apreco_unitario @ wf-movim.movpc with frame f-exclusao.
                    end.
                                    

                    hide frame f-escd no-pause.
    
                    /* fluxo de liberacao */
                    vsupervisorlibera = no.
                    vgerentelibera    = no.
                    vbarramentolibera = yes.

                    if vtipo-desc <> 3
                    then do on endkey undo:

                        hide message no-pause.
                        message "(10) consultando politica de descontos...".
                        if vagrupador
                        then do: 
                            vdescontoMaximoPermitido = 0.
                            npreco_total = 0.
                            for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                                find fprodu where recid(fprodu) = bwf-movim.wrec no-lock.
                                run p-descmed-barramento (input fprodu.procod,
                                               input bwf-movim.precoori,
                                               input bwf-movim.precoori - bwf-movim.movpc, 
                                               output aux1,
                                               output aux2,
                                               output p-libregional).
                         
                                                                               
                                if aux2 =  no
                                then do:
                                    vbarramentolibera = no.
                                    vdescontoMaximoPermitido = vdescontoMaximoPermitido + aux1.
                                    npreco_total =  npreco_total + ((bwf-movim.precoori - aux1) * bwf-movim.movqtm).
                                end.
                                else do:
                                    vdescontoMaximoPermitido = vdescontoMaximoPermitido + bwf-movim.precoori - bwf-movim.movpc.
                                    npreco_total =  npreco_total + ((bwf-movim.precoori - bwf-movim.movpc) * bwf-movim.movqtm).
                                end.
                            end.
                            npreco_unitario = npreco_total / vqtd.
                        end.
                        else do:
                            run p-descmed-barramento (input produ.procod,
                                           input wf-movim.precoori,
                                           input wf-movim.precoori - wf-movim.movpc, 
                                           output vdescontoMaximoPermitido,
                                           output vbarramentolibera,
                                           output p-libregional).
                            npreco_unitario = wf-movim.precoori - vdescontoMaximoPermitido.
                            npreco_total    = npreco_unitario * vqtd.

                        end.
                        
                        if vbarramentolibera = no
                        then do:
                            if p-libregional
                            then do:
                                vbarr-desc = 100 - ((npreco_unitario) / ppreco_unitario * 100). 
                                disp 
                                    "  Desconto Negado pela Politica de Descontos" skip(1) 
                                    "  Sera necessario autorizacao de supervisor" skip(1)
                                    "  Solicitado R$ " space(1)  ppreco_unitario - apreco_unitario perc-desc format "->>>9.99%" skip(1) 
                                    "  Valor Maximo de desconto Permitido R$ " space(1) vdescontoMaximoPermitido 
                                                vbarr-desc format "->>>9.99%" space(2) 
                                    with frame favisobarramento 
                                    centered no-labels
                                    row 7 overlay
                                    color messages.
                            end.
                            else do on endkey undo, retry :
                                disp 
                                    "    " skip(1)
                                    "  Margem de Descontos Esgotada" skip(1) 
                                    "    " skip(1)
                                    with frame favisobarramento3 
                                    centered no-labels
                                    row 7 overlay
                                    color messages.
                                
                                hide message no-pause.
                                message "margem de desconto esgotada!".
                                pause 2 no-message.
                                if vagrupador
                                then do: 
                                    for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                                        bwf-movim.movpc = bwf-movim.precoori.
                                    end.
                                end.
                                else   wf-movim.movpc = wf-movim.precoori.
                                return.
                            end.
                        end.
                        else do:
                            disp 
                                skip(1)

                                "  solicite a senha do gerente para aplicar o desconto" skip(1) 
                                "  Solicitado R$ " space(1)  ppreco_unitario - apreco_unitario perc-desc format "->>>9.99%" skip(2) 
                                
                                with frame favisobarramento2 
                                centered no-labels
                                row 8 overlay.
                            
                        end.  
                        
                        message "(11) solicite senha do gerente".
                        run senha_gerente (output vgerentelibera). 
                        hide frame f-senha no-pause.
                        hide frame favisobarramento no-pause.
                        hide frame favisobarramento2 no-pause.
                        
                        if not vgerentelibera
                        then do on error undo:
                            do on endkey undo, retry :  /* helio 29122023 BUG desconto de gerentes - Pre venda */
                                hide message no-pause.
                                message "(12) desconto nao autorizado pelo gerente.".
                                pause 1 no-message.
                            end.
                            if vagrupador
                            then do: 
                                for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                                    bwf-movim.movpc = bwf-movim.precoori.
                                end.
                            end.
                            else   wf-movim.movpc = wf-movim.precoori.
                             return.
                        end.
                        
                        /*if setbcod = 188 then vbarramentolibera = yes.*/
                        
                        if not vbarramentolibera
                        then do on endkey undo, retry:
                            vsupervisorlibera = no.
                            if keyfunction(lastkey) <> "END-ERROR"
                            then do:
                                message "(13) solicite token de supervisor" keyfunction(lastkey).
                                
                                run tokenverifica.p (output vsupervisorlibera, output p-supervisor). /* NOVO TOKEN */

                            end.

                            if not vsupervisorlibera
                            then do on error undo:
                                do on endkey undo, retry.
                                    message color messages "(12) desconto nao autorizado".
                                    pause 1 no-message.
                                end.
                                if vagrupador
                                then do: 
                                    for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                                        bwf-movim.movpc = bwf-movim.precoori.
                                    end.
                                end.
                                else wf-movim.movpc = wf-movim.precoori.
                                return.    
                            end.
                            else do:
                                if vagrupador
                                then do:
                                    for each bwf-movim where bwf-movim.kitproagr = produ.procod. 
                                        find fprodu where recid(fprodu) = bwf-movim.wrec no-lock. 
                                        find tt-senauto where tt-senauto.procod = fprodu.procod no-error.
                                        if not avail tt-senauto
                                        then do:
                                            create tt-senauto.
                                            assign tt-senauto.procod  = fprodu.procod
                                                   tt-senauto.preco-ori = bwf-movim.precoori * 100
                                                   tt-senauto.senauto = (((setbcod + day(today)) + month(today)) + 
                                                                    int(substr(string(time,"HH:MM:SS"),1,2))).
                                            if (tt-senauto.preco-ori / 100) <> bwf-movim.movpc
                                            then assign tt-senauto.desco = yes.
                                            else assign tt-senauto.desco = no.
                                        end. 
                                    end.
                                end.
                                else do:
                                    find tt-senauto where tt-senauto.procod = produ.procod no-error.
                                    if not avail tt-senauto
                                    then do:
                                        create tt-senauto.
                                        assign tt-senauto.procod  = produ.procod
                                               tt-senauto.preco-ori = wf-movim.precoori * 100
                                               tt-senauto.senauto = (((setbcod + day(today)) + month(today)) + 
                                                                int(substr(string(time,"HH:MM:SS"),1,2))).
                                        if (tt-senauto.preco-ori / 100) <> wf-movim.movpc
                                        then assign tt-senauto.desco = yes.
                                        else assign tt-senauto.desco = no.
                                    end.     
                                end.
                            end.
                        end.
                   end.
                        if vsupervisorlibera = no
                        then p-supervisor = "".
                        
                        hide message no-pause.
                        message color normal
                            "(13) desconto permitido" string(vbarramentolibera,"politica=ok/politica=nao ok") 
                                                          string(vgerentelibera,"gerente=ok/") 
                                                          string(vsupervisorlibera,"supervisor=ok/")
                                                          p-supervisor.
                        pause 2 no-message.
                        
                        if vagrupador
                        then do: 
                            for each bwf-movim where bwf-movim.kitproagr = produ.procod.  
                                find fprodu where recid(fprodu) = bwf-movim.wrec no-lock. 
                                find tt-prodesc where   tt-prodesc.procod = fprodu.procod no-error.
                                if not avail tt-prodesc 
                                then do:
                                    create tt-prodesc.
                                    assign tt-prodesc.procod = fprodu.procod
                                           tt-prodesc.preco  = bwf-movim.precoori
                                           tt-prodesc.preco-ven = bwf-movim.movpc.
                                end.
                                if tt-prodesc.preco > bwf-movim.movpc
                                then tt-prodesc.desco = yes.
                                else tt-prodesc.desco = no.
                            end.
                        end.
                        else do:
                            find tt-prodesc where   tt-prodesc.procod = produ.procod no-error.
                            if not avail tt-prodesc 
                            then do:
                                create tt-prodesc.
                                assign tt-prodesc.procod = produ.procod
                                       tt-prodesc.preco  = wf-movim.precoori
                                       tt-prodesc.preco-ven = wf-movim.movpc.
                            end.
                            if tt-prodesc.preco > wf-movim.movpc
                            then tt-prodesc.desco = yes.
                            else tt-prodesc.desco = no.
                        end.                  
                            
                end.     /* if avail wf-movim */
                
                
                if vende-garan
                then run altera-segprod(v-procod).


end procedure.

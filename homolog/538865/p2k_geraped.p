{admcab.i}
def input parameter par-rec as recid.

def var varq   as char.
def var vtipoped  as int init 1. /* #1 */

def var vcha-dat-ped-especial as char init "".
def var vcha-obs-ped-especial as char init "".

def var vcha-dat-entrega-futura as char. /* ESTA DESATIVADA NO WF-PRE.p */

def var vforma as int.

def buffer bprevenprod for prevenprod.
def buffer bprodu for produ.
def buffer sprevenprod for prevenprod.

def var vservico  as char.

function formatadata returns character 
    (input par-data  as date).  

    def var vdata as char. 

    if par-data <> ? 
    then vdata = string(year (par-data), "9999") +
                 string(month(par-data), "99") + 
                 string(day  (par-data), "99")  . 
    else vdata = "00000000". 

    return vdata. 

end function.


find prevenda where recid(prevenda) = par-rec no-lock.
if prevenda.etbcod <> setbcod          /* somente pre-vendas da filial    */ 
then return.

def var vpastap2k as char.
def var vpastap2k-filial as char.
run lemestre.p ("pasta-p2k",output vpastap2k).
run lemestre.p ("pasta-p2k-filial",output vpastap2k-filial).


varq = vpastap2k + "/PD" + string(prevenda.etbcod,"9999") + string(prevenda.precod,"99999999") + ".csi".

def var vhora as int.
def var Codigo_CPF_CNPJ as char format "x(18)".
def var Digito_CPF_CNPJ as char format "xx".

vhora = int(substr(string(prevenda.horincl,"HH:MM:SS"),1,2) +
            substr(string(prevenda.horincl,"HH:MM:SS"),4,2) +
            substr(string(prevenda.horincl,"HH:MM:SS"),7,2)) no-error.
find clien where clien.clicod = prevenda.clicod no-lock.

run p2k_cpfcliente (input clien.clicod,
                      output Codigo_CPF_CNPJ, 
                      output Digito_CPF_CNPJ).

output to value(varq).

/* #1 */
if etb-entrega <> 0 and
   etb-entrega <> setbcod 
then vtipoped = 2.

/***
    Registro tipo 01 - Capa de pedido
***/
put unformatted 
    "01"                format "xx"         /* Tipo_Reg      */
    prevenda.Etbcod        format "99999"      /* Codigo_Loja   */
    prevenda.precod        format "9999999999" /* Numero_Pedido */
    "3"                 format "x"          /* Status_Pedido */
    0                   format "99999"      /* Num_Componente*/
    formatadata(prevenda.dtinclu) format "xxxxxxxx"   /*  Data   */
    vhora               format "999999"     /* Hora          */
    string(if prevenda.clicod = 1 then 0 else prevenda.clicod
            , "99999999999999999999")     format "x(20)"      
                                            /* Codigo_Cliente*/
/***
    string(dec(Codigo_CPF_CNPJ) , "999999999999999999")
                        format "x(18)"      /* Codigo_CPF_CNPJ  */
***/
    Codigo_CPF_CNPJ     format "x(18)"      /* Codigo_CPF_CNPJ  */
    Digito_CPF_CNPJ     format "xx"         /* Digito_CPF_CNPJ  */

   (if prevenda.identificador <> "" or clien.clicod = 0
    then prevenda.identificador
    else clien.clinom)  format "x(40)"      /* Nome_Cliente */

   (if clien.clicod = 0
    then ""
    else Clien.endereco[1]) format "x(30)"  /* End_Cliente */
   (if clien.clicod = 0
    then 0
    else Clien.numero[1])   format "99999"  /* Num_End_Cliente  */
   (if clien.clicod = 0
    then ""
    else Clien.compl[1])    format "x(35)"  /* Compl_End_Cliente*/
   (if clien.clicod = 0
    then ""
    else Clien.cidade[1])  format "x(35)"   /* Cidade_End_Cliente */
   (if clien.clicod = 0
    then ""
    else Clien.ufecod[1])  format "xxx"     /* Estado_End_Cliente */
    
    "BRA"               format "xxx"        /* Pais_End_Cliente */
   (if clien.clicod = 0
    then ""
    else Clien.cep[1])   format "x(10)"     /* CEP_End_Cliente  */
    
    "1"                 format "x"          /* Tipo_Desconto */
    0                   format "9999999999999"  /* Desconto  */
    prevenda.etbcod        format "99999"      /* Codigo_Loja_Trs  */
    formatadata(prevenda.dtinclu) format "xxxxxxxx"   /* Data_Trs      */
    0                   format "99999"      /* Componente_Trs*/
    0                   format "999999"     /* Nsu_Trs       */
    0                   format "999999"     /* Codigo_Vendedor  */
    (if clien.tippes then 1 else 2) format "9" /* Tipo_CPF_CNPJ */
    vtipoped /* #1 1 */ format "9"          /* Tipo          */
    formatadata(dtinclu) format "xxxxxxxx"   /* Data_Vencimento  */
    0                   format "99999999"   /* Data_Cancel   */
    1                   format "9"          /* Tipo_Acrescimo*/
    0                format "9999999999999" /* Acrescimo */
    prevenda.precod        format "9999999999" /* Numero_PV */
    skip.
    
/***
    Registro tipo 02 - Item de pedido
***/
    
    /* PEDIDO ESPECIAL */
    if prevenda.dat-ped-especial <> ?
    then assign vcha-dat-ped-especial = string(year(prevenda.dat-ped-especial),"9999")
                                      + string(month(prevenda.dat-ped-especial),"99")
                                      + string(day(prevenda.dat-ped-especial),"99").

    if prevenda.obs-ped-especial <> ? and prevenda.obs-ped-especial <> ""
    then vcha-obs-ped-especial = prevenda.obs-ped-especial.
    

for each prevenprod where prevenprod.etbcod = prevenda.etbcod
                      and prevenprod.precod = prevenda.precod
                      and prevenprod.presente = no
                      and prevenprod.seguroprestamista = no 
                      and prevenprod.garantia = no
               no-lock.

    find produ of prevenprod no-lock.  
    find clafis where clafis.codfis = produ.codfis no-lock no-error.

         assign
        vcha-dat-entrega-futura = "".

    put unformatted
        2               format "99"         /* Tipo_Reg */
        prevenda.etbcod    format "99999"      /* Codigo_Loja */
        prevenda.precod  format "9999999999" /* Numero_Pedido */
        prevenprod.movseq    format "999999"     /* Seq_Item_Pedido */
        0               format "99999"      /* Num_Componente  */
        prevenda.vencod    format "999999"     /* Codigo_Vendedor */
        string(prevenprod.procod,"99999999999999999999")
                        format "x(20)"      /* Codigo_Produto */
        0 /**prevenprod.procod**/    format "99999999999999" /* Cod_Autom_Prod */
        prevenprod.movqtm * 1000   format "99999999"   /* Quant_Produto */ 
        produ.prounven  format "xx"         /* Unid_Venda_Prod */ 
        prevenprod.movpc  * 100   format "9999999999999"  /* Valor_Unitario */ 
        prevenprod.movqtm * prevenprod.movpc * 100
                        format "9999999999999"  /* Val_Total_Item */ 
        1       format "9"              /* Tipo_Desconto */ 
        prevenprod.movdes * 100   format "9999999999999"  /* Desconto_Unit */ 
        prevenda.etbcod    format "99999"          /* Loja_Item_Entg */ 
        "00000"         format "x(5)"           /* Depos_Item_Entg */ 
        "RL"            format "xx"             /* Forma_Entrega */ 
        0               format "99999999"       /* Qtd_Item_Entfut */ 
        prevenprod.sittributaria  format "x"              /* Situacao_Tributaria */ 
        prevenprod.movalicms * 100 format "99999"         /* Perc_Tributacao */ 
        produ.pronom    format "x(40)"          /* Descr_Compl_Trunc */ 
        1               format "9999999999999"  /* Qtd_Unid_Venda_Prod */ 
        trim(produ.pronom) format "x(50)"       /* Descricao Completa */ 
        ""              format "x(21)"          /* Descricao Completa */
        ""              format "x(30)"          /* Nao Serial */
        0               format "99999"          /* Seq_Obriga_Forma */
        produ.codfis    format "99999999"       /* Codigo_NCM */ 
        prevenprod.imposto * 100 format "99999"        /* Percent_Imp_Medio */ 
        ""              format "x(3)"           /* CST */
        if avail clafis then clafis.dec1 * 100 else 0
                        format "99999"          /* % federal  */
        if avail clafis then clafis.dec2 * 100 else 0
                        format "99999"          /* % estadual */
        0               format "99999"          /* % municipal */
        vcha-dat-entrega-futura  format "x(8)"  /* Entrega Futura */
        vcha-dat-ped-especial    format "x(8)"  /* Pedido Especial */
        ""              format "x(7)"           /* CEST */
        ""              format "x(10)"          /* vendedor */
        ""              format "x(10)"          /* vendedor */
        prevenprod.imei format "x(15)"          /* IMEI */
        skip.        
end.

/***
    Registro 03
***/
vforma = if prevenda.crecod = 2 and prevenda.pmoeda = ""
         then 93
         else 1.
if vforma = 93 
then put unformatted
        "03"            format "xx"    /* tipo_reg */
        "00001"         format "99999" /* Numero_Pedido */
        vforma          format "99999" /* forma */
        prevenda.precod    format "99999" /* prevenda */
        prevenda.protot * 100   format "9999999999999"
        skip.

else
if prevenda.pmoeda <> ""
then do:
    if prevenda.pmoeda = "DINHEIRO"  then vforma = 1.
    if prevenda.pmoeda = "TEFDEBITO" then vforma = 9.
    
     put unformatted
        "03"            format "xx"    /* tipo_reg */
        "00001"         format "99999" /* Numero_Pedido */
        vforma          format "99999" /* forma */
        0 /* forca plano 0*/ /*prevenda.pedcod */   format "99999" /* prevenda */
        prevenda.protot * 100   format "9999999999999"
        skip.

end.
/***
    Registro 05 - GE / RFQ
***/
def var vx as int.
for each prevenprod of prevenda where prevenprod.garantia = yes no-lock.
    
    find first bprevenprod where 
                           bprevenprod.etbcod = prevenda.etbcod
                       and bprevenprod.precod = prevenda.precod
                       and bprevenprod.procod = prevenprod.procodProduto
                     no-lock.

    find produ  where  produ.procod = prevenprod.procodProduto no-lock.
    find bprodu where bprodu.procod = prevenprod.procod        no-lock.

    do vx = 1 to prevenprod.movqtm:
        put unformatted
        5                   format "99"         /* Tipo_Reg */
        prevenda.etbcod        format "99999"      /* Codigo_Loja */
        prevenda.precod        format "9999999999" /* Numero_Pedido */
        0                   format "99999"      /* Num_Componente */
        prevenda.vencod        format "999999"     /* Codigo_Vendedor */
        string(prevenprod.procod,"99999999999999999999")
                            format "x(20)"      /* Codigo_Produto */
        0                   format "99999999999999" /* Cod_Autom_Prod */
        trim(bprodu.pronom) format "x(40)"      /* Descricao Completa */
        ""                  format "x(20)"      /* Numero do certificado */
        bprodu.procod       format "9999999999" /* codigo garantia */
        prevenprod.movpc * 100 format "9999999999999" /* vlr.total */
        prevenprod.movpc * 100 format "9999999999999" /* vlr.custo */
        prevenprod.meses           format "999"
        prevenprod.meses  format "999"
        prevenprod.subtipo format "x(1)"
        0                   format "9999999999" /* cupom venda produto */
        substr(prevenprod.p2k-datahoraprodu, 1, 8)
                            format "x(8)"       /* data venda produto */
        0                   format "99999"      /* seq obriga forma */
        0                   format "99999999"   /* data inicio */
        0                   format "99999999"   /* data fim */
        substr(prevenprod.p2k-datahoraprodu, 9, 6)
                            format "x(6)"       /* Hora Venda */
        prevenprod.p2k-datahoraplano  format "x(14)" /* WS */
        bprevenprod.movseq       format "999999"    
        prevenprod.p2k-id_seguro format "9999999999" /* WS */
        skip.
    end.
end.

/***
    Registro 07
***/
for each prevenprod where prevenprod.etbcod = prevenda.etbcod
                      and prevenprod.precod = prevenda.precod 
                      and (prevenprod.seguroprestamista = yes or
                           prevenprod.presente          = yes)
                       
                      no-lock.

    find produ of prevenprod no-lock. 

    if prevenprod.seguroprestamista 
    then assign
            vforma   = 2 /* seguro prestamista */
            vservico = string(produ.procod).
    else assign
            vforma   = 1
            vservico = fill("0", 30).

    put unformatted 
        "07"            format "xx"
        vforma          format "99"
        prevenda.etbcod    format "99999"
        prevenda.precod    format "9999999999" /* Numero_Pedido */
        9999            format "99999"
        prevenda.vencod    format "999999"     /* Codigo_Vendedor */
        vservico        format "x(30)"
        prevenprod.movpc * 100   format "9999999999999"
        skip.
end.

/***
    Registro tipo 8 - OBSERVACOES / Pedido especial
***/
if prevenda.idbag <> ?
then do:
            put unformatted
                8                     format "99"     /* Tipo_Reg */ 
                "LEBES-BAG=" + string(prevenda.idbag) format "x(250)" 
                skip.
end.

/* 31012023 helio - ajuste projeto cupom desconto b2b - sera enviado o cupom no tipo 8 */
/* alterado o envio do tipo 8 */
if vcha-obs-ped-especial <> "" or prevenda.cupomb2b <> 0  or prevenda.supervisor <> ""
    /* helio 02082023 */ or prevenda.planocota <> 0
then do:

    if prevenda.cupomb2b <> 0
    then vcha-obs-ped-especial = vcha-obs-ped-especial + 
                                 (if vcha-obs-ped-especial <> ""
                                  then "|"
                                  else "") +
                                    "CUPOM_DESCONTO=" + string(prevenda.cupomb2b).
    if prevenda.planocota <> 0
    then vcha-obs-ped-especial = vcha-obs-ped-especial + 
                                 (if vcha-obs-ped-especial <> ""
                                  then "|"
                                  else "") +
                                    "USA_COTA_PLANO=SIM".

    if prevenda.supervisor <> ""
    then vcha-obs-ped-especial = vcha-obs-ped-especial + 
                                 (if vcha-obs-ped-especial <> ""
                                  then "|"
                                  else "") +
                                    "DESC_REGIONAL=" + prevenda.supervisor.
                                    
    put unformatted
                8                     format "99"     /* Tipo_Reg */ 
                vcha-obs-ped-especial format "x(250)" 
                skip.

end.
/*31012023 */

if prevenda.campanha <> 0
then do:
    put unformatted
        9               format "99"         /* Tipo_Reg */
        prevenda.campanha    format "9999999"    /* Codigo Campanha = ctpromoc */
        00              format "99"         /* Tipo Campanha */
        0               format "999999"     /* Seq_Item_Pedido */
        0               format "99999999" /* Quant_Produto */
        prevenda.valorcupomdesconto * 100   format "9999999999999"  /* Desconto_Unit */
        skip.                   
end.

/***
    #1 Registro 11 - Entrega em outra loja
***/
if prevenda.etb-entrega <> 0 and
   prevenda.etb-entrega <> setbcod 
then
    put unformatted
        11              format "99"         /* Tipo_Reg */
        prevenda.etb-entrega     format "99999"
        prevenda.precod  format "9999999999" /* Numero_Pedido */
        prevenda.fone-retirada   format "x(10)"
        prevenda.nome-retirada   format "x(20)"
        formatadata(prevenda.dat-entrega) format "xxxxxxxx"
        skip.

/***
    Registro 99
***/
put unformatted 
    "99"                format "xx"         /* Tipo_Reg */
    skip.

output close.


do on error undo:
    find current prevenda exclusive.
    prevenda.dtfechamento = today.
    prevenda.hrfechamento = time.
    prevenda.arquivo      = varq.
    prevenda.tipoped      = vtipoped.
end. 

/* SCP PARA FILIAL */
if vpastap2k-filial <> "" and vpastap2k-filial <> ?
then do:
    hide message no-pause. message "copiando pedido -> " vpastap2k-filial. pause 1 no-message.
    os-command silent value("scp-pass " + varq + " " + vpastap2k-filial).
    os-command silent value("rm -f "  + varq).
    hide message no-pause.
end.

release prevenda.





procedure p2k_cpfcliente.
def input parameter par-clicod  like clien.clicod.
def output parameter Codigo_CPF_CNPJ as char format "x(18)" .
def output parameter Digito_CPF_CNPJ as char format "xx".

def var ccpf as char format "x(13)".
def var dcpf as dec.
def var ccnpj as char format "x(15)".
def var dcnpj as dec.
def var v as int.

    if par-clicod = 0
    then return.

find clien where clien.clicod = par-clicod no-lock.
    Codigo_CPF_CNPJ = "".
    Digito_CPF_CNPJ = "".
    ccpf = "".
    ccnpj = "".    
    if clien.tippes 
    then do.
        do v = 1 to 20.
            if substr(Clien.ciccgc,v,1) = "0" or
               substr(Clien.ciccgc,v,1) = "1" or
               substr(Clien.ciccgc,v,1) = "2" or 
               substr(Clien.ciccgc,v,1) = "3" or 
               substr(Clien.ciccgc,v,1) = "4" or 
               substr(Clien.ciccgc,v,1) = "5" or
               substr(Clien.ciccgc,v,1) = "6" or
               substr(Clien.ciccgc,v,1) = "7" or
               substr(Clien.ciccgc,v,1) = "8" or
               substr(Clien.ciccgc,v,1) = "9" 
            then ccpf = ccpf + substr(Clien.ciccgc,v,1). 
        end.
        dcpf = dec(ccpf) no-error.
        Codigo_CPF_CNPJ = substr(fill(" ", 11 - length(ccpf)) + ccpf, 1, 9).
        Digito_CPF_CNPJ = substr(string(dcpf,"99999999999"),10,2).
    end.    
    else do.
        do v = 1 to 20.
            if substr(Clien.ciccgc,v,1) = "0" or
               substr(Clien.ciccgc,v,1) = "1" or
               substr(Clien.ciccgc,v,1) = "2" or 
               substr(Clien.ciccgc,v,1) = "3" or 
               substr(Clien.ciccgc,v,1) = "4" or 
               substr(Clien.ciccgc,v,1) = "5" or
               substr(Clien.ciccgc,v,1) = "6" or
               substr(Clien.ciccgc,v,1) = "7" or
               substr(Clien.ciccgc,v,1) = "8" or
               substr(Clien.ciccgc,v,1) = "9" 
            then ccnpj = ccnpj + substr(Clien.ciccgc,v,1). 
        end.
        dcnpj = dec(ccnpj) no-error.
        Codigo_CPF_CNPJ = substr(string(dcnpj,"99999999999999"),1,12).
        Digito_CPF_CNPJ = substr(string(dcnpj,"99999999999999"),13,2).
    end.
    
    dcpf = 0.
    dcnpj = 0.

end procedure.

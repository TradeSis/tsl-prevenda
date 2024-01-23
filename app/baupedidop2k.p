
/* bau 092022 - helio */

{admcab.i}

def input parameter par-rec as recid.

{baudefs.i}
find first ttproposta no-error.
if not avail ttproposta
then do:
    message "Ocorreu um erro (ttproposta nor avail)".
    pause.
    return.
end.    
find first ttgetcliente no-error.

def var vservico  as char.

def var varq   as char.
def var vtipoped  as int init 1. /* #1 */
def var vforma as int.


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
if  prevenda.etbcod <> setbcod          /* somente pre-vendas da filial    */ 
then return.
find clien where clien.clicod = prevenda.clicod and clien.clicod > 1 no-lock no-error.
 
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

if avail clien 
    and prevenda.crecod = 2 /*#01082022*/
then do:
        def var dcpf as dec.
        def var ccpf as char.
        dcpf = dec(ttproposta.cpf) no-error.
        ccpf = string(dcpf,"99999999999").
        Codigo_CPF_CNPJ = substr(fill(" ", 11 - length(ccpf)) + ccpf, 1, 9).
        Digito_CPF_CNPJ = substr(string(dcpf,"99999999999"),10,2).
    
end.

/***
    Combo
***/
def var vtipodesc as int.

output to value(varq).


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
    string(if avail clien 
             and prevenda.crecod = 2 /*#01082022*/
            then clien.clicod else 0, "99999999999999999999")     format "x(20)"      
                                            /* Codigo_Cliente*/
    Codigo_CPF_CNPJ     format "x(18)"      /* Codigo_CPF_CNPJ  */
    Digito_CPF_CNPJ     format "xx"         /* Digito_CPF_CNPJ  */

    if avail ttgetcliente
            and prevenda.crecod = 2 /*#01082022*/
            then ttgetcliente.nome else " " format "x(40)"      /* Nome_Cliente */

    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then ttgetcliente.endereco else "" format "x(30)"  /* End_Cliente */
    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then string(ttgetcliente.numero)   else "" format "x(05)"  /* Num_End_Cliente  */
    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then ""   else "" format "x(35)"  /* Compl_End_Cliente*/
    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then ttgetcliente.cidade   else "" format "x(35)"   /* Cidade_End_Cliente */
    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then ttgetcliente.estado   else "" format "xxx"     /* Estado_End_Cliente */
    
    "BRA"               format "xxx"        /* Pais_End_Cliente */
    if avail ttgetcliente 
        and prevenda.crecod = 2 /*#01082022*/
        then ttgetcliente.cep      else "" format "x(10)"     /* CEP_End_Cliente  */
    
    "1"                 format "x"          /* Tipo_Desconto */
    0                   format "9999999999999"  /* Desconto  */
    prevenda.etbcod        format "99999"      /* Codigo_Loja_Trs  */
    formatadata(dtinclu) format "xxxxxxxx"   /* Data_Trs      */
    0                   format "99999"      /* Componente_Trs*/
    0                   format "999999"     /* Nsu_Trs       */
    0                   format "999999"     /* Codigo_Vendedor  */
    1 format "9" /* Tipo_CPF_CNPJ */
    vtipoped /* #1 1 */ format "9"          /* Tipo          */
    formatadata(dtinclu) format "xxxxxxxx"   /* Data_Vencimento  */
    0                   format "99999999"   /* Data_Cancel   */
    1                   format "9"          /* Tipo_Acrescimo*/
    0                format "9999999999999" /* Acrescimo */
    prevenda.precod        format "9999999999" /* Numero_PV */
    skip.
    

/***
    Registro 03
***/
vforma = if prevenda.crecod = 2
         then 93
         else 1.
if vforma = 93
then put unformatted
        "03"            format "xx"    /* tipo_reg */
        "00001"         format "99999" /* Numero_Pedido */
        vforma          format "99999" /* forma */
        pfincod         format "99999" /* prevenda */
        dec(ttproposta.valorservico) * 100   format "9999999999999"
        skip.

else do:
    if pmoedapdv <> 0
    then do:
        vforma = pmoedapdv.
         put unformatted
            "03"            format "xx"    /* tipo_reg */
            "00001"         format "99999" /* Numero_Pedido */
            vforma          format "99999" /* forma */
            0 /* forca plano 0*/ /*prevenda.pedcod */   format "99999" /* prevenda */
            dec(ttproposta.valorservico) * 100   format "9999999999999"
            skip.
    end.
end.


vservico = string(pprocod).

    put unformatted 
        "07"            format "xx"
        "09"            format "99"
        prevenda.etbcod    format "99999"
        prevenda.precod    format "9999999999" /* Numero_Pedido */
        9999            format "99999"
        pvencod    format "999999"     /* Codigo_Vendedor */
        vservico        format "x(30)"
        dec(ttproposta.valorservico)  * 100   format "9999999999999"
        ttproposta.idPropostaLebes format "x(30)"
        
        skip.




/***
    Registro 99
***/
put unformatted 
    "99"                format "xx"         /* Tipo_Reg */
    skip.

output close.

/* SCP PARA FILIAL */
if vpastap2k-filial <> "" and vpastap2k-filial <> ?
then do:
    hide message no-pause. message "copando arquivo do pedido para servidor da filial". pause 1 no-message.
    os-command silent value("scp-pass " + varq + " " + vpastap2k-filial).
    os-command silent value("rm -f "  + varq).
    hide message no-pause.
end.





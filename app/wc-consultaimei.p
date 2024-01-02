def input parameter p-etbcod    as int.
def input parameter p-imei    as char.
    
def var vcJSON as longchar.

def var vcMetodo as char.
def var vLCEntrada as longchar.
def var vLCSaida   as longchar.
def var vcsaida    as char.

vcMetodo = "consultaImeiRestResource".

DEFINE VARIABLE lokJSON                  AS LOGICAL.
def var hconsultaimeiEntrada          as handle.
def var hconsultaimeiSaida            as handle.
def var hretorno                         as handle.

/* ENTRADA */
DEFINE TEMP-TABLE ttentrada NO-UNDO SERIALIZE-NAME "consultaImeiEntrada"
    field codigoEstabelecimento as char 
    field codigoImei as char.
hconsultaimeiEntrada = TEMP-TABLE ttentrada:HANDLE.

{wc-consultaimei.i}


    
DEFINE DATASET consultaImeiSaida    
    FOR ttretornoimei, ttimei.
hconsultaimeiSaida = DATASET consultaimeiSaida:HANDLE.

create ttentrada.
ttentrada.codigoEstabelecimento = string(p-etbcod).
ttentrada.codigoimei         = string(p-imei).


lokJSON = hconsultaimeiEntrada:WRITE-JSON("longchar",vLCEntrada, TRUE).


run rest-barramento.p 
                 ( input  vcMetodo, 
                   input  vLCEntrada,  
                   output vLCSaida).


lokJSON = hconsultaimeiSaida:READ-JSON("longchar",vLCSaida, "EMPTY").


 

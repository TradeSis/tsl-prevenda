/* helio 09032022 - [ORQUESTRA 243179 - ESCOPO ADICIONAL] Seleção de moeda a vista na Pré-Venda  */

def input  param petbcod as int.
def input  param psequencia as char.
def output param ppromavista as log.
def output param ppromocoes as char.

ppromavista =  no.

def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hsaida as handle.
def var hEntrada as handle.

def var vsaida as char.

DEFINE VARIABLE lokJSON                  AS LOGICAL.


def temp-table ttpromocavista serialize-name "promocAVista"
    field codigoFilial      as char
    field codigoPromocao    as char.
        
def temp-table ttretorno serialize-name "return"
      field promocAVista    as char. /* true/false */
            
hentrada = temp-table ttpromocavista:handle.
hsaida   = temp-table ttretorno:handle.
def var vx as int.            

def var vchost as char.
def var vhostname as char.
def var vapi as char.
def var vlog as char.
def var vwork as char.

run lemestre.p ("api-log", output vlog).
run lemestre.p ("api-work", output vwork).
run lemestre.p ("api-host", output vchost).
if vchost = ""
then do:
    message "pdvpromavista ERRO host-api " vchost.
    return.
end.


hide message no-pause.
message "Aguarde... verificando promocao a vista " psequencia.

do vx = 1 to num-entries(psequencia):
    
    for each ttpromocavista. delete ttpromocavista. end.
    
    create ttpromocavista.
    ttpromocavista.codigoFilial = string(petbcod).
    ttpromocavista.codigoPromocao = string(entry(vx,psequencia)).

    hEntrada:WRITE-JSON("longchar",vLCEntrada, false).
                                
    def var vresposta as char.

    vsaida  = vwork + "/pdvpromavista" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + ".json". 

    output to value(vsaida + ".sh").
    put unformatted
        "curl -X POST -s \"http://" + vchost + "/bsweb/api/pdv/verificaPromocAVista/" + "\" " +
        " -H \"Content-Type: application/json\" " +
        " -d '" + string(vLCEntrada) + "' " + 
        " -o "  + vsaida.
    output close.


    unix silent value("sh " + vsaida + ".sh " + ">" + vsaida + ".erro").
    unix silent value("echo \"\n\">>"+ vsaida).

    input from value(vsaida) no-echo.
    import unformatted vresposta.
    input close.

    vLCsaida = vresposta.

    hSaida:READ-JSON("longchar",vLCSaida, "EMPTY") no-error.

    find first ttretorno no-error.    
    if avail ttretorno
    then do:
            ppromavista = ttretorno.promocAVista = "true".
            unix silent value("rm -f " + vsaida). 
            unix silent value("rm -f " + vsaida + ".erro"). 
            unix silent value("rm -f " + vsaida + ".sh"). 

            delete ttretorno.
            if ppromavista then do:
                ppromocoes = entry(vx,psequencia).
                leave.
            end.    
                    
    end.     
    hide message no-pause.

end.


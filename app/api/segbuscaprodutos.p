/* helio 17/08/2021 HubSeguro */
/*VERSAO 1*/


def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hsaida as handle.

{seg/defhubperfildin.i}

hsaida = TEMP-TABLE ttsegprodu:HANDLE.
                                
def var vsaida as char.
def var vresposta as char.

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
    message "api/segbuscaprodutos ERRO host-api " vchost.
    return.
end.


vsaida  = vwork + "/segbuscaprodutos" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + ".json". 

output to value(vsaida + ".sh").
put unformatted
    "curl -X POST -s \"http://" + vchost + "/bsweb/api/seguro/buscaProdutos" + "\" " +
    " -H \"Content-Type: application/json\" " +
 /*   " -d '" + string(vLCEntrada) + "' " + */
    " -o "  + vsaida.
output close.


hide message no-pause.
message "Aguarde... Fazendo Buscando Seguros no Matriz...".
unix silent value("sh " + vsaida + ".sh " + ">" + vsaida + ".erro").
unix silent value("echo \"\n\">>"+ vsaida).

input from value(vsaida) no-echo.
import unformatted vresposta.
input close.

vLCsaida = vresposta.

hSaida:READ-JSON("longchar",vLCSaida, "EMPTY").


            unix silent value("rm -f " + vsaida). 
            unix silent value("rm -f " + vsaida + ".erro"). 
            unix silent value("rm -f " + vsaida + ".sh"). 

hide message no-pause.


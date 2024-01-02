/* medico na tela 042022 - helio */

def input param petbcod as int.
def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hsaida as handle.
def var hentrada as handle.
{meddefs.i}

def temp-table ttentrada no-undo serialize-name "dadosEntrada"
    field codigoFilial as char.
create ttentrada.
ttentrada.codigoFilial = string(petbcod).
   
hentrada = TEMP-TABLE ttentrada:HANDLE.
hentrada:WRITE-JSON("LONGCHAR", vlcEntrada, TRUE).   
   
hsaida = DATASET medicoSaida:HANDLE.
                                
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
    message "medapibuscaprodutos ERRO host-api " vchost.
    return.
end.


vsaida  = vwork + "/medapibuscaprodutos" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + ".json". 

output to value(vsaida + ".sh").
put unformatted
    "curl -X POST -s \"http://" + vchost + "/bsweb/api/medico/buscaProdutos" + "\" " +
    " -H \"Content-Type: application/json\" " +
    " -d '" + string(vLCEntrada) + "' " + 
    " -o "  + vsaida.
output close.


hide message no-pause.
message "Aguarde... Fazendo Busca Produtos no Matriz...".
pause 1 no-message.
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




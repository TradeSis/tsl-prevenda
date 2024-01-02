/* helio 30102023 - Novo modelo TOKEN regional lojas - Orquestra 538865 */
def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hentrada as handle.

def var hsaida as handle.

{wc-consultamargemdesconto.i}

def var vcbarramento as char.
def var vhostname as char.
def var vapi as char.
def var vlog as char.
def var vwork as char.

run lemestre.p ("api-log", output vlog).
run lemestre.p ("api-work", output vwork).
run lemestre.p ("api-barramento", output vcbarramento).
if vcbarramento = ""
then do:
    message "apimargemdesconto ERRO api-barramento ".
    return.
end.

hentrada  = TEMP-TABLE ttconsultamargemdescontoEntrada:HANDLE.

hEntrada:WRITE-JSON("longchar",vLCEntrada, false).

DEFINE DATASET consultaMargemDescontoSaida
    FOR ttretornomargemdesconto, ttmargemDescontoProduto, ttmargemdesconto.
hsaida = DATASET consultamargemdescontoSaida:HANDLE.

def var vsaida as char.
def var vresposta as char.

vsaida  = vwork + "/margemdesconto" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + ".json". 

output to value(vsaida + ".sh").
put unformatted
    "curl -X POST -s \"http://" + vcbarramento "/gateway/pdvRestAPI/1.0/consultaMargemDescontoRestResource" + "\" " +
    " -H \"Content-Type: application/json\" " +
    " -d '" + string(vLCEntrada) + "' " + 
    " -o "  + vsaida.
output close.


hide message no-pause.
message "Aguarde... Buscando Margens desconto no Barramento...".
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




    

/* medico na tela 042022 - helio */

def output param pidPropostaLebes as char.
def output param pmensagem as char.

def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hsaida as handle.
def var hEntrada as handle.

{meddefs.i}
def temp-table tterro no-undo serialize-name "erro"
    field mensagem   as char.


hEntrada = DATASET dadosProposta:HANDLE.
hEntrada:WRITE-JSON("longchar",vLCEntrada, false).
                                
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
    message "medapienviaproposta ERRO host-api " vchost.
    return.
end.



vsaida  = vwork + "/medapienviaproposta" + string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + ".json". 

output to value(vsaida + ".sh").
put unformatted
    "curl -X POST -s \"http://" + vchost + "/bsweb/api/medico/enviaProposta/" + "\" " +
    " -H \"Content-Type: application/json\" " +
    " -d '" + string(vLCEntrada) + "' " + 
    " -o "  + vsaida.
output close.

hide message no-pause.
message "Aguarde... enviando Proposta " string(pcpf)  "no Barramento...".

unix silent value("sh " + vsaida + ".sh " + ">" + vsaida + ".erro").
unix silent value("echo \"\n\">>"+ vsaida).

input from value(vsaida) no-echo.
import unformatted vresposta.
input close.

hsaida = temp-table ttpropostaLebes:handle.
vLCsaida = vresposta.

hSaida:READ-JSON("longchar",vLCSaida, "EMPTY") no-error.
     pidPropostaLebes = ?.
     
    find first ttpropostalebes no-error.    
    if avail ttpropostalebes
    then do:
            pidPropostaLebes = ttpropostaLebes.idPropostaLebes.
                
            unix silent value("rm -f " + vsaida). 
            unix silent value("rm -f " + vsaida + ".erro"). 
            unix silent value("rm -f " + vsaida + ".sh"). 
            
        hide message no-pause.
        
    end.     
    else do:
    
        hsaida = temp-table tterro:handle.
        vLCsaida = vresposta.
        hSaida:READ-JSON("longchar",vLCSaida, "EMPTY").
        find first tterro no-error.
        if avail tterro
        then pmensagem = tterro.mensagem.
        
    
    end.

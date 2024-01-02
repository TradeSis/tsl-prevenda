/* #082022 helio bau */

def var pnomeapi as char        init "bau".
def var pnomerecurso as char    init "postProposta".

def output param pidPropostaLebes as char.
def output param presposta as char.

def var phttp_code as int.
def new global shared var setbcod as int.

def var vlcentrada as longchar.
def var vlcsaida as longchar.
def var hsaida as handle.
def var hentrada as handle.

{acentos.i}

    {baudefs.i}
def var vchost as char.
def var vlog as char.
def var vwork as char.
def var vapi  as char.
run lemestre.p ("api-log", output vlog).
run lemestre.p ("api-work", output vwork).
run lemestre.p ("api-host", output vchost).


    find first ttrespostas no-error.
        if not avail ttrespostas
        then do:
            create ttrespostas.
            
        end.
                               
    hentrada = dataset dadosProposta:HANDLE.
    hentrada:WRITE-JSON("LONGCHAR", vlcEntrada, TRUE).   
                                
def var vsaida as char.

DEF VAR startTime as DATETIME.
def var endTime   as datetime.
startTime = DATETIME(TODAY, MTIME).

def stream log.
output stream log to value(vlog + "/api" + pnomeapi + string(today,"99999999") + ".log") append.

put stream log unformatted 
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " ENTRADA->cpf=" + string(pcpf) + " loja=" + string(setbcod) skip.

vsaida  = vwork + replace(pnomeapi," ","") + replace(pnomerecurso," ","") +
            string(today,"999999") + replace(string(time,"HH:MM:SS"),":","") + string(spid) + ".json". 

    vapi = "http://\{IP\}/bsweb/api/bau/Proposta".
    
    vapi = replace(vapi,"\{IP\}",vchost).
    
put stream log unformatted 
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " sh "  vsaida + ".sh" skip.

output to value(vsaida + ".sh").
put unformatted
    "curl -X POST -s -k1 \"" + vapi + "\" " +
    " -H \"Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\" " +
    " -H \"Content-Type: application/json\" " +
    " --connect-timeout 15 --max-time 15 " + 
    " -w \"%\{response_code\}\" " +
/*    " --dump-header " + vsaida + ".header " + */
    " -d '" + string(vLCEntrada) + "' " + 
    " -o "  + vsaida.
output close.

hide message no-pause.
    message "Aguarde... executando " pnomeapi + "/" pnomerecurso "em " vchost.

put stream log unformatted 
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " curl POST " vapi skip.

unix silent value("sh " + vsaida + ".sh " + ">" + vsaida + ".erro").
unix silent value("echo \"\n\">>"+ vsaida).
unix silent value("echo \"\n\">>"+ vsaida + ".erro").

put stream log unformatted 
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " json "  vsaida skip.

input from value(vsaida + ".erro") no-echo.
import unformatted phttp_code.
input close.
put stream log unformatted  
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " HTTP_CODE->"  phttp_code skip.

input from value(vsaida) no-echo.
import unformatted presposta.
input close.

put stream log unformatted  
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " SAIDA->" + presposta skip.

endTime = DATETIME(TODAY, MTIME).

def var xtime as int.

xtime = INTERVAL( endTime, startTime,"milliseconds").

put stream log unformatted  
    pnomeapi " PID=" spid "_" spidseq " "
    pnomerecurso " " startTime 
    " FINAL DA EXECUCAO>" endTime  "  tempo da api em milissegundos=>" string(xtime) skip.

vLCsaida = presposta.

if phttp_code = 200 
then do:
    hsaida = temp-table ttpropostaLebes:handle.

    hSaida:READ-JSON("longchar",vLCSaida, "EMPTY") no-error.
    pidPropostaLebes = ?.
     
    find first ttpropostalebes no-error.    
    if avail ttpropostalebes
    then do: 
        pidPropostaLebes = ttpropostaLebes.idPropostaLebes.
        unix silent value("rm -f " + vsaida). 
        unix silent value("rm -f " + vsaida + ".erro"). 
        unix silent value("rm -f " + vsaida + ".sh"). 
    end.
end.
else do:
    
    hsaida = TEMP-TABLE tterro:HANDLE.
    presposta = "\{\"return\" : [ "  + presposta + " ] \}".
    vLCSaida = presposta.
    hSaida:READ-JSON("longchar",vLCSaida, "EMPTY").
    find first tterro no-error.
    if avail tterro and trim(tterro.erro) <> ""
    then do:
        hide message no-pause.
        message phttp_code removeacento(tterro.erro).
        presposta = tterro.erro.
        pause 2 no-message.
    end.        

end.


hide message no-pause.



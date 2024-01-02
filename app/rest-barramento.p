/* helio 29042022 - retirei log */
/* helio 23.03.2021 */
def input  parameter vcMetodo   as char. 
def input  parameter vLCEntrada as longchar.
def output parameter vLCSaida   as longchar.

DEFINE VARIABLE vhSocket   AS HANDLE           NO-UNDO.
DEFINE var vcSite     AS CHARACTER     NO-UNDO.


def var vcbarramento as char.
def var vhostname as char.
def var vapi as char.
def var vlog as char.
def var vwork as char.
def var vchost as char.
def var vcport as char.
run lemestre.p ("api-log", output vlog).
run lemestre.p ("api-work", output vwork).
run lemestre.p ("api-barramento", output vcbarramento).
if vcbarramento = ""
then do:
    message "pdvapiconsultarproduto ERRO api-barramento ".
    return.
end.
vchost = entry(1,vcbarramento,":").
vcport = entry(2,vcbarramento,":").

if vcSite = "" then vcSite = "/gateway/pdvRestAPI/1.0".

message vchost vcport. pause 1 no-message.

CREATE SOCKET vhSocket.
vhSocket:CONNECT('-H ' + vcHost + ' -S ' + vcPort) NO-ERROR.
hide message no-pause.    
IF vhSocket:CONNECTED() = FALSE THEN
DO:
    hide message no-pause.
    MESSAGE "Conexao falhou com " vcHost " Porta " vcPort.
    MESSAGE ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX.
    RETURN.
END.
 
vhSocket:SET-READ-RESPONSE-PROCEDURE('getResponse').

RUN PostRequest (
    INPUT vcSite + "/" + vcMetodo,    INPUT vlcEntrada).
 
WAIT-FOR READ-RESPONSE OF vhSocket. 
vhSocket:DISCONNECT() NO-ERROR.
DELETE OBJECT vhSocket.
return.
 
PROCEDURE getResponse:
    DEFINE VARIABLE lJson        AS LOGICAL          NO-UNDO.
    DEFINE VARIABLE mResponse    AS MEMPTR           NO-UNDO.

    def var vstring        as char no-undo.
    
    IF vhSocket:CONNECTED() = FALSE THEN do:
        MESSAGE 'Not Connected' VIEW-AS ALERT-BOX.
        RETURN.
    END.
    lJson = no.
def var vretorno as char.        


/*output to retorno.json. 
*output close.*/


    DO WHILE vhSocket:GET-BYTES-AVAILABLE() > 0:
            
         SET-SIZE(mResponse) = vhSocket:GET-BYTES-AVAILABLE() + 1.
         SET-BYTE-ORDER(mResponse) = BIG-ENDIAN.
         vhSocket:READ(mResponse,1,1,vhSocket:GET-BYTES-AVAILABLE()).
         
         vstring = GET-STRING(mResponse,1).
         vretorno = vretorno + vstring.

         
         /**output to retorno.json append.
         *put unformatted vretorno skip.
         output close.*/
         
                     
         if ljson = no
         then do:
            if vstring  =  "\{"
            then do:
                vlcsaida= vstring.
                ljson = yes.  
            end.
         end.
         else do:
             vlcSaida = vLCSaida + vstring /*gnGET-STRING(mResponse,1)*/ .
        end.     

    END.

END.

PROCEDURE PostRequest:
    DEFINE VARIABLE vcRequest      AS CHARACTER.
    DEFINE VARIABLE mRequest       AS MEMPTR.
    DEFINE INPUT PARAMETER postUrl AS CHAR. 
    DEFINE INPUT PARAMETER postData AS CHAR.

    def var vlf as char.
    vlf = '~r~n'.
    vlf = chr(10).

    vcRequest =
        'POST ' +
        postUrl +
        ' HTTP/1.0' + vlf +
/*        'Accept-Encoding: gzip,deflate ' + vlf +  */
        'Content-Type: application/json ' + vlf +
        'Content-Length: ' + string(LENGTH(postData)) +
        vlf + vlf +
        postData + vlf.
 

    /*output to post.socket.
    put unformatted vcRequest.
    output close.             */
    
    SET-SIZE(mRequest)            = 0.
    SET-SIZE(mRequest)            = LENGTH(vcRequest) + 1.
    SET-BYTE-ORDER(mRequest)      = BIG-ENDIAN.
    PUT-STRING(mRequest,1)        = vcRequest .
 
    vhSocket:WRITE(mRequest, 1, LENGTH(vcRequest)).
END PROCEDURE.


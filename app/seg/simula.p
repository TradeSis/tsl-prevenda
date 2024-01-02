{admcab.i}
def output param vfincod as int.
def output param vqtdvezes as int.

{seg/defhubperfildin.i}

find first ttsegprodu .
find first ttseguro .

def var vchost as char.

run lemestre.p ("api-host", output vchost).


    find first ttcampos where ttcampos.codigo =  "itemSegurado.quantidadeParcelas" no-error.
    vqtdvezes = if avail ttcampos
                then int(ttcampos.conteudo)
                else 0. 
    
    if vchost = "SV-CA-DB-DEV" or 
       vchost = "SV-CA-DB-QA" 
    then vfincod = 125.
    else do:
         run seg/simula_parcela_hubseg.p( 
            input pprocod,
            input vqtdvezes,
            output vfincod).
    end.

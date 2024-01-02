
/**                
                
                prevenda = no.
                run buscapre.p(output recpla).
                vprocod = 0.
                if recpla <> ?
                then do:
                    find plani where recid(plani) = recpla no-lock no-error.
                    prevenda = yes.
                    if acha("CARTAO-LEBES",plani.notobs[1]) <> ?
                    then scartao = acha("CARTAO-LEBES",plani.notobs[1]).
                end.
                else undo, retry.
**/
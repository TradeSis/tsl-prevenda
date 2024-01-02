/**                
                hide frame f-produ1   no-pause.  
                hide frame f-mensagem no-pause.
                hide frame f-opcom    no-pause.
                hide frame f-produ    no-pause.
    
                valor-dif = 0.
                run troca.p(output valor-dif, output v-vencod).
                            
                if valor-dif > 0
                then do:
                    find produ where produ.procod = 1 no-lock no-error.
                
                    find first wf-movim where wf-movim.wrec = recid(produ) 
                            no-lock no-error.
                    if not avail wf-movim
                    then do:
                        create wf-movim.
                        assign wf-movim.wrec      = recid(produ)
                               wf-movim.movalicms = 17
                               wf-movim.movpc     = valor-dif
                               wf-movim.movqtm    = 1
                               wf-movim.precoori  = valor-dif 
                               wf-movim.vencod    = v-vencod.
                    end.
                end.
                run p-atu-frame.
                view frame f-produ1.
                view frame f-opcom.
                view frame f-produ.
**/
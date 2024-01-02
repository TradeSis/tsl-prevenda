/**                
                 for each tp-titulo. delete tp-titulo. end.

                 if keyfunction(lastkey) = "end-error"
                 then do:
                    vnumero-chpu = "". vvalor-chpu = 0.
                    vnumero-chpu-aux = 0.
                    for each tt-cartpre: delete tt-cartpre. end.
                    next.
                 end.
                 
                 vnumero-chpu-aux = 0. vnumero-chpu = "". vvalor-chpu = 0.

                 hide frame f-chp no-pause.

                 update vnumero-chpu-aux label "Numero Cartao Presente"
                        help "Informe o Numero do Cartao Presente"
                        with frame f-utiliza-chp with centered
                                   row 9 side-labels overlay.
                 
                 vnumero-chpu = string(vnumero-chpu-aux).
                 
                 hide frame f-utiliza-chp no-pause.
                 
                 if vnumero-chpu = "" or vnumero-chpu-aux = 0
                 then do: 
                    message "Informe o Numero do Cartao Presente.". 
                    undo. 
                 end.
                 if search("/usr/admcom/progr/agil4_WG.p") <> ?
                 then do:
                     run agil4_WG.p(input "cartaopr",
                                    input vnumero-chpu).
                 end.
                 
                 find first tp-titulo where
                            tp-titulo.titnum =  vnumero-chpu and
                            tp-titulo.titsit <> "EXC"  and
                            tp-titulo.modcod = "CHP"
                            no-lock no-error.
                 if not avail tp-titulo
                 then do:
                     run msg2.p
                           (input-output dsresp,
                            input "    O CARTAO PRESENTE DE NUMERO " +
                                  string(vnumero-chpu) +
                            " NAO FOI ENCONTRADO NA MATRIZ." ,
                            input " *** ATENCAO *** ",
                            input "    OK").
                    
                    vnumero-chpu = "".
                    vnumero-chpu-aux = 0.
                    vvalor-chpu = 0.
                    undo, retry.
                 end.
                 else do:
                    if tp-titulo.titsit = "PAG"  or
                       tp-titulo.titsit = "1    PAG"
                    then do:
                         run msg2.p
                               (input-output dsresp,
                                input "    O CARTAO PRESENTE DE NUMERO " +
                                      string(vnumero-chpu) +
                                " JA FOI UTILIZADO." ,
                                input " *** ATENCAO *** ",
                                input "    OK").
            
                        vnumero-chpu = "".
                        vnumero-chpu-aux = 0.
                        vvalor-chpu = 0.
                        undo, retry.
                    end.
                    else if tp-titulo.titdtdes <> ? and
                            tp-titulo.titdtven <> ? and
                            (today < tp-titulo.titdtdes or
                             today > tp-titulo.titdtven)
                    then do:
                        run msg2.p
                               (input-output dsresp,
                                input "     CARTAO PRESENTE DE NUMERO " +
                                      string(vnumero-chpu) +
                                      "! USO FORA DA VALIDADE " +
                                      string(tp-titulo.titdtdes) + " A " +
                                      string(tp-titulo.titdtven),
                                input " *** ATENCAO *** ",
                                input "    OK").
                        vnumero-chpu = "".
                        vnumero-chpu-aux = 0.
                        vvalor-chpu = 0.
                        undo, retry.
                    end.
                    else do:
                        find titulo where titulo.empcod = 19
                                      and titulo.titnat = yes
                                      and titulo.modcod = "CHP" 
                                      and titulo.etbcod = 999 
                                      and titulo.clifor = 110165 
                                      and titulo.titnum = vnumero-chpu 
                                      and titulo.titpar = 1 
                                    no-lock no-error.
                        if avail titulo
                        then do:
                          if titulo.titsit = "PAG" or
                             titulo.titsit = "1    PAG"
                          then do:
                             run msg2.p
                                   (input-output dsresp,
                                    input "    O CARTAO PRESENTE DE NUMERO " +
                                          string(vnumero-chpu) +
                                    " JA FOI UTILIZADO." ,
                                    input " *** ATENCAO *** ",
                                    input "    OK").
                            vnumero-chpu = "".
                            vnumero-chpu-aux = 0.
                            vvalor-chpu = 0.
                            undo, retry.
                          end.
                          else
                          if titulo.titsit = "LIB" and
                             tp-titulo.titsit = "LIB" and
                             tp-titulo.titvlcob = 0
                          then do:
                              create tp-titulo.
                              buffer-copy titulo to tp-titulo.
                          end.
                        end.
                        vvalor-chpu = tp-titulo.titvlcob.
                    end.
                 end.               

                 run mensagem.p (input-output dsresp,
                                 input "CARTAO PRESENTE ENCONTRADO:!" +
                                      "!      NUMERO: " + STRING(vnumero-chpu) +
                                      "!      VALOR.: " + STRING(vvalor-chpu) +
                                       " REAIS" +
                                       "!!" +
                                       "     CONFIRMA A UTILIZACAO DO CARTAO "
                                       + "PRESENTE NESTA VENDA? ",
                                 input "",
                                 input "Sim", 
                                 input "Nao").
                 if not dsresp 
                 then do:
                     vnumero-chpu = "". vvalor-chpu = 0.
                     vnumero-chpu-aux = 0.
                     undo, retry.
                 end.
                 else do:
                     vtotven = 0.
                     for each bwf-movim:
                        vtotven = vtotven 
                                + (bwf-movim.movpc * bwf-movim.movqtm).
                     end.
                     
                     if vvalor-chpu > vtotven
                     then do:
                         run msg2.p
                               (input-output dsresp,
                                input "    O VALOR DA VENDA DEVE SER IGUAL " +
                                     "OU MAIOR AO VALOR DO CARTAO PRESENTE. " +
                                   "!!" +
                                   "    O CARTAO PRESENTE NAO FOI VINCULADO " +
                                   "A VENDA." ,
                                input " *** ATENCAO *** ",
                                input "    OK").    
                        vnumero-chpu = "".
                        vnumero-chpu-aux = 0.
                        vvalor-chpu = 0.
                        undo, retry.
                     end.
                     
                     find tt-cartpre where 
                          tt-cartpre.numero = int(tp-titulo.titnum) no-error.
                     if not avail tt-cartpre
                     then do:
                         create tt-cartpre.
                         assign tt-cartpre.numero = int(tp-titulo.titnum)
                                tt-cartpre.valor  = vvalor-chpu.
                     end.
                     vmensagem = "Venda utilizando Cartao Presente.".          
                     disp vmensagem with frame f-chp.
                 end.
                 next.
**/

def var vsenha like func.senha format "x(10)".
{admcab.i new}
wdata = today.

on F5 help.
on PF5 help.
on PF7 help.
on F7 help.
on f6 help.
on PF6 help.
def var vfuncod like func.funcod.

find estab where estab.etbcod = setbcod no-lock.
find first wempre no-lock.

def var vempre as char format "x(74)".

vempre = trim(caps(wempre.emprazsoc)) + 
        " / " + trim(caps(estab.etbnom)).
display vempre @  wempre.emprazsoc
                    wdata with frame fc1.

do on endkey undo, return:

    vsenha = "".

    hide frame f-vivo no-pause.
    hide frame f-spc no-pause.

    update skip(2) space(10)
            vfuncod label "Matricula"
           vsenha blank space(10)
           skip(2)
           with frame f-senh side-label centered row 10
           title "Filial " + string(setbcod) + " - " + estab.munic.

    if vfuncod = 0 and
       vsenha  = "proedlinx"
    then return.
    
    find first func where func.funcod = vfuncod and
                          func.etbcod = setbcod and
                          func.senha  = vsenha no-lock no-error.
    if not avail func
    then do:
        message "Funcionario" vfuncod "Invalido para filial " setbcod.
        undo, retry.
    end.
    else sfuncod = func.funcod.

end.

hide frame fca no-pause.

find estab where estab.etbcod = setbcod no-lock.
find first wempre no-lock.

vempre = trim(caps(wempre.emprazsoc)) + " / " + trim(caps(estab.etbnom))
 + "-" + trim(func.funnom).
               
display vempre  @  wempre.emprazsoc
                    wdata with frame fc1.


        hide frame f-senh no-pause.

        run menuprojeto.p.    

    quit.


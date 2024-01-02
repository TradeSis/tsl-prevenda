def new global shared var setbcod as int.

def input  parameter  par-tipo          as char format "x(40)".
def output parameter  par-valor         as char format "x(40)".
def var               v-tipo            as char format "x(40)".
def var               v-valor           as char format "x(40)".
assign par-valor = ""
       v-tipo    = ""
       v-valor   = "".
if search("../etc/mestre" + string(setbcod) + ".ini") <> ?
then do:
    input from value("../etc/mestre" + string(setbcod) + ".ini") no-echo.
    repeat:
        set v-tipo
            v-valor.
        if par-tipo = v-tipo
        then do:
            par-valor = v-valor.
            leave.
        end.    
    end. 
    input close.
end.        
if par-valor = ""
then do:
    if search("../etc/mestre.ini") <> ?
    then do:
        input from value("../etc/mestre.ini") no-echo.
        repeat:
            set v-tipo
                v-valor.
            if par-tipo = v-tipo
            then do:
                par-valor = v-valor.
                leave.
            end.    
        end. 
        input close.
    end.        
end.


if par-tipo = "api-log"
then do:
    par-valor = par-valor + string(setbcod,"9999") + "/".
    unix silent value("mkdir -p " + par-valor).
end.
if par-tipo = "api-work"
then do:
    par-valor = par-valor + string(setbcod,"9999") + "/".
    unix silent value("mkdir -p " + par-valor).
end.
if par-tipo = "pasta-p2k"
then do:
    par-valor = par-valor + string(setbcod,"9999") + "/".
    unix silent value("mkdir -p " + par-valor).
end.
if par-tipo = "pasta-relat"
then do:
    par-valor = par-valor + string(setbcod,"9999") + "/".
    unix silent value("mkdir -p " + par-valor).
end.
if par-tipo = "pasta-pdf"
then do:
    par-valor = par-valor + string(setbcod,"9999") + "/".
    unix silent value("mkdir -p " + par-valor).
end.




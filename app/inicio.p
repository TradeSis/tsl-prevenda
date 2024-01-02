
def var vpropath        as char format "x(150)".

input from ../etc/propath no-echo.  /* Seta Propath */
set vpropath with width 200 no-box frame ff.
input close.
propath = vpropath.

def new global shared var setbcod as int.
setbcod = int(SESSION:PARAMETER).            

run ../app/login.p.
quit.

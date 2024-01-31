
def new global shared var setbcod as int.
setbcod = int(SESSION:PARAMETER).            
def var vpathhml as char.

def var vhml as char format "x(78)" extent 4 initial
    ["1-Versao de Producao",
     "2-Homologacao Melhoria Venda Outra Loja",
     "3-Homologacao Melhoria Novo modelo TOKEN regional lojas - Orquestra 538865",
     "4-Homologacao Melhoria 555859 - Duas Garantias em produtos iguais PRÉ VENDA"].

disp vhml with frame fhml
    with centered no-labels 1 col.
choose field vhml go-on(F4 PF4) with frame fhml.
if keyfunction(lastkey) = "end-error" then quit.

vpathhml = "".
if frame-index = 2 
then vpathhml = "/u/prevenda/desenv/VENDAO/,".
if frame-index = 3 
then vpathhml = "/u/prevenda/desenv/538865/,".
if frame-index = 4 
then vpathhml = "/u/prevenda/desenv/555859/,".

hide frame fhml no-pause.
propath = vpathhml + "../teste/," +  propath.
message propath. pause.
status default vhml[frame-index].


run login.p.
quit.

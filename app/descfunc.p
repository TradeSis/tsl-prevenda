{dftempWG.i}  

def input param p-ciccgc as char.
def var v-ciccgc as char.
def var vi as int.
v-ciccgc = "".
do vi = 1 to length(p-ciccgc):
    if substring(p-ciccgc,vi,1) = "0" or
        substring(p-ciccgc,vi,1) = "1" or
        substring(p-ciccgc,vi,1) = "2" or
        substring(p-ciccgc,vi,1) = "3" or
        substring(p-ciccgc,vi,1) = "4" or
        substring(p-ciccgc,vi,1) = "5" or
        substring(p-ciccgc,vi,1) = "6" or
        substring(p-ciccgc,vi,1) = "7" or
        substring(p-ciccgc,vi,1) = "8" or
        substring(p-ciccgc,vi,1) = "9"
    then v-ciccgc = v-ciccgc + substring(p-ciccgc,vi,1).
end.

find first clien where
           clien.ciccgc = v-ciccgc  
            no-lock no-error.

if avail clien 
then find first tipo_clien where tipo_clien.tipocod = clien.tipocod
                                    no-lock no-error.
            
        create tt-descfunc.
        assign tt-descfunc.ciccgc = v-ciccgc.
        
        if avail clien
        then assign tt-descfunc.tem_cadastro = yes.
        else assign tt-descfunc.tem_cadastro = no.
    
        if avail tipo_clien and tipo_clien.tipodes = "FUNCIONARIO"
        then assign tt-descfunc.tipo_funcionario = yes.
        else assign tt-descfunc.tipo_funcionario = no.

        tt-descfunc.desc31 = 0.
        tt-descfunc.desc41 = 0.         
        
        for each categoria where categoria.desc_func > 0 no-lock.
            if categoria.catcod = 31
            then do:
                assign tt-descfunc.desc31 = categoria.desc_func.
            end.    
            if categoria.catcod = 41
            then do:
                tt-descfunc.desc41 = categoria.desc_func.
            end.
        end.
    


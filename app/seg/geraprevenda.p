
def new global shared var setbcod as int.

def input param par-fin as recid.
def input param par-clf as recid.
def input param videntificador as char.
def input param v-vencod as int.
def output param rec-prevenda as recid.

def buffer xestab for estab.

def var vprecod as int.
    
vprecod = 1.
do on error undo:
    find last prevenda where prevenda.etbcod = setbcod exclusive no-error.
    if avail prevenda
    then do:
        vprecod = prevenda.precod + 1.
    end. 
    release prevenda.
    create prevenda. 
    prevenda.etbcod = setbcod. 
    prevenda.precod = vprecod. 
    prevenda.DtInclu = today.
    prevenda.HorIncl = time.
    
    rec-prevenda = recid(prevenda).
end.

find finan where recid(finan) = par-fin no-lock.
find clien where recid(clien) = par-clf no-lock.

do on error undo:
    release prevenda.
    find prevenda where recid(prevenda)= rec-prevenda exclusive no-error.

    find xestab where xestab.etbcod = prevenda.etbcod no-lock.

    prevenda.clicod  = clien.clicod.
    prevenda.fincod  = finan.fincod.
    prevenda.crecod  = if finan.fincod = 0 then 1 else 2.
    prevenda.identificador = videntificador.
    prevenda.vencod  = v-vencod.

    /*
    *prevenda.pedidoespecial     = vpedidoespecial.
    *prevenda.dat-ped-especial   = vdat-ped-especial.
    *prevenda.obs-ped-especial   = vobs-ped-especial.
    *
    *if etb-entrega <> 0 and
    *   etb-entrega <> setbcod 
    *then do:
    *    prevenda.etb-entrega    = etb-entrega.
    *    prevenda.fone-retirada  = fone-retirada.
    *    prevenda.nome-retirada  = nome-retirada.
    *    prevenda.dat-entrega    = dat-entrega.
    *end.        
    *
    *
    *prevenda.cupomb2b = vcupomb2b.
    *prevenda.campanha               = par-campanha.
    *prevenda.valorcupomdesconto     = par-valorcupomdesconto.
    *prevenda.planocota              = vplanocota.
    *prevenda.supervisor             = p-supervisor.
    *prevenda.pmoeda                 = pmoeda.
    *prevenda.promocod               = vpromocod.
    */
    

end.


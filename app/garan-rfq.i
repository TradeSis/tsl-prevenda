/*
    Projeto Garantia/RFQ: out/2017
#1 Ajuste da quantidade
*/
def var vende-garan as log.

/*
  Para cada produto de seguro informa quais sao os produtos de venda
*/
def {1} SHARED temp-table tt-seg-movim
    field seg-procod  as int             /* procod do seguro */
    field procod      like movim.procod  /* procod de venda */
    field ramo        as int
    field meses       as int
    field subtipo     as char
    field movpc       like movim.movpc
    field precoori    like movim.movpc
    field p2k-datahoraprodu as char
    field p2k-id_seguro     as int
    field p2k-datahoraplano as char
    index seg-movim is primary unique seg-procod procod.

/*
  Para inclusao via WS
*/
def {1} SHARED temp-table tt-segprodu no-undo
    field sequencia  as char
    field seg-procod as int
    field tipo       as char
    field Meses      as int
    field prvenda    as dec
    field ramo       as int
    field padrao     as log
    field p2k-datahoraprodu as char
    field p2k-id_seguro     as int
    field p2k-datahoraplano as char.

/***
    Venda
***/
procedure vende-segprod.

    def input parameter par-procod   as int. /* procod da venda */
    def input parameter par-precoori as dec.
    def input parameter par-movpc    as dec.

    /*
        1. Verificar se tem seguro
    */
    def var vtempogar as int.
    find first produaux where produaux.procod     = produ.procod
                          and produaux.nome_campo = "TempoGar"
                        NO-LOCK no-error.
    if avail produaux
    then vtempogar = int(produaux.valor_campo).
    if vtempogar > 0
    then do.
        run garan-ws.p (par-procod, par-precoori, par-movpc).
        for each tt-segprodu where tt-segprodu.padrao no-lock
                break by tt-segprodu.ramo.
            if last-of (tt-segprodu.ramo)
            then run inclusao-segprod (recid(tt-segprodu),
                                       par-procod,
                                       par-movpc).
        end.
    end.

end procedure.


/***
    Inclusao de Seguro
***/
procedure inclusao-segprod.
    
    def input parameter par-rec-segpro as recid.
    def input parameter par-procod     as int.
    def input parameter par-preco      as dec.

    def buffer btt-segprodu for tt-segprodu.
    def buffer bprodu for produ.

    find btt-segprodu where recid(btt-segprodu) = par-rec-segpro no-lock.
    find bprodu where bprodu.procod = btt-segprodu.seg-procod no-lock.

    /*
      movim de um determinado seguro
    */
    find first wf-movim where wf-movim.wrec = recid(bprodu) no-lock no-error.
    if not avail wf-movim
    then do:
        create wf-movim.
        assign
            wf-movim.wrec      = recid(bprodu)
            wf-movim.movalicms = 98.
    end.
    wf-movim.movqtm = wf-movim.movqtm + 1.  /* helio 101123 - 555859 - Duas Garantias em produtos iguais PRÉ VENDA */
    wf-movim.movpc  = wf-movim.movpc + btt-segprodu.prvenda.

    /*
      Produtos que compoem o seguro
    */
    find first tt-seg-movim
                       where tt-seg-movim.seg-procod = btt-segprodu.seg-procod
                         and tt-seg-movim.procod     = par-procod
                       no-error.
    if not avail tt-seg-movim
    then do.
        create tt-seg-movim.
        assign
            tt-seg-movim.seg-procod = btt-segprodu.seg-procod
            tt-seg-movim.procod     = par-procod
            tt-seg-movim.ramo       = btt-segprodu.ramo
            tt-seg-movim.meses      = btt-segprodu.meses
            tt-seg-movim.subtipo    = btt-segprodu.tipo
            tt-seg-movim.movpc      = btt-segprodu.prvenda
            tt-seg-movim.precoori   = par-preco
            tt-seg-movim.p2k-datahoraprodu = btt-segprodu.p2k-datahoraprodu
            tt-seg-movim.p2k-id_seguro     = btt-segprodu.p2k-id_seguro
            tt-seg-movim.p2k-datahoraplano = btt-segprodu.p2k-datahoraplano.
    end.

end procedure.


/***
    Exclui
***/
procedure exclui-segprod.
    def input parameter par-procod   as int. /* Produto de venda */
    def input parameter par-segprodu as int. /* Produto de Seguro */

    def buffer bprodu for produ.
    def buffer btt-seg-movim for tt-seg-movim.

    for each tt-seg-movim where tt-seg-movim.procod = par-procod.
        if par-segprodu > 0 and
           tt-seg-movim.seg-procod <> par-segprodu
        then next.

        /* Verifica se tem outro produto de venda para este seguro */
        find bprodu where bprodu.procod = tt-seg-movim.seg-procod no-lock.
        find first wf-movim where wf-movim.wrec = recid(bprodu).
        assign
            wf-movim.movqtm = wf-movim.movqtm - 1.  /* helio 101123 - 555859 - Duas Garantias em produtos iguais PRÉ VENDA */
            wf-movim.movpc  = wf-movim.movpc  - tt-seg-movim.movpc.
        if wf-movim.movqtm <= 0  /* helio 101123 - 555859 - Duas Garantias em produtos iguais PRÉ VENDA */
        then delete wf-movim.

        delete tt-seg-movim.
    end.

/***
    run totaliza-garantia.
***/

end procedure.


/***
    Totaliza
procedure totaliza-garantia.

    def buffer bseg-produ for produ.

    for each tt-seg-movim no-lock break by tt-seg-movim.seg-procod.
        /* movim do seguro */
        find bseg-produ where bseg-produ.procod = tt-seg-movim.seg-procod
                         no-lock.
        find first wf-movim where wf-movim.wrec = recid(bseg-produ) no-lock.

        if first-of(tt-seg-movim.seg-procod)
        then assign
                wf-movim.movpc  = 0
                wf-movim.movqtm = 0.

        wf-movim.movpc = wf-movim.movpc + tt-seg-movim.movpc.
    end.

end procedure.
***/

/***
    Alteracao
    Se altrou o preco do produto deve chamar o Safe novamente
    Somente Garantia
***/
procedure altera-segprod.

    def input parameter par-procod as int. /* produto de venda */

    def var vpreco as dec.
    def buffer bseg-produ for produ.

    for each tt-seg-movim where tt-seg-movim.ramo = 710
                            /*and tt-seg-movim.movpc <> tt-seg-movim.precoori*/.
        if par-procod > 0 and
           tt-seg-movim.procod <> par-procod
        then next.

        /* Item de venda */
        find produ where produ.procod = tt-seg-movim.procod no-lock.
        find first wf-movim where wf-movim.wrec = recid(produ) no-lock.
        vpreco = wf-movim.movpc.

        if tt-seg-movim.precoori = wf-movim.movpc
        then next.

        run garan-ws.p (tt-seg-movim.procod,
                        wf-movim.movpc,
                        wf-movim.movpc).
        find first tt-segprodu
                         where tt-segprodu.seg-procod = tt-seg-movim.seg-procod
                         no-lock no-error.
        if avail tt-segprodu
        then do.
            find bseg-produ where bseg-produ.procod = tt-segprodu.seg-procod
                            no-lock.
            find first wf-movim where wf-movim.wrec = recid(bseg-produ).
            wf-movim.movpc = wf-movim.movpc
                             - tt-seg-movim.movpc
                             + tt-segprodu.prvenda.
            tt-seg-movim.movpc = tt-segprodu.prvenda.
            tt-seg-movim.precoori = vpreco.
        end.
    end.

end procedure.


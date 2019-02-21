if !exists("g:textbeat_previous_virtualedit")
    let g:textbeat_previous_virtualedit = &virtualedit
endif

set virtualedit=all

if v:version < 800
    finish
endif
if !has('pythonx')
    finish
endif

pyx import txbtclient

function! txbt#play()
    pyx txbtclient.VimTextbeat.play()
endfunc
function! txbt#stop()
    pyx txbtclient.VimTextbeat.play()
endfunc
function! txbt#playline()
    pyx txbtclient.VimTextbeat.playline()
endfunc
function! txbt#reload()
    pyx txbtclient.VimTextbeat.reload()
endfunc
function! txbt#poll(a)
    pyx txbtclient.VimTextbeat.poll()
endfunc
function! txbt#starttimer()
    if exists('s:txbttimer')
        call timer_stop(s:txbttimer)
    endif
    let s:txbttimer = timer_start(20, 'txbt#poll', {'repeat':-1})
endfunc
function! txbt#stoptimer()
    call timer_stop(s:txbttimer)
    unlet s:txbttimer
endfunc

command! -buffer -nargs=0 TextbeatPlay call txbt#play()
command! -buffer -nargs=0 TextbeatPlayLine call txbt#playline()
command! -buffer -nargs=0 TextbeatReload call txbt#reload()
command! -buffer -nargs=0 TextbeatStartTimer call txbt#starttimer()
command! -buffer -nargs=0 TextbeatStopTimer call txbt#stoptimer()

exec 'augroup textbeat-'. bufnr('%')
    au!
    au  BufRead,BufWritePost <buffer> TextbeatReload
    au  BufLeave <buffer> let &virtualedit = g:textbeat_previous_virtualedit
    au  BufEnter <buffer> let &virtualedit = 'all'
exec 'augroup END'

if !exists("g:textbeat_no_mappings") || !g:textbeat_no_mappings
    "nmap <silent><buffer> <cr><cr> :TextbeatPlay<cr>
    "nmap <silent><buffer> <cr><esc> :TextbeatStop<cr>
    "nmap <silent><buffer> <cr><space> :TextbeatPlayLine<cr>
endif

if exists("g:textbeat_path")
    pyx txbtclient.VimTextbeat.set_txbt_path(vim.eval("g:textbeat_path"))
else
    pyx txbtclient.VimTextbeat.set_txbt_path("textbeat")
endif

if exists("g:textbeat_python")
    pyx txbtclient.VimTextbeat.set_python(vim.eval("g:textbeat_python"))
else
    pyx txbtclient.VimTextbeat.set_python("python")
endif


" NOTE: You must, of course, install the ack script
"       in your path.
" On Debian / Ubuntu:
"   sudo apt-get install ack-grep
" On your vimrc:
"   let g:ackprg="ack-grep -H --nocolor --nogroup"
"
" With MacPorts:
"   sudo port install p5-app-ack

" Location of the ack utility
if !exists("g:ackprg")
	let g:ackprg="ack -H --nocolor --nogroup"
endif

function! s:Ack(cmd, args)
    redraw
    echo "Searching ..."

    let grepprg_bak=&grepprg
    try
        let &grepprg=g:ackprg
        silent execute a:cmd . " " . a:args
    finally
        let &grepprg=grepprg_bak
    endtry

    if a:cmd =~# '^l'
        botright lopen
    else
        botright copen
    endif
    redraw!
endfunction

function! s:AckFromSearch(cmd, args)
    let search =  getreg('/')
    " translate vim regular expression to perl regular expression.
    let search = substitute(search,'\(\\<\|\\>\)','\\b','g')
    call s:Ack(a:cmd, '"' .  search .'" '. a:args)
endfunction

command! -bang -nargs=* -complete=file Ack call s:Ack('grep<bang>',<q-args>)
command! -bang -nargs=* -complete=file AckAdd call s:Ack('grepadd<bang>', <q-args>)
command! -bang -nargs=* -complete=file AckFromSearch call s:AckFromSearch('grep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAck call s:Ack('lgrep<bang>', <q-args>)
command! -bang -nargs=* -complete=file LAckAdd call s:Ack('lgrepadd<bang>', <q-args>)

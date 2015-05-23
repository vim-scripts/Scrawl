" ============================================================================
" File: scrawl.vim
" Description: vim plugin which provides a customizable scratch buffer
" Maintainer: Evergreen
" Version: 1.0.0
" Last Change: May 6th, 2015
" License: Vim License
" ============================================================================

" ----------------------- Boilerplate ------------------------------------ {{{

if exists("g:loaded_scrawl_autoload")
    finish
endif

let g:loaded_scrawl_autoload = 1

" Commands for use with each split direction
let s:split_commands = [
    \ 'aboveleft ', 'belowright ', 'vertical aboveleft ', 'vertical belowright ']

" ----------------------- END Boilerplate -------------------------------- }}}

" ----------------------- Functions -------------------------------------- {{{

" Function: scrawl#setBufOptions() {{{
" Set the various options for the scrawl buffer
function! scrawl#setBufOptions()
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal foldcolumn=0
    setlocal nobuflisted
    if &filetype ==# ''
        execute 'setfiletype ' . g:scrawl_filetype
    endif
endfunction
" }}}

" Function: scrawl#winExists() {{{
" Checks to see if there is another scrawl window open in the same tab.
" If window exists, return the window number.  If it doesn't exist, return
" -1.
function! scrawl#winExists()
    return bufwinnr(scrawl#getBufName())
endfunction
" }}}

" Function: scrawl#getBufName() {{{
" Figure out what name the scrawl buffer should have based on which tab page
" it is located in.
function! scrawl#getBufName()
    let l:id = tabpagenr()
    let l:name = g:scrawl_buffer_name
    let l:name = printf('%s (%s)', l:name, l:id)
    return fnameescape(l:name)
endfunction
" }}}

" Function: scrawl#openScrawlWindow() {{{
" Open the scrawl window in a split according to settings.  Change to scrawl
" window if it already exists. If a scrawl buffer already exists, open that
" in the split.
function! scrawl#openScrawlWindow()
    let l:winexists = scrawl#winExists()

    if l:winexists == -1
        if g:scrawl_split_direction < 0 || g:scrawl_split_direction > 3
            echohl Error
            echom printf("Scrawl: '%s' is not a valid split direction.",
                        \ g:scrawl_split_direction)
            echohl Normal
            let g:scrawl_split_direction = 0
        endif

        if g:scrawl_window_size > 0
            execute s:split_commands[g:scrawl_split_direction] .
                        \ g:scrawl_window_size . 'new '. scrawl#getBufName()
        elseif g:scrawl_window_size == 0
            execute s:split_commands[g:scrawl_split_direction] . 'new ' .
                        \ scrawl#getBufName()
        else
            echohl Error
            echom printf("Scrawl: '%s' is not a valid window size.",
                        \ g:scrawl_window_size)
            echohl Normal
        endif

        call scrawl#setBufOptions()
        let b:scrawl_origin = 'split'
        let b:scrawl_original_file = ''
    else
        execute l:winexists . 'wincmd w'
    endif
endfunction
" }}}

" Function: scrawl#openScrawlBuffer() {{{
" Opens the buffer according to settings, if the current buffer isn't a scrawl
" buffer.
function! scrawl#openScrawlBuffer()
    if scrawl#winExists() != -1
        call scrawl#closeScrawlWindow()
    endif

    let l:original_file = bufname("%")
    execute 'edit ' . scrawl#getBufName()
    let b:scrawl_original_file = l:original_file
    call scrawl#setBufOptions()
    let b:scrawl_origin = 'open'
endfunction
" }}}

" Function: scrawl#closeScrawlWindow() {{{
" Find out if there is an open scrawl window in the current tab, and close it.
" Only closes the window if there are other windows or tabs.
function! scrawl#closeScrawlWindow()
    let l:winexists = scrawl#winExists()

    if l:winexists != -1
        execute l:winexists . 'wincmd w'
        if b:scrawl_origin == 'split'
            close
        elseif b:scrawl_origin == 'open'
            execute 'edit ' . b:scrawl_original_file
        endif
    endif
endfunction
" }}}

" Function: scrawl#toggleWindow() {{{
" Toggles scrawl split.
function! scrawl#toggleWindow()
    if scrawl#winExists() != -1
        call scrawl#closeScrawlWindow()
    else
        call scrawl#openScrawlWindow()
    endif
endfunction
" }}}

" Function: scrawl#toggleBuffer() {{{
" Toggles scrawl buffer.
function! scrawl#toggleBuffer()
    if scrawl#winExists() != -1
        call scrawl#closeScrawlWindow()
    else
        call scrawl#openScrawlBuffer()
    endif
endfunction
" }}}

" ----------------------- END Functions ---------------------------------- }}}

" vim: set sw=4 sts=4 et fdm=marker:


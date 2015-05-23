" ============================================================================
" File: scrawl.vim
" Description: vim plugin which provides a customizable scratch buffer
" Maintainer: Evergreen
" Version: 1.0.0
" Last Change: May 6th, 2015
" License: Vim License
" ============================================================================

" ------------------------ Script Initialization ------------------------- {{{

if exists("g:loaded_scrawl") || &cp || v:version < 700
    finish
endif

let g:loaded_scrawl = 1

" ------------------------ END Script Initialization --------------------- }}}

" ------------------------ Settings -------------------------------------- {{{

" Function: s:initVariable(var, value) {{{
" This function is used to initialise a given variable to a given value. The
" variable is only initialised if it does not exist prior
"
" Args:
" var: the name of the var to be initialised
" value: the value to initialise var to
"
" Returns:
" 1 if the var is set, 0 otherwise
function! s:initVariable(var, value)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . "'" . substitute(a:value, "'", "''", "g") . "'"
        return 1
    endif
    return 0
endfunction
" }}}

" Section: Default settings {{{
call s:initVariable('g:scrawl_buffer_name', '__Scrawl__')
call s:initVariable('g:scrawl_filetype', 'text')
call s:initVariable('g:scrawl_split_direction', 0)
call s:initVariable('g:scrawl_window_size', 0)
" }}}

" ------------------------ END Settings ---------------------------------- }}}

" ------------------------ Command Definitions --------------------------- {{{

command -nargs=0 ScrawlSplitToggle call scrawl#toggleWindow()
command -nargs=0 ScrawlBufferToggle call scrawl#toggleBuffer()
command -nargs=0 ScrawlBuffer call scrawl#openScrawlBuffer()
command -nargs=0 ScrawlClose call scrawl#closeScrawlWindow()
command -nargs=0 ScrawlSplit call scrawl#openScrawlWindow()

" ------------------------ END Command Definitions ----------------------- }}}

" vim: set sw=4 sts=4 et fdm=marker:

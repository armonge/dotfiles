" What command to use
function! s:Cmd() abort
    " Linux/BSD
    if executable("xdg-open")
        return "xdg-open"
    endif
    " MacOS
    if executable("open")
        return "open"
    endif
    " Windows
    return "explorer"
endfunction

call system(<SID>Cmd() . " " . "\"" . expand("%:p") . "\"") | bdelete | redraw

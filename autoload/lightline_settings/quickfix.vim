function! lightline_settings#quickfix#Mode(...) abort
    let name = getwininfo(win_getid())[0]['loclist'] ? 'Location' : 'Quickfix'
    let title = lightline_settings#Trim(get(w:, 'quickfix_title', ''))
    let maxlen = (&columns - strlen(name) - 2)
    if strlen(title) > maxlen
        let cmd = ''
        for part in split(title, ' ')
            if strlen(cmd . ' ' . part) > (maxlen - 3)
                break
            endif
            let cmd = cmd . ' ' . part
        endfor
        let title = cmd . ' ' . g:lightline_symbols.ellipsis
    endif
    return { 'name': name, 'plugin': title }
endfunction

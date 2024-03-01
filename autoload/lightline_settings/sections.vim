function! lightline_settings#sections#Mode(...) abort
    let l:mode = lightline_settings#parts#Integration()
    if len(l:mode)
        return l:mode['name']
    endif

    return lightline#concatenate([
                \ lightline_settings#parts#Mode(),
                \ lightline_settings#parts#Clipboard(),
                \ lightline_settings#parts#Paste(),
                \ lightline_settings#parts#Spell(),
                \ ], 0)
endfunction

function! lightline_settings#sections#Plugin(...) abort
    let l:mode = lightline_settings#parts#Integration()
    if len(l:mode)
        if has_key(l:mode, 'link')
            call lightline#link(l:mode['link'])
        else
            return get(l:mode, 'plugin', '')
        endif
    endif
    return call('s:RenderPluginSection', a:000)
endfunction

function! s:RenderPluginSection(...) abort
    return ''
endfunction

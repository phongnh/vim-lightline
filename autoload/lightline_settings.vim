if exists('*trim')
    function! s:Strip(str) abort
        return trim(a:str)
    endfunction
else
    function! s:Strip(str) abort
        return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
    endfunction
endif

function! lightline_settings#Strip(str) abort
    return s:Strip(a:str)
endfunction

if exists('*pathshorten')
    function! s:ShortenPath(filename) abort
        return pathshorten(a:filename)
    endfunction
else
    function! s:ShortenPath(filename) abort
        return substitute(a:filename, '\v\w\zs.{-}\ze(\\|/)', '', 'g')
    endfunction
endif

function! lightline_settings#ShortenPath(file) abort
    return s:ShortenPath(a:file)
endfunction

" Copied from https://github.com/itchyny/lightline-powerful/blob/master/autoload/lightline_powerful.vim
function! lightline_settings#Init() abort
    setglobal noshowmode

    let g:lightline_buffer_count_by_basename = {}

    function! s:UpdateBufferCount() abort
        let g:lightline_buffer_count_by_basename = {}
        let bufnrs = filter(range(1, bufnr('$')), 'buflisted(v:val) && bufexists(v:val) && len(bufname(v:val))')
        for name in map(bufnrs, 'expand("#" . v:val . ":t")')
            if name !=# ''
                let g:lightline_buffer_count_by_basename[name] = get(g:lightline_buffer_count_by_basename, name) + 1
            endif
        endfor
    endfunction

    augroup lightline_settings_buffer_count
        autocmd!
        autocmd BufEnter,WinEnter,WinLeave * call s:UpdateBufferCount()
    augroup END
endfunction

" Alternate status dictionaries
let g:lightline_filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__CtrlSF__':           'CtrlSF',
            \ '__CtrlSFPreview__':    'Preview',
            \ '__flygrep__':          'FlyGrep',
            \ '__Tagbar__':           'Tagbar',
            \ '__Gundo__':            'Gundo',
            \ '__Gundo_Preview__':    'Gundo Preview',
            \ '__Mundo__':            'Mundo',
            \ '__Mundo_Preview__':    'Mundo Preview',
            \ '[BufExplorer]':        'BufExplorer',
            \ '[Command Line]':       'Command Line',
            \ '[Plugins]':            'Plugins',
            \ '__committia_status__': 'Committia Status',
            \ '__committia_diff__':   'Committia Diff',
            \ '__doc__':              'Document',
            \ '__LSP_SETTINGS__':     'LSP Settings',
            \ }

let g:lightline_filetype_modes = {
            \ 'simplebuffer':      'SimpleBuffer',
            \ 'netrw':             'Netrw',
            \ 'molder':            'Molder',
            \ 'dirvish':           'Dirvish',
            \ 'vaffle':            'Vaffle',
            \ 'nerdtree':          'NERDTree',
            \ 'fern':              'Fern',
            \ 'neo-tree':          'NeoTree',
            \ 'carbon.explorer':   'Carbon',
            \ 'oil':               'Oil',
            \ 'NvimTree':          'NvimTree',
            \ 'CHADTree':          'CHADTree',
            \ 'LuaTree':           'LuaTree',
            \ 'Mundo':             'Mundo',
            \ 'MundoDiff':         'Mundo Preview',
            \ 'undotree':          'Undo',
            \ 'diff':              'Diff',
            \ 'startify':          'Startify',
            \ 'alpha':             'Alpha',
            \ 'dashboard':         'Dashboard',
            \ 'ministarter':       'Starter',
            \ 'tagbar':            'Tagbar',
            \ 'vista':             'Vista',
            \ 'vista_kind':        'Vista',
            \ 'vim-plug':          'Plugins',
            \ 'terminal':          'TERMINAL',
            \ 'help':              'HELP',
            \ 'qf':                'Quickfix',
            \ 'godoc':             'GoDoc',
            \ 'gedoc':             'GeDoc',
            \ 'gitcommit':         'Commit Message',
            \ 'fugitive':          'Fugitive',
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'GV':                'GV',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ 'GrepperSide':       'GrepperSide',
            \ 'SpaceVimFlyGrep':   'FlyGrep',
            \ 'startuptime':       'StartupTime',
            \ }

let s:lightline_filename_integrations = {
            \ 'ControlP':          'lightline_settings#ctrlp#Mode',
            \ '__CtrlSF__':        'lightline_settings#ctrlsf#Mode',
            \ '__CtrlSFPreview__': 'lightline_settings#ctrlsf#PreviewMode',
            \ '__flygrep__':       'lightline_settings#flygrep#Mode',
            \ '__Tagbar__':        'lightline_settings#tagbar#Mode',
            \ }

let s:lightline_filetype_integrations = {
            \ 'ctrlp':           'lightline_settings#ctrlp#Mode',
            \ 'netrw':           'lightline_settings#netrw#Mode',
            \ 'dirvish':         'lightline_settings#dirvish#Mode',
            \ 'molder':          'lightline_settings#molder#Mode',
            \ 'vaffle':          'lightline_settings#vaffle#Mode',
            \ 'fern':            'lightline_settings#fern#Mode',
            \ 'carbon.explorer': 'lightline_settings#carbon#Mode',
            \ 'neo-tree':        'lightline_settings#neotree#Mode',
            \ 'oil':             'lightline_settings#oil#Mode',
            \ 'tagbar':          'lightline_settings#tagbar#Mode',
            \ 'vista_kind':      'lightline_settings#vista#Mode',
            \ 'vista':           'lightline_settings#vista#Mode',
            \ 'gitcommit':       'lightline_settings#gitcommit#Mode',
            \ 'fugitive':        'lightline_settings#fugitive#Mode',
            \ 'GV':              'lightline_settings#gv#Mode',
            \ 'terminal':        'lightline_settings#terminal#Mode',
            \ 'help':            'lightline_settings#help#Mode',
            \ 'qf':              'lightline_settings#quickfix#Mode',
            \ 'GrepperSide':     'lightline_settings#grepper#Mode',
            \ 'SpaceVimFlyGrep': 'lightline_settings#flygrep#Mode',
            \ }

function! s:BufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:FileName() abort
    let fname = expand('%')
    return strlen(fname) ? fnamemodify(fname, ':~:.') : '[No Name]'
endfunction

function! s:IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! s:IsCompact(...) abort
    let l:winnr = get(a:, 1, 0)
    return winwidth(l:winnr) <= g:lightline_winwidth_config.compact ||
                \ count([
                \   s:IsClipboardEnabled(),
                \   &paste,
                \   &spell,
                \   &bomb,
                \   !&eol,
                \ ], 1) > 1
endfunction

function! lightline_settings#parts#Mode() abort
    if s:IsCompact()
        return get(g:lightline_short_mode_map, mode(), '')
    else
        return lightline#mode()
    endif
endfunction

function! lightline_settings#parts#Clipboard() abort
    return s:IsClipboardEnabled() ? g:lightline_symbols.clipboard : ''
endfunction

function! lightline_settings#parts#Paste() abort
    return &paste ? g:lightline_symbols.paste : ''
endfunction

function! lightline_settings#parts#Spell() abort
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! lightline_settings#parts#Indentation(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, s:IsCompact())
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! lightline_settings#parts#Readonly(...) abort
    return &readonly ? g:lightline_symbols.readonly . ' ' : ''
endfunction

function! lightline_settings#parts#Modified(...) abort
    if &modified
        return !&modifiable ? '[+-]' : '[+]'
    else
        return !&modifiable ? '[-]' : ''
    endif
endfunction

function! s:ZoomStatus(...) abort
    return get(g:, 'lightline_zoomed', 0) ? '[Z]' : ''
endfunction

function! lightline_settings#parts#LineInfo(...) abort
    return ''
endfunction

if g:lightline_show_linenr > 1
    function! lightline_settings#parts#LineInfo(...) abort
        return call('lightline_settings#lineinfo#Full', a:000) . ' '
    endfunction
elseif g:lightline_show_linenr > 0
    function! lightline_settings#parts#LineInfo(...) abort
        return call('lightline_settings#lineinfo#Simple', a:000) . ' '
    endfunction
endif

function! lightline_settings#parts#FileEncodingAndFormat() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:encoding = (l:encoding ==# 'utf-8') ? '' : l:encoding . ' '
    let l:bomb     = &bomb ? g:lightline_symbols.bomb . ' ' : ''
    let l:noeol    = &eol ? '' : g:lightline_symbols.noeol . ' '
    let l:format   = get(g:lightline_symbols, &fileformat, '[empty]')
    let l:format   = (l:format ==# '[unix]') ? '' : l:format . ' '
    return l:encoding . l:bomb . l:noeol . l:format
endfunction

function! lightline_settings#parts#FileType(...) abort
    return s:BufferType() . lightline_settings#devicons#FileType(expand('%'))
endfunction

function! lightline_settings#parts#FileName(...) abort
    return lightline_settings#parts#Readonly() . lightline_settings#FormatFileName(s:FileName()) . lightline_settings#parts#Modified() . s:ZoomStatus()
endfunction

function! lightline_settings#parts#InactiveFileName(...) abort
    return lightline_settings#parts#Readonly() . s:FileName() . lightline_settings#parts#Modified()
endfunction

function! lightline_settings#parts#Integration() abort
    let fname = expand('%:t')

    if has_key(g:lightline_filename_modes, fname)
        let result = { 'name': g:lightline_filename_modes[fname] }

        if has_key(s:lightline_filename_integrations, fname)
            return extend(result, function(s:lightline_filename_integrations[fname])())
        endif

        return result
    endif

    if fname =~# '^NrrwRgn_\zs.*\ze_\d\+$'
        return lightline_settings#nrrwrgn#Mode()
    endif

    let ft = s:BufferType()

    if ft ==# 'undotree' && exists('*t:undotree.GetStatusLine')
        return lightline_settings#undotree#Mode()
    endif

    if ft ==# 'diff' && exists('*t:diffpanel.GetStatusLine')
        return lightline_settings#undotree#DiffStatus()
    endif

    if has_key(g:lightline_filetype_modes, ft)
        let result = { 'name': g:lightline_filetype_modes[ft] }

        if has_key(s:lightline_filetype_integrations, ft)
            return extend(result, function(s:lightline_filetype_integrations[ft])())
        endif

        return result
    endif

    return {}
endfunction

function! lightline_settings#parts#GitBranch(...) abort
    return ''
endfunction

if g:lightline_show_git_branch > 0
    function! lightline_settings#parts#GitBranch(...) abort
        return lightline_settings#git#Branch()
    endfunction
endif

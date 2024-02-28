" lightline_settings.vim
" Maintainer: Phong Nguyen
" Version:    0.1.0

if exists('g:loaded_vim_lightline_settings') || v:version < 700
    finish
endif

let g:loaded_vim_lightline_settings = 1

let s:save_cpo = &cpo
set cpo&vim

" Settings
let g:lightline_powerline_fonts = get(g:, 'lightline_powerline_fonts', 0)
let g:lightline_theme           = get(g:, 'lightline_theme', 'solarized')
let g:lightline_shorten_path    = get(g:, 'lightline_shorten_path', 0)
let g:lightline_show_git_branch = get(g:, 'lightline_show_git_branch', 1)
let g:lightline_show_devicons   = get(g:, 'lightline_show_devicons', 1)
let g:lightline_show_vim_logo   = get(g:, 'lightline_show_vim_logo', 1)

" Window width
let g:lightline_winwidth_config = extend({
            \ 'xsmall': 60,
            \ 'small':  80,
            \ 'normal': 120,
            \ }, get(g:, 'lightline_winwidth_config', {}))

" Symbols: https://en.wikipedia.org/wiki/Enclosed_Alphanumerics
let g:lightline_symbols = {
            \ 'linenr':    '☰',
            \ 'branch':    '⎇ ',
            \ 'readonly':  '',
            \ 'clipboard': '🅒  ',
            \ 'paste':     '🅟  ',
            \ 'ellipsis':  '…',
            \ }

let g:lightline = {
            \ 'colorscheme': g:lightline_theme,
            \ 'enable': {
            \   'statusline': 1,
            \   'tabline':    1,
            \ },
            \ 'separator': {
            \   'left': '',
            \   'right': '',
            \ },
            \ 'subseparator': {
            \  'left': '|',
            \  'right': '|',
            \ },
            \ 'tabline': {
            \   'left':  [['tablabel'], ['tabs']],
            \   'right': [],
            \ },
            \ 'tab': {
            \   'active':   ['tabnum', 'readonly', 'filename', 'modified'],
            \   'inactive': ['tabnum', 'readonly', 'filename', 'modified'],
            \ },
            \ 'active': {
            \   'left':  [
            \       ['mode'],
            \       ['plugin'] + (get(g:, 'lightline_show_git_branch', 0) ? ['branch'] : []) + ['filename'],
            \   ],
            \   'right': [
            \       ['fileinfo'] + (get(g:, 'lightline_show_linenr', 0) ? ['lineinfo'] : []) + ['plugin_extra'],
            \       ['buffer'],
            \   ]
            \ },
            \ 'inactive': {
            \   'left':  [['inactive']],
            \   'right': []
            \ },
            \ 'component': {
            \   'tablabel':    'Tabs',
            \   'bufferlabel': 'Buffers',
            \ },
            \ 'component_function': {
            \   'mode':         'LightlineModeStatus',
            \   'plugin':       'LightlinePluginStatus',
            \   'branch':       'LightlineGitBranchStatus',
            \   'filename':     'LightlineFileNameStatus',
            \   'fileinfo':     'LightlineFileInfoStatus',
            \   'lineinfo':     'LightlineLineInfoStatus',
            \   'plugin_extra': 'LightlinePluginExtraStatus',
            \   'buffer':       'LightlineBufferStatus',
            \   'inactive':     'LightlineInactiveStatus',
            \ },
            \ 'tab_component_function': {
            \   'tabnum':   'LightlineTabNum',
            \   'filename': 'LightlineTabFileType',
            \   'readonly': 'LightlineTabReadonly',
            \ },
            \ }

if g:lightline_powerline_fonts
    call extend(g:lightline_symbols, {
                \ 'linenr':   "\ue0a1",
                \ 'branch':   "\ue0a0",
                \ 'readonly': "\ue0a2",
                \ })

    call lightline_settings#powerline#SetSeparators(get(g:, 'lightline_powerline_style', 'default'))
endif

let s:lightline_show_devicons = g:lightline_show_devicons && lightline_settings#devicons#Detect()

if g:lightline_show_vim_logo && s:lightline_show_devicons
    " Show Vim Logo in Tabline
    let g:lightline.component.tablabel    = "\ue7c5" . ' '
    let g:lightline.component.bufferlabel = "\ue7c5" . ' '
endif

if get(g:, 'lightline_bufferline', 0)
    call lightline_settings#bufferline#Init()
endif

command! LightlineReload call <SID>LightlineReload()
command! -nargs=1 -complete=custom,<SID>ListLightlineColorschemes LightlineTheme call <SID>SetLightlineTheme(<f-args>)

function! s:LightlineReload() abort
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

function! s:FindLightlineThemes() abort
    if exists('s:lightline_colorschemes')
        return s:lightline_colorschemes
    endif
    let s:lightline_colorschemes = map(split(globpath(&rtp, 'autoload/lightline/colorscheme/*.vim')), "fnamemodify(v:val, ':t:r')")
    let s:lightline_colorschemes_completion = join(s:lightline_colorschemes, "\n")
endfunction

function! s:ListLightlineColorschemes(...) abort
    return s:lightline_colorschemes_completion
endfunction

function! s:SetLightlineTheme(colorscheme) abort
    if index(s:lightline_colorschemes, a:colorscheme) < 0
        return
    endif

    " Reload palette
    let l:colorscheme_path = findfile(printf('autoload/lightline/colorscheme/%s.vim', a:colorscheme), &rtp)
    if !empty(l:colorscheme_path) && filereadable(l:colorscheme_path)
        execute 'source ' . l:colorscheme_path
    endif

    let g:lightline.colorscheme = a:colorscheme
    call s:LightlineReload()
endfunction

let s:lightline_colorscheme_mappings = {
            \ 'gruvbox': ['gruvbox8', 'gruvbox-material'],
            \ }

function! s:DetectLightlineTheme() abort
    let l:original_colorscheme = get(g:, 'colors_name', '')

    if has('vim_starting') && exists('g:lightline_theme')
        let l:original_colorscheme = g:lightline_theme
    endif

    if l:original_colorscheme =~ 'solarized\|soluarized\|flattened'
        let l:original_colorscheme = 'solarized'
    endif

    let l:colorscheme = l:original_colorscheme
    if index(s:lightline_colorschemes, l:colorscheme) > -1
        return l:colorscheme
    endif

    let l:colorscheme = tolower(l:original_colorscheme)
    if index(s:lightline_colorschemes, l:colorscheme) > -1
        return l:colorscheme
    endif

    for l:alternative_colorscheme in get(s:lightline_colorscheme_mappings, l:colorscheme, [])
        if index(s:lightline_colorschemes, l:alternative_colorscheme) > -1
            return l:alternative_colorscheme
        endif
    endfor

    let l:colorscheme = substitute(l:original_colorscheme, '-', '_', 'g')
    if index(s:lightline_colorschemes, l:colorscheme) > -1
        return l:colorscheme
    endif

    return substitute(l:original_colorscheme, '-', '', 'g')
endfunction

function! s:ReloadLightlineTheme() abort
    call s:FindLightlineThemes()

    let l:colorscheme = s:DetectLightlineTheme()

    call s:SetLightlineTheme(l:colorscheme)
endfunction

augroup VimLightlineColorscheme
    autocmd!
    autocmd VimEnter * call <SID>ReloadLightlineTheme() | setglobal noshowmode
    autocmd ColorScheme * call <SID>ReloadLightlineTheme()
augroup END

" Alternate status dictionaries
let s:filename_modes = {
            \ 'ControlP':             'CtrlP',
            \ '__CtrlSF__':           'CtrlSF',
            \ '__CtrlSFPreview__':    'Preview',
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

let s:filetype_modes = {
            \ 'netrw':             'Netrw',
            \ 'molder':            'Molder',
            \ 'nerdtree':          'NERDTree',
            \ 'CHADTree':          'CHADTree',
            \ 'NvimTree':          'NvimTree',
            \ 'neo-tree':          'NeoTree',
            \ 'oil':               'Oil',
            \ 'LuaTree':           'LuaTree',
            \ 'carbon.explorer':   'Carbon',
            \ 'fern':              'Fern',
            \ 'vaffle':            'Vaffle',
            \ 'dirvish':           'Dirvish',
            \ 'Mundo':             'Mundo',
            \ 'MundoDiff':         'Mundo Preview',
            \ 'startify':          'Startify',
            \ 'alpha':             'Alpha',
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
            \ 'fugitiveblame':     'FugitiveBlame',
            \ 'gitmessengerpopup': 'Git Messenger',
            \ 'GV':                'GV',
            \ 'agit':              'Agit',
            \ 'agit_diff':         'Agit Diff',
            \ 'agit_stat':         'Agit Stat',
            \ }

let s:short_modes = {
            \ 'NORMAL':   'N',
            \ 'INSERT':   'I',
            \ 'VISUAL':   'V',
            \ 'V-LINE':   'L',
            \ 'V-BLOCK':  'B',
            \ 'COMMAND':  'C',
            \ 'SELECT':   'S',
            \ 'S-LINE':   'S-L',
            \ 'S-BLOCK':  'S-B',
            \ 'TERMINAL': 'T',
            \ }

function! s:GetBufferType() abort
    return strlen(&filetype) ? &filetype : &buftype
endfunction

function! s:GetFileName() abort
    let fname = expand('%:~:.')

    if empty(fname)
        return '[No Name]'
    endif

    return fname
endfunction

function! s:FormatFileName(fname) abort
    let l:path = a:fname

    if winwidth(0) <= g:lightline_winwidth_config.xsmall
        return fnamemodify(l:path, ':t')
    endif

    if strlen(l:path) > 50 && g:lightline_shorten_path
        let l:path = lightline_settings#ShortenPath(l:path)
    endif

    if strlen(l:path) > 50
        let l:path = fnamemodify(l:path, ':t')
    endif

    return l:path
endfunction

function! s:ModifiedStatus() abort
    if &modified
        if !&modifiable
            return '[+-]'
        else
            return '[+]'
        endif
    elseif !&modifiable
        return '[-]'
    endif

    return ''
endfunction

function! s:ReadonlyStatus() abort
    return &readonly ? g:lightline_symbols.readonly . ' ' : ''
endfunction

function! s:FileNameStatus() abort
    return s:ReadonlyStatus() . s:FormatFileName(s:GetFileName()) . s:ModifiedStatus()
endfunction

function! s:InactiveFileNameStatus() abort
    return s:ReadonlyStatus() . s:GetFileName() . s:ModifiedStatus()
endfunction

function! s:IsClipboardEnabled() abort
    return match(&clipboard, 'unnamed') > -1
endfunction

function! s:ClipboardStatus() abort
    return s:IsClipboardEnabled() ? g:lightline_symbols.clipboard : ''
endfunction

function! s:PasteStatus() abort
    return &paste ? g:lightline_symbols.paste : ''
endfunction

function! s:SpellStatus() abort
    return &spell ? toupper(substitute(&spelllang, ',', '/', 'g')) : ''
endfunction

function! s:IndentationStatus(...) abort
    let l:shiftwidth = exists('*shiftwidth') ? shiftwidth() : &shiftwidth
    let compact = get(a:, 1, 0)
    if compact
        return printf(&expandtab ? 'SPC: %d' : 'TAB: %d', l:shiftwidth)
    else
        return printf(&expandtab ? 'Spaces: %d' : 'Tab Size: %d', l:shiftwidth)
    endif
endfunction

function! s:FileEncodingAndFormatStatus() abort
    let l:encoding = strlen(&fileencoding) ? &fileencoding : &encoding
    let l:bomb     = &bomb ? '[BOM]' : ''
    let l:format   = strlen(&fileformat) ? printf('[%s]', &fileformat) : ''

    " Skip common string utf-8[unix]
    if (l:encoding . l:format) ==# 'utf-8[unix]'
        return l:bomb
    endif

    return l:encoding . l:bomb . l:format
endfunction

function! s:FileInfoStatus(...) abort
    let parts = [
                \ s:FileEncodingAndFormatStatus(),
                \ s:GetBufferType(),
                \ ]

    let compact = get(a:, 1, 0)

    if s:lightline_show_devicons && !compact
        call extend(parts, [
                    \ lightline_settings#devicons#FileType(expand('%')) . ' ',
                    \ lightline_settings#devicons#FileFormat() . ' ',
                    \ ])
    endif

    return join(filter(copy(parts), '!empty(v:val)'), ' ')
endfunction

function! s:IsCompact() abort
    return &spell || &paste || s:IsClipboardEnabled() || winwidth(0) <= g:lightline_winwidth_config.xsmall
endfunction

function! LightlineModeStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return l:mode['name']
    endif

    let mode_label = lightline#mode()
    if winwidth(0) <= g:lightline_winwidth_config.xsmall
        return get(s:short_modes, mode_label, mode_label)
    endif

    return mode_label
endfunction

function! LightlineGitBranchStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return ''
    endif

    if winwidth(0) >= g:lightline_winwidth_config.small
        let branch = lightline_settings#git#Branch()
    endif

    return ''
endfunction

function! LightlineFileNameStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return ''
    endif

    return s:FileNameStatus()
endfunction

function! LightlineFileInfoStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return ''
    endif

    let compact = s:IsCompact()

    return s:FileInfoStatus(compact)
endfunction

function! LightlineLineInfoStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return ''
    endif

    if line('w0') == 1 && line('w$') == line('$')
        let l:percent = 'All'
    elseif line('w0') == 1
        let l:percent = 'Top'
    elseif line('w$') == line('$')
        let l:percent = 'Bot'
    else
        let l:percent = printf('%d%%', line('.') * 100 / line('$'))
    endif

    return printf('%4d:%-3d %3s', line('.'), col('.'), l:percent)
endfunction

function! LightlineBufferStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'buffer', '')
    endif

    if winwidth(0) >= g:lightline_winwidth_config.small
        return lightline#concatenate([
                    \ s:SpellStatus(),
                    \ s:PasteStatus(),
                    \ s:ClipboardStatus(),
                    \ s:IndentationStatus(s:IsCompact()),
                    \ ], 1)
    endif

    return ''
endfunction

function! LightlinePluginStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        if has_key(l:mode, 'link')
            call lightline#link(l:mode['link'])
        endif
        return get(l:mode, 'plugin', '')
    endif

    return ''
endfunction

function! LightlinePluginExtraStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        return get(l:mode, 'plugin_extra', '')
    endif

    return ''
endfunction

function! LightlineInactiveStatus() abort
    let l:mode = s:CustomMode()
    if len(l:mode)
        if has_key(l:mode, 'plugin_inactive')
            return lightline#concatenate(
                        \ [
                        \   l:mode['name'],
                        \   get(l:mode, 'plugin_inactive', '')
                        \ ], 0)
        endif
        return l:mode['name']
    endif

    return s:InactiveFileNameStatus()
endfunction

function! LightlineTabNum(n) abort
    " if s:has_devicons
    "     return printf('%d %s', a:n,  s:separators.tabline_subseparator.left)
    " endif
    return printf('%d:', a:n)
endfunction

" Copied from https://github.com/itchyny/lightline-powerful
let s:buffer_count_by_basename = {}
augroup lightline_settings
    autocmd!
    autocmd BufEnter,WinEnter,WinLeave * call s:update_bufnrs()
augroup END

function! s:update_bufnrs() abort
    let s:buffer_count_by_basename = {}
    let bufnrs = filter(range(1, bufnr('$')), 'len(bufname(v:val)) && bufexists(v:val) && buflisted(v:val)')
    for name in map(bufnrs, 'expand("#" . v:val . ":t")')
        if name !=# ''
            let s:buffer_count_by_basename[name] = get(s:buffer_count_by_basename, name) + 1
        endif
    endfor
endfunction

function! LightlineTabFileType(n) abort
    let bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
    let bufname = expand('#' . bufnr . ':t')
    let ft = gettabwinvar(a:n, tabpagewinnr(a:n), '&ft')
    if get(s:buffer_count_by_basename, bufname) > 1
        let fname = substitute(expand('#' . bufnr . ':p'), '.*/\([^/]\+/\)', '\1', '')
    else
        let fname = bufname
    endif
    return fname =~# '^\[preview' ? 'Preview' : get(s:filetype_modes, ft, get(s:filename_modes, fname, fname))
endfunction

" Copied from https://github.com/itchyny/lightline-powerful
function! LightlineTabReadonly(n) abort
    let winnr = tabpagewinnr(a:n)
    return gettabwinvar(a:n, winnr, '&readonly') ? g:lightline_symbols.readonly : ''
endfunction

" Plugin Integration
function! s:CustomMode() abort
    let fname = expand('%:t')

    if has_key(s:filename_modes, fname)
        let result = {
                    \ 'name': s:filename_modes[fname],
                    \ 'type': 'name',
                    \ }

        if fname ==# 'ControlP'
            return extend(result, lightline_settings#ctrlp#Mode())
        endif

        if fname ==# '__Tagbar__'
            return extend(result, lightline_settings#tagbar#Mode())
        endif

        if fname ==# '__CtrlSF__'
            return extend(result, lightline_settings#ctrlsf#Mode())
        endif

        if fname ==# '__CtrlSFPreview__'
            return extend(result, lightline_settings#ctrlsf#PreviewMode())
        endif

        return result
    endif

    if fname =~? '^NrrwRgn'
        let nrrw_rgn_mode = lightline_settings#nrrwrgn#Mode()
        if len(nrrw_rgn_mode)
            return nrrw_rgn_mode
        endif
    endif

    let ft = s:GetBufferType()
    if has_key(s:filetype_modes, ft)
        let result = {
                    \ 'name': s:filetype_modes[ft],
                    \ 'type': 'filetype',
                    \ }

        if ft ==# 'ctrlp'
            return extend(result, lightline_settings#ctrlp#Mode())
        endif

        if ft ==# 'netrw'
            return extend(result, lightline_settings#netrw#Mode())
        endif

        if ft ==# 'molder'
            return extend(result, lightline_settings#molder#Mode())
        endif

        if ft ==# 'neo-tree'
            return extend(result, lightline_settings#neotree#Mode())
        endif

        if ft ==# 'oil'
            return extend(result, lightline_settings#oil#Mode())
        endif

        if ft ==# 'carbon.explorer'
            return extend(result, lightline_settings#carbon#Mode())
        endif

        if ft ==# 'fern'
            return extend(result, lightline_settings#fern#Mode())
        endif

        if ft ==# 'vaffle'
            return extend(result, lightline_settings#vaffle#Mode())
        endif

        if ft ==# 'dirvish'
            return extend(result, lightline_settings#dirvish#Mode())
        endif

        if ft ==# 'tagbar'
            return extend(result, lightline_settings#tagbar#Mode())
        endif

        if ft ==# 'vista_kind' || ft ==# 'vista'
            return extend(result, lightline_settings#vista#Mode())
        endif

        if ft ==# 'terminal'
            return extend(result, lightline_settings#terminal#Mode())
        endif

        if ft ==# 'help'
            return extend(result, lightline_settings#help#Mode())
        endif

        if ft ==# 'qf'
            return extend(result, lightline_settings#quickfix#Mode())
        endif

        return result
    endif

    return {}
endfunction

" Disable NERDTree statusline
let g:NERDTreeStatusline = -1

" CtrlP Integration
let g:ctrlp_status_func = {
            \ 'main': 'lightline_settings#ctrlp#MainStatus',
            \ 'prog': 'lightline_settings#ctrlp#ProgressStatus',
            \ }

" Tagbar Integration
let g:tagbar_status_func = 'lightline_settings#tagbar#Status'

" ZoomWin Integration
let g:lightline_zoomwin_funcref = []

if exists('g:ZoomWin_funcref')
    if type(g:ZoomWin_funcref) == v:t_func
        let g:lightline_zoomwin_funcref = [g:ZoomWin_funcref]
    elseif type(g:ZoomWin_funcref) == v:t_func
        let g:lightline_zoomwin_funcref = g:ZoomWin_funcref
    endif
    let g:lightline_zoomwin_funcref = uniq(copy(g:lightline_zoomwin_funcref))
endif

let g:ZoomWin_funcref = function('lightline_settings#zoomwin#Status')

let &cpo = s:save_cpo
unlet s:save_cpo

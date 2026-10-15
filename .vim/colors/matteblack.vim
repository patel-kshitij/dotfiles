" Matte Black for Vim/MacVim, ported from tahayvr/matteblack.nvim
hi clear
if exists('syntax_on') | syntax reset | endif
set background=dark
let g:colors_name = 'matteblack'

let s:p = {
      \ 'bg0': '#0D0D0D', 'bg1': '#121212', 'bg2': '#333333', 'bg3': '#212121', 'bg4': '#262626',
      \ 'fg0': '#FFFFFF', 'fg1': '#EAEAEA', 'fg2': '#BEBEBE', 'fg3': '#8A8A8D',
      \ 'red': '#B91C1C', 'crimson': '#DC2626', 'orange': '#F59E0B', 'amber': '#D97706',
      \ 'yellow': '#FBBF24', 'gold': '#EFBF04', 'green': '#059669', 'teal': '#10B981',
      \ 'blue': '#3B82F6', 'purple': '#8D20B2', 'cyan': '#1EA7A0', 'none': 'NONE' }

" s:hi(group, fg, bg, attr)
function! s:hi(group, fg, ...) abort
  let l:bg = a:0 >= 1 ? a:1 : 'none'
  let l:attr = a:0 >= 2 ? a:2 : 'NONE'
  execute printf('hi %s guifg=%s guibg=%s gui=%s cterm=%s', a:group, s:p[a:fg], s:p[l:bg], l:attr, l:attr)
endfunction

call s:hi('Normal', 'fg1', 'bg1')
call s:hi('NormalFloat', 'fg1', 'bg3')
call s:hi('SignColumn', 'bg2', 'bg1')
call s:hi('NonText', 'bg2')
call s:hi('EndOfBuffer', 'bg1')
call s:hi('Cursor', 'bg1', 'orange')
call s:hi('CursorLine', 'none', 'bg3')
call s:hi('CursorColumn', 'none', 'bg3')
call s:hi('ColorColumn', 'none', 'bg3')
call s:hi('CursorLineNr', 'orange', 'none', 'bold')
call s:hi('LineNr', 'bg2')
call s:hi('MatchParen', 'orange', 'bg4', 'bold')
call s:hi('Visual', 'fg0', 'bg2')
call s:hi('Search', 'bg1', 'orange')
call s:hi('IncSearch', 'bg1', 'gold')
call s:hi('CurSearch', 'bg1', 'gold')
call s:hi('FoldColumn', 'bg2', 'bg1')
call s:hi('Folded', 'fg2', 'bg3')
call s:hi('StatusLine', 'fg1', 'bg3')
call s:hi('StatusLineNC', 'fg3', 'bg2')
call s:hi('StatusLineTerm', 'fg1', 'bg3')
call s:hi('StatusLineTermNC', 'fg3', 'bg2')
call s:hi('VertSplit', 'bg2', 'bg1')
call s:hi('TabLine', 'fg3', 'bg2')
call s:hi('TabLineFill', 'none', 'bg1')
call s:hi('TabLineSel', 'fg1', 'bg3', 'bold')
call s:hi('Pmenu', 'fg2', 'bg3')
call s:hi('PmenuSel', 'fg1', 'bg2')
call s:hi('PmenuSbar', 'none', 'bg2')
call s:hi('PmenuThumb', 'none', 'fg3')
call s:hi('WildMenu', 'bg1', 'orange')
call s:hi('Title', 'orange', 'none', 'bold')
call s:hi('Directory', 'blue')
call s:hi('ErrorMsg', 'crimson')
call s:hi('WarningMsg', 'amber')
call s:hi('MoreMsg', 'teal')
call s:hi('Question', 'teal')
call s:hi('ModeMsg', 'fg2')
call s:hi('SpecialKey', 'bg2')
call s:hi('SpellBad', 'none', 'none', 'undercurl')
call s:hi('SpellCap', 'none', 'none', 'undercurl')
call s:hi('DiffAdd', 'teal', 'bg3')
call s:hi('DiffDelete', 'crimson', 'bg3')
call s:hi('DiffChange', 'orange', 'bg3')
call s:hi('DiffText', 'orange', 'bg4', 'bold')

" Syntax
call s:hi('Comment', 'fg3', 'none', 'italic')
call s:hi('Constant', 'amber')
call s:hi('String', 'fg1')
call s:hi('Character', 'gold')
call s:hi('Number', 'gold')
call s:hi('Float', 'gold')
call s:hi('Boolean', 'teal')
call s:hi('Identifier', 'amber')
call s:hi('Function', 'crimson')
call s:hi('Statement', 'green')
call s:hi('Keyword', 'green')
call s:hi('Conditional', 'green')
call s:hi('Repeat', 'green')
call s:hi('Exception', 'green')
call s:hi('Operator', 'fg2')
call s:hi('PreProc', 'yellow')
call s:hi('Include', 'blue')
call s:hi('Define', 'yellow')
call s:hi('Macro', 'yellow')
call s:hi('Type', 'yellow')
call s:hi('StorageClass', 'yellow')
call s:hi('Structure', 'yellow')
call s:hi('Typedef', 'yellow')
call s:hi('Special', 'orange')
call s:hi('SpecialChar', 'gold')
call s:hi('Tag', 'green')
call s:hi('Delimiter', 'fg3')
call s:hi('Underlined', 'orange', 'none', 'underline')
call s:hi('Todo', 'bg1', 'yellow', 'bold')
call s:hi('Error', 'crimson', 'none', 'bold')

" Plugins: gitgutter, NERDTree, yegappan/lsp
call s:hi('GitGutterAdd', 'teal', 'bg1')
call s:hi('GitGutterChange', 'orange', 'bg1')
call s:hi('GitGutterDelete', 'crimson', 'bg1')
call s:hi('NERDTreeDir', 'fg2')
call s:hi('NERDTreeDirSlash', 'fg3')
call s:hi('NERDTreeOpenable', 'orange')
call s:hi('NERDTreeClosable', 'orange')
call s:hi('LspDiagSignErrorText', 'crimson', 'bg1')
call s:hi('LspDiagSignWarningText', 'amber', 'bg1')
call s:hi('LspDiagSignInfoText', 'gold', 'bg1')
call s:hi('LspDiagSignHintText', 'blue', 'bg1')
call s:hi('LspDiagVirtualTextError', 'crimson')
call s:hi('LspDiagVirtualTextWarning', 'amber')
call s:hi('LspDiagVirtualTextInfo', 'gold')
call s:hi('LspDiagVirtualTextHint', 'blue')
call s:hi('LspTextRef', 'none', 'bg2')
call s:hi('LspReadRef', 'none', 'bg2')
call s:hi('LspWriteRef', 'none', 'bg2')

let g:terminal_ansi_colors = [
      \ '#333333', '#B91C1C', '#129B70', '#F59E0B', '#325DCA', '#8D20B2', '#1EA7A0', '#BEBEBE',
      \ '#8A8A8D', '#E62222', '#22C55E', '#F1CB42', '#3C71F6', '#B027DE', '#24D0C7', '#FFFFFF' ]

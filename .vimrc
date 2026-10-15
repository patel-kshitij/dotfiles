" ~/.vimrc — Vim/MacVim IDE setup
" Shares language servers with Neovim (installed by Mason in ~/.local/share/nvim/mason).
" Old Vundle config: ~/.vimrc.bak-20261015

set nocompatible
let mapleader = " "

" ---------------------------------------------------------------- Plugins
" Bootstrap vim-plug on a fresh machine
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'yegappan/lsp'                                  " language servers
Plug 'hrsh7th/vim-vsnip'                             " snippets
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets'
Plug 'junegunn/fzf', { 'dir': '/opt/homebrew/opt/fzf' }
Plug 'junegunn/fzf.vim'                              " fuzzy finder
Plug 'preservim/nerdtree'                            " file tree
Plug 'tpope/vim-fugitive'                            " git
Plug 'airblade/vim-gitgutter'                        " git signs in gutter
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'itchyny/lightline.vim'                         " statusline
Plug 'ghifarit53/tokyonight-vim'                     " same theme as Neovim
Plug 'ryanoasis/vim-devicons'                        " must load last
call plug#end()

packadd! comment     " built-in: gcc / gc to comment
packadd! matchit

" ---------------------------------------------------------------- Options
filetype plugin indent on
syntax on
set encoding=utf-8
set number cursorline signcolumn=yes
set mouse=a clipboard=unnamed
set scrolloff=8 sidescrolloff=8 nowrap
set splitbelow splitright
set expandtab shiftwidth=4 tabstop=4 softtabstop=4 smartindent
set ignorecase smartcase incsearch hlsearch
set hidden confirm autoread
set undofile undodir=~/.vim/undo// noswapfile
set updatetime=250 timeoutlen=500 ttimeoutlen=10
set laststatus=2 noshowmode showcmd
set wildmenu wildoptions=pum,fuzzy
set completeopt=menuone,noselect,popup
set foldmethod=indent foldlevel=99
set backspace=indent,eol,start
set list listchars=tab:»\ ,trail:·,nbsp:␣
set belloff=all shortmess+=c
if !isdirectory(expand('~/.vim/undo')) | call mkdir(expand('~/.vim/undo'), 'p') | endif

" Cursor shape in terminal Vim: bar in insert, block in normal
let &t_SI = "\e[6 q" | let &t_EI = "\e[2 q"

set termguicolors
let g:tokyonight_style = 'night'
let g:tokyonight_enable_italic = 1
silent! colorscheme tokyonight
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'active': { 'left': [['mode', 'paste'], ['gitbranch', 'readonly', 'relativepath', 'modified']] },
      \ 'component_function': { 'gitbranch': 'FugitiveHead' } }

augroup user_config
  autocmd!
  " 2-space indent for web files
  autocmd FileType javascript,typescript,javascriptreact,typescriptreact,json,html,css,scss,yaml,markdown,vim
        \ setlocal shiftwidth=2 tabstop=2 softtabstop=2
  " Wrap and spellcheck prose
  autocmd FileType markdown,gitcommit,text setlocal wrap linebreak spell
  " Reopen files at the last cursor position
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe 'normal! g`"' | endif
  autocmd FocusGained,BufEnter * silent! checktime
augroup END

" ---------------------------------------------------------------- Language servers
let s:mason = expand('~/.local/share/nvim/mason/bin/')
" MacVim launched from the Dock may not inherit Homebrew's PATH (needed for node, rg, fd, glow)
if $PATH !~# '/opt/homebrew/bin' | let $PATH = '/opt/homebrew/bin:' .. $PATH | endif

let s:lsp_opts = #{
      \ autoComplete: v:true,
      \ completionMatcher: 'fuzzy',
      \ showDiagWithVirtualText: v:true,
      \ diagVirtualTextAlign: 'after',
      \ diagSignErrorText: '●', diagSignWarningText: '●',
      \ diagSignInfoText: '●', diagSignHintText: '●',
      \ usePopupInCodeAction: v:true,
      \ popupBorder: v:true,
      \ showSignature: v:true,
      \ showInlayHints: v:false,
      \ vsnipSupport: v:true,
      \ ignoreMissingServer: v:true,
      \ outlineOnRight: v:true,
      \ outlineWinSize: 35,
      \ }

let s:servers = [
      \ #{ name: 'basedpyright', filetype: ['python'],
      \    path: s:mason .. 'basedpyright-langserver', args: ['--stdio'],
      \    workspaceConfig: #{ basedpyright: #{ disableOrganizeImports: v:true,
      \                        analysis: #{ typeCheckingMode: 'standard' } } } },
      \ #{ name: 'ruff', filetype: ['python'],
      \    path: s:mason .. 'ruff', args: ['server'],
      \    features: #{ hover: v:false } },
      \ #{ name: 'vtsls',
      \    filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
      \    path: s:mason .. 'vtsls', args: ['--stdio'],
      \    rootSearch: ['tsconfig.json', 'jsconfig.json', 'package.json', '.git'] },
      \ #{ name: 'html', filetype: ['html'],
      \    path: s:mason .. 'vscode-html-language-server', args: ['--stdio'] },
      \ #{ name: 'cssls', filetype: ['css', 'scss', 'less'],
      \    path: s:mason .. 'vscode-css-language-server', args: ['--stdio'] },
      \ #{ name: 'jsonls', filetype: ['json', 'jsonc'],
      \    path: s:mason .. 'vscode-json-language-server', args: ['--stdio'] },
      \ #{ name: 'clangd', filetype: ['c', 'cpp'],
      \    path: s:mason .. 'clangd',
      \    args: ['--background-index', '--clang-tidy', '--header-insertion=iwyu'],
      \    initializationOptions: #{ fallbackFlags: ['-Wall', '-Wextra', '-std=c17'] } },
      \ #{ name: 'jdtls', filetype: ['java'],
      \    path: s:mason .. 'jdtls',
      \    args: ['-data', expand('~/.cache/vim-jdtls/') .. substitute(getcwd(), '/', '%', 'g')],
      \    rootSearch: ['pom.xml', 'build.gradle', 'build.gradle.kts', '.git'] },
      \ #{ name: 'marksman', filetype: ['markdown'],
      \    path: s:mason .. 'marksman', args: ['server'] },
      \ ]

augroup user_lsp
  autocmd!
  autocmd User LspSetup call LspOptionsSet(s:lsp_opts) | call LspAddServer(s:servers)
  autocmd User LspAttached call s:on_lsp_attach()
augroup END

function! s:on_lsp_attach() abort
  nnoremap <buffer> gd         <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gD         <Cmd>LspGotoDeclaration<CR>
  nnoremap <buffer> gr         <Cmd>LspShowReferences<CR>
  nnoremap <buffer> gI         <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> gy         <Cmd>LspGotoTypeDef<CR>
  nnoremap <buffer> K          <Cmd>LspHover<CR>
  nnoremap <buffer> <leader>ca <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <leader>cr <Cmd>LspRename<CR>
  nnoremap <buffer> <F2>       <Cmd>LspRename<CR>
  nnoremap <buffer> <leader>cf <Cmd>LspFormat<CR>
  xnoremap <buffer> <leader>cf :LspFormat<CR>
  nnoremap <buffer> <leader>co <Cmd>LspOrganizeImports<CR>
  nnoremap <buffer> <leader>ch <Cmd>LspInlayHints toggle<CR>
  nnoremap <buffer> <leader>cd <Cmd>LspDiag current<CR>
  nnoremap <buffer> <leader>xx <Cmd>LspDiag show<CR>
  nnoremap <buffer> <leader>ss <Cmd>LspDocumentSymbol<CR>
  nnoremap <buffer> <leader>sS <Cmd>LspSymbolSearch<CR>
  nnoremap <buffer> <leader>xs <Cmd>LspOutline<CR>
  nnoremap <buffer> <leader>cl <Cmd>LspShowAllServers<CR>
  nnoremap <buffer> ]d         <Cmd>LspDiag nextWrap<CR>
  nnoremap <buffer> [d         <Cmd>LspDiag prevWrap<CR>
  inoremap <buffer> <C-k>      <Cmd>LspShowSignature<CR>
endfunction

" Format on save (only for languages whose server can format)
let g:autoformat = 1
augroup user_format
  autocmd!
  autocmd BufWritePre *.py,*.js,*.jsx,*.ts,*.tsx,*.json,*.html,*.css,*.scss,*.c,*.h,*.cpp,*.java
        \ if g:autoformat | silent! LspFormat | endif
augroup END
nnoremap <leader>cF <Cmd>let g:autoformat = !g:autoformat<Bar>echo 'Format on save: ' .. (g:autoformat ? 'on' : 'off')<CR>

" Completion: Tab / S-Tab to move (or jump snippets), Enter to accept
imap <expr> <Tab>   pumvisible() ? "\<C-n>" : vsnip#jumpable(1)  ? "\<Plug>(vsnip-jump-next)" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : vsnip#jumpable(-1) ? "\<Plug>(vsnip-jump-prev)" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() && complete_info(['selected']).selected != -1 ? "\<C-y>" : "\<CR>"
let g:vsnip_filetypes = #{ javascriptreact: ['javascript'], typescriptreact: ['typescript'] }

" ---------------------------------------------------------------- Finding things (fzf)
let g:fzf_layout = #{ window: #{ width: 0.9, height: 0.8 } }
let g:fzf_vim = #{ preview_window: ['right,50%', 'ctrl-/'] }
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
nnoremap <leader><space> <Cmd>Files<CR>
nnoremap <leader>ff      <Cmd>Files<CR>
nnoremap <leader>fg      <Cmd>Rg<CR>
nnoremap <leader>/       <Cmd>Rg<CR>
nnoremap <leader>fw      <Cmd>execute 'Rg ' .. expand('<cword>')<CR>
nnoremap <leader>fb      <Cmd>Buffers<CR>
nnoremap <leader>fr      <Cmd>History<CR>
nnoremap <leader>fl      <Cmd>BLines<CR>
nnoremap <leader>fh      <Cmd>Helptags<CR>
nnoremap <leader>fk      <Cmd>Maps<CR>
nnoremap <leader>fc      <Cmd>Commands<CR>
nnoremap <leader>:       <Cmd>History:<CR>

" ---------------------------------------------------------------- File tree
let NERDTreeIgnore = ['\.pyc$', '\~$', '__pycache__', '\.DS_Store']
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1
let NERDTreeWinSize = 32
nnoremap <leader>e  <Cmd>NERDTreeToggle<CR>
nnoremap <leader>E  <Cmd>NERDTreeFind<CR>
" Close Vim if the tree is the last window
autocmd user_config BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ---------------------------------------------------------------- Git
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▁'
nmap ]h          <Plug>(GitGutterNextHunk)
nmap [h          <Plug>(GitGutterPrevHunk)
nmap <leader>hs  <Plug>(GitGutterStageHunk)
nmap <leader>hr  <Plug>(GitGutterUndoHunk)
nmap <leader>hp  <Plug>(GitGutterPreviewHunk)
nnoremap <leader>gs  <Cmd>Git<CR>
nnoremap <leader>gb  <Cmd>Git blame<CR>
nnoremap <leader>gl  <Cmd>Git log --oneline<CR>
nnoremap <leader>gd  <Cmd>Gvdiffsplit<CR>
nnoremap <leader>gg  <Cmd>tab terminal ++close lazygit<CR>

" ---------------------------------------------------------------- Terminal, run, preview
" Toggle a terminal at the bottom (in the terminal: Esc Esc for normal mode, then <leader>t)
function! s:toggle_term() abort
  let bufs = filter(term_list(), 'getbufvar(v:val, "user_term")')
  if !empty(bufs)
    let win = bufwinnr(bufs[0])
    if win > 0 | execute win .. 'close' | else | execute 'botright sbuffer ' .. bufs[0] | resize 12 | endif
  else
    botright terminal ++rows=12
    let b:user_term = 1
  endif
endfunction
nnoremap <leader>t <Cmd>call <SID>toggle_term()<CR>
tnoremap <Esc><Esc> <C-w>N

" Run the current file
let s:runners = #{
      \ python: 'python3 %s',
      \ javascript: 'node %s',
      \ typescript: 'npx tsx %s',
      \ java: 'java %s',
      \ c: 'cc -Wall -g %s -o /tmp/vim_run && /tmp/vim_run',
      \ sh: 'bash %s',
      \ }
function! s:run_file() abort
  if !has_key(s:runners, &filetype)
    echohl WarningMsg | echo 'No runner for filetype: ' .. &filetype | echohl None | return
  endif
  silent write
  let cmd = printf(s:runners[&filetype], shellescape(expand('%:p')))
  execute 'botright terminal ++rows=12 ++shell ' .. cmd
endfunction
nnoremap <leader>r <Cmd>call <SID>run_file()<CR>

" Markdown preview with glow
function! s:glow() abort
  if &modified | silent write | endif
  execute 'tab terminal ++close glow -p -w ' .. (&columns - 4) .. ' ' .. shellescape(expand('%:p'))
endfunction
command! Glow call s:glow()
autocmd user_config FileType markdown nnoremap <buffer> <leader>mp <Cmd>Glow<CR>

" ---------------------------------------------------------------- General keymaps
" Window navigation (from your old vimrc)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Buffers
nnoremap <S-h> <Cmd>bprevious<CR>
nnoremap <S-l> <Cmd>bnext<CR>
nnoremap <leader>bd <Cmd>bp<Bar>bd #<CR>
" Save / quit
nnoremap <C-s> <Cmd>w<CR>
inoremap <C-s> <Esc><Cmd>w<CR>
nnoremap <leader>qq <Cmd>qa<CR>
" Clear search highlight
nnoremap <leader>n <Cmd>nohlsearch<CR>
" Keep selection when indenting; move selected lines
xnoremap < <gv
xnoremap > >gv
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
" Toggle fold (moved from <space>, which is now leader)
nnoremap <leader>z za

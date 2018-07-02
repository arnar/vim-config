" .vimrc    Arnar Birgisson

" Some bugs in vim surface when the locale is wrong
let $LC_NUMERIC='C'

" Plugin management by vim-plug: https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'             " Sensible defaults
Plug 'tpope/vim-fugitive'             " Git
Plug 'tpope/vim-surround'             " Surround w textobjects
Plug 'tpope/vim-repeat'               " Repeat . works for other things
Plug 'tpope/vim-speeddating'          " C-A/C-X work on dates
Plug 'junegunn/vim-easy-align'        " Align in textobjects
Plug 'tomtom/tcomment_vim'            " Commenting in text objects
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'rbgrouleff/bclose.vim'          " Close buffer without closing window
Plug 'arnar/vim-matchopen'            " Highlight the current opening delimiter
Plug 'vim-scripts/Gundo'              " Graphical undo tree
Plug 'rstacruz/sparkup'               " Sparkup converst css selectors into dom tag tree
Plug 'bling/vim-airline'              " Statusline
Plug 'mhinz/vim-signify'              " Gutter diff marks for various VCSs
Plug 'christoomey/vim-tmux-navigator' " Ctrl-movement moves between tmux panes also
Plug 'nathangrigg/vim-beancount'      " Beancount lang plugin
Plug 'w0rp/ale'                       " Async lint engine
Plug 'sheerun/vim-polyglot'           " One pack of language plugins
Plug 'tommcdo/vim-exchange'           " Exchange two ranges

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

Plug '/Users/arnarb/homebrew/opt/fzf' " TODO: This works only on my mac
Plug 'junegunn/fzf.vim'               " Fuzzy finder (install fzf cmd line tool)

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" Experimental
" Plug 'terryma/vim-multiple-cursors'


"Plug 'sjl/splice.vim'   " Three way merges  (instead use http://vim.wikia.com/wiki/A_better_Vimdiff_Git_mergetool)
"
"For Rust  (maybe replaced by polyglot)
" Plug 'rust-lang/rust.vim'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()

" Google stuff
if filereadable("/usr/share/vim/google/google.vim")
  source /usr/share/vim/google/google.vim
endif
if exists("Glug")
  Glug codefmt gofmt_executable=goimports
  Glug codefmt-google auto_filetypes+=go
endif


" Global settings
set relativenumber
set nobk wb               " No backup files, except temporarily when overwriting
set go+=c                 " Use text prompts instead of modal gui dialogs
set completeopt+=longest  " Insert only longest prefix
set nolazyredraw
set showmatch mat=2       " Briefly highlight matching delimiter on typing
set scrolloff=5
set noeb novb t_vb=       " No bells!

let mapleader=","
let g:mapleader=","
let maplocalleader=",,"

" See if this is handled by polyglot, delete if so
"set wildignore+=*.o,*.obj,.git,*.pyc,*.log,*.aux,*.out,*.bbl,*.blg,*.hi,node_modules,*.class

" Backspace wraps to next line
set backspace=2 whichwrap+=<,>,[,]

" Shortcut to get here (vimrc)
nmap <Leader>v :e ~/.vim/vimrc<cr>

" Window navigation
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
set wmh=0

" Jump to the last known position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \ endif

if has("gui_running")
   colors ir_black256_arnar
   if has("gui_macvim") 
       set gfn=Sauce\ Code\ Powerline\ Light:h11
       set guioptions-=T    " No scroll- or toolbars
       set guioptions-=l
       set guioptions-=L
       set guioptions-=r
       set guioptions-=R
   else
       set gfn=Source\ Code\ Pro\ for\ Powerline\ Medium\ 10
       set guioptions=c
   end
else
    set t_Co=256
    colors ir_black256_arnar
endif

" Execute line/selection as Python and replace with output
nmap gp :.!python<CR>
vmap gp :!python<CR>

" Plugin specific settings
if has("gui_running")
  let g:airline_powerline_fonts=1
else
  let g:airline_powerline_fonts=0
  let g:airline_left_sep='►'
  let g:airline_right_sep='◄'
endif

let g:deoplete#enable_at_startup = 1

let g:signify_vcs_list = [ 'git', 'hg', 'perforce' ]

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'python': ['pyls'],
    \ }

" Neosnippet/deoplete key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Handy function to search previous lines for indent levels and
" use those instead of multiples of shiftwidth
function! DedentToPrevious()
python3 << EOF
import vim

tabsize = int(vim.eval("&ts"))
l = vim.current.line
rest = l.lstrip()
indent = l[:len(l)-len(rest)]

cline,ccolumn = vim.current.window.cursor

if indent != "" or ccolumn > 0:
    if indent == "":
        cur_size = ccolumn
    else:
        cur_size = len(indent.replace("\t", " "*tabsize))
    idx = cline-2

    while idx >= 0:
        ll = vim.current.buffer[idx]
        newindent = ll[:len(ll)-len(ll.lstrip())]
        if len(newindent.replace("\t", " "*tabsize)) < cur_size:
            vim.current.line = newindent+rest
            break
        idx -= 1

EOF
endfunction
imap <C-d> <left><right><C-o>:call DedentToPrevious()<cr>

" vim:set ft=vim et sw=2:

" .vimrc    Arnar Birgisson

" Some bugs in vim surface when the locale is wrong
let $LC_NUMERIC='C'

" Plugin management by vim-plug: https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-markdown'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'rbgrouleff/bclose.vim'
Plug 'arnar/vim-matchopen'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/neoyank.vim'
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite-outline'
Plug 'tsukkee/unite-tag'
Plug 'vim-scripts/Gundo'
Plug 'rstacruz/sparkup'
Plug 'bling/vim-airline'
Plug 'vimoutliner/vimoutliner'
call plug#end()

" Google stuff
if filereadable("/usr/share/vim/google/google.vim")
  source /usr/share/vim/google/google.vim
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

set wildignore+=*.o,*.obj,.git,*.pyc,*.log,*.aux,*.out,*.bbl,*.blg,*.hi,node_modules,*.class

" Backspace wraps to next line
set backspace=2 whichwrap+=<,>,[,]

" Shortcut to get here (vimrc) and reload
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
   color wombat
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

" Menus for console mode (from help text).
if !has("gui_running")
    source $VIMRUNTIME/menu.vim
    set wildmenu
    set cpo-=<
    set wcm=<C-Z>
    map <Leader>m :emenu <C-Z>
    set t_Co=256
    colors ir_black256_arnar
endif

" Execute line/selection as Python and replace with output
nmap gp :.!python<CR>
vmap gp :!python<CR>

"Move line/selection with ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Settings for Unite
let g:unite_prompt='» '
call unite#custom#profile('ignorecase','context.ignorecase',1)
call unite#custom#profile('ignorecase','context.smartcase',1)

if executable('ag')
  let s:ag_opts =  [
    \ '--vimgrep', '--smart-case', '--skip-vcs-ignores', '--hidden',
    \ '--ignore', '.git', '--ignore', 'node_modules'
    \ ]
  let g:unite_source_rec_async_command =
    \ ['ag', '--follow', '-g', ''] + s:ag_opts
  let g:unite_source_grep_command='ag'
  let g:unite_source_grep_default_opts=join(s:ag_opts)
  let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
  let g:unite_source_rec_async_command = ['ack', '-f', '--nofilter' ]
  let g:unite_source_grep_command='ack'
  let g:unite_source_grep_default_opts='--no-heading --no-color -a -C4'
  let g:unite_source_grep_recursive_opt=''
endif

call unite#custom#profile('default', 'context', {
  \   'safe': 0,
  \   'start_insert': 1,
  \   'short_source_names': 1,
  \   'update_time': 500,
  \   'direction': 'topleft',
  \   'winwidth': 40,
  \   'winheight': 15,
  \   'no_auto_resize': 1,
  \   'vertical_preview': 1,
  \   'cursor_line_time': '0.10',
  \   'hide_icon': 0,
  \   'candidate-icon': ' ',
  \   'marked_icon': '✓',
  \   'prompt' : '» '
  \ })

call unite#custom#profile('navigate,source/grep', 'context', {
	\   'silent': 1,
	\   'start_insert': 0,
	\   'winheight': 20,
	\   'no_quit': 1,
	\   'keep_focus': 1,
	\   'direction': 'botright',
	\   'prompt_direction': 'top',
	\ })

call unite#custom#source(
  \ 'buffer,file_rec,file_rec/async,file_rec/git,neomru/file',
	\ 'matchers',
  \ ['converter_relative_word', 'matcher_fuzzy'])

call unite#custom#source(
  \ 'file_rec,file_rec/async,file_rec/git,file_mru,neomru/file',
	\ 'converters',
  \ ['converter_file_directory'])

call unite#filters#sorter_default#use(['sorter_rank'])

nnoremap <silent> <leader>f :<C-u>Unite file_rec/async<cr>
nnoremap <silent> <leader>r :<C-u>Unite buffer file_mru bookmark<cr>
nnoremap <silent> <leader>g :<C-u>Unite grep:.<cr>
nnoremap <silent> <leader>u :<C-u>Unite source<cr>
nnoremap <silent> <leader>l :<C-u>Unite line<cr>
nnoremap <silent> <leader>t :<C-u>UniteWithCursorWord tag<cr>
nnoremap <silent> <leader>y :<C-u>Unite -buffer-name=register register history/yank<cr>
nnoremap <silent> <leader>o :<C-u>Unite outline<cr>
nnoremap <silent> <leader>j
        \ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
        \ -no-short-source-names jump_point file_point buffer file_mru
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec/async'`
        \ file/new<cr>

" Powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" Make sure to use the exuberant ctags on mac (installed with brew)
if has("gui_macvim")
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
end

" Go
if exists("Glug")
  Glug codefmt gofmt_executable=goimports
  Glug codefmt-google auto_filetypes+=go
endif
au FileType go setlocal ts=2

" Handy function to search previous lines for indent levels and
" use those instead of multiples of shiftwidth
function! DedentToPrevious()
python << EOF
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

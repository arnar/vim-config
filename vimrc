" .vimrc   Arnar Birgisson

" Some bugs in vim surface when the locale is wrong
let $LC_NUMERIC='C'

" Load stuff via pathogen
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Some global settings
set nocompatible
set autoindent
if has("vms")
    set nobackup
else
    set backup
endif
set history=700
set ruler
set relativenumber
set showcmd
set incsearch
set hlsearch
set nobk
set wb
set sw=2 ts=2 et
set go+=c
set completeopt+=longest
set nolazyredraw
set showmatch mat=2
set switchbuf=usetab
set comments=sl:/*,mb:\ *\ ,elx:\ */
set scrolloff=5
set background=dark
set noeb vb t_vb=   "engar bjöllur takk
set grepprg=grep\ -nH\ $*
set listchars=eol:$,tab:»·,trail:·
set laststatus=2
" statusline=%t%=%#warningmsg#%{SyntasticStatuslineFlag()}%*\ %{fugitive#statusline()}\ (%{strlen(&ft)?&ft:'?'},%{&fenc},%{&ff})\ \ %-9.(%l,%c%V%)\ \ %<%P
set path+=**
let snips_author = 'Arnar Birgisson'
let mapleader=","
let g:mapleader=","
let maplocalleader="\\"

" wrappa með cursor og backspace í næstu línur
set backspace=2 whichwrap+=<,>,[,]

" Syntax highlighting and smart indents
syntax on
filetype plugin indent on

" Jump to the last known position
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \ endif

" Shortcuts to get here and reload
nmap <Leader>s :so ~/.vim/vimrc<cr>
nmap <Leader>v :e ~/.vim/vimrc<cr>

" Window navigation
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
set wmh=0

" Ctrl-] is very inconvenient on Icelandic kbd
map <C-Enter> <C-]>

" In insert mode, C-Enter inserts two lines, puts the cursor between them and
" indents. Handy with delimitMate and for html/xml tags.
" imap <C-Enter> <CR><CR><C-o>k<Tab>
" DelimitMate is annoying, let's disable it for now and see if matchopen does
" it's job (also disable the built-in matchparen plugin):
let g:loaded_delimitMate = 1
let loaded_matchparen = 1

" reselect visual block after in/dedent
" Commenting out to get used to . instead
"vnoremap < <gv
"vnoremap > >gv

" Let . in visual mode repeat for each selected line
vnoremap . :normal .<CR>

" Persistent undo
try
    set undodir=~/.vim/undodir
catch
endtry

if has("gui_running")
   "let psc_style='warm'
   "color ps_color
   "color desert
   "color HHazure
   "color dante_ab
   color wombat
   "color mustang
   "color peaksea
   "color sorcerer
   "color ir_black
   if has("gui_macvim") 
       set gfn=Source\ Code\ Pro\ Light\ for\ Powerline:h11
       "set lines=47
       "set columns=100
       "color sorcerer " also nice: ir_black
       " Slaufa-f til að vekja find (ala slaufa-T í textmate)
       " opt-slaufa-f sama nema í nýjum tab
       " path uppf. til að leita recursive í cwd
       nmap <D-f> :find 
       nmap <M-D-f> :tabfind 
       let g:LatexBox_viewer = 'open'
       set guioptions-=T    " No scroll- or toolbars
       set guioptions-=l
       set guioptions-=L
       set guioptions-=r
       set guioptions-=R
   else
       "set gfn=Droid\ Sans\ Mono\ 10
       set gfn=Ubuntu\ Mono\ 12
       set guioptions=c
   end
endif

" Menus for console mode (from help text).
if !has("gui_running")
    source $VIMRUNTIME/menu.vim
    set wildmenu
    set cpo-=<
    set wcm=<C-Z>
    map <Leader>m :emenu <C-Z>
    set t_Co=256 "við erum alltaf í 256 lita terminal
    colors ir_black
endif

" Python filter
nmap gp :.!python<CR>
vmap gp :!python<CR>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" Mappings that open a sidebar / scratch window
nmap <leader>d :NERDTreeToggle<CR>
nmap <leader>u :GundoToggle<CR>

" Git
nmap <leader>gs :Gstatus<CR>
nmap <leader>gc :Gcommit<CR>
nmap <leader>gd :Gdiff<CR>
nmap <leader>gp :Git push<CR>
nmap <leader>gnr :Git svn rebase<CR>
nmap <leader>gnd :Git svn dcommit<CR>

" Tags
nmap <leader>t :TagbarOpenAutoClose<CR>

" Tabularize (alignment plugin)
nmap <leader>= :Tabularize<CR>

" Close buffers without messing up windows
nmap <leader>bd :Kwbd<CR>

" In visual mode, use * and # to search for selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Close the quickfix window on enter
au BufNewFile,BufRead quickfix nnoremap <silent> <buffer> <CR> <CR>:ccl<CR>

" Settings for Command-T
set wildignore+=*.o,*.obj,.git,*.pyc,*.log,*.aux,*.out,*.bbl,*.blg,*.hi,node_modules
noremap <leader>j :CommandT<CR>
augroup CommandTExtension
  autocmd!
  autocmd FocusGained * CommandTFlush
  autocmd BufWritePost * CommandTFlush
augroup END

" Settings for NERDTree
let NERDTreeIgnore=['\.pyc$', '\.egg-info$[[dir]]', '\~$']

" Settings for indent-guides
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_color_change_percent = 5

" Powerline status line
let g:Powerline_symbols = 'fancy'

" Ubuntu calls ack ack-grep
if !has("gui_macvim")
    let g:ackprg="ack-grep -H --nocolor --nogroup"
else
    let g:ackprg="ack -H --nocolor --nogroup"
end
noremap <leader>a :Ack! 

" Make sure to use the exuberant ctags on mac (installed with brew)
if has("gui_macvim")
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
end

let g:tagbar_type_tex = {
    \ 'ctagstype' : 'latex',
    \ 'kinds'     : [
        \ 's:sections',
        \ 'g:graphics',
        \ 'l:labels',
        \ 'r:refs:1',
        \ 'p:pagerefs:1'
    \ ],
    \ 'sort'    : 0
\ }

" TeX/LaTeX specifics for latex-box
au BufNewFile,BufRead  *.tex set ft=tex
au FileType tex vmap <buffer> ,wc <Plug>LatexWrapSelection
au FileType tex vmap <buffer> ,we <Plug>LatexWrapSelectionEnv
au FileType tex nmap <buffer> ,ee <Plug>LatexChangeEnv
au FileType tex nmap <buffer> <silent> <leader>t :LatexTOC<CR>
"au FileType tex set background=light
"au FileType tex colorscheme solarized
au FileType tex NoMatchLastOpen
let g:LatexBox_latexmk_options = '-pvc'

" Various file-type specifics
au BufNewFile,BufRead  svn-commit.* setf svn
au BufNewFile,BufRead  *.cs set syn=html
au BufNewFile,BufRead  *.g  set syn=antlr3
au BufNewFile,BufRead   *.tmpl set enc=utf8

" Haskell
au Bufenter *.hs compiler ghc
let g:haddock_browser = "open"
let g:haddock_browser_callformat = "%s %s"

" Charset recognition for Python files
" 2010-11-24: Commenting out since something is missing...
"let s:pep263='coding[:=]\s*\([-A-Za-z0-9_]\+\)'
"au BufReadPost *.py call ReloadWhenCharsetSet(1, s:pep263)
"au BufReadPost *.py call ReloadWhenCharsetSet(2, s:pep263)
"au BufReadPost *.py syntax on
au BufReadPost *.py set ts=4 sw=4 et

" Interaction with IPython, see ftplugin/python/ipy.vim
let g:ipy_perform_mappings = 0
"source $HOME/.vim/ipy.vim
au FileType python map  <buffer> <silent> <localleader>d :py get_doc_buffer()<CR>
au FileType python map  <buffer> <silent> <localleader>is :py update_subchannel_msgs(); echo("vim-ipython shell updated",'Operator')<CR>
au FileType python nmap <buffer> <silent> <localleader>id vis<C-s>
au FileType python map  <buffer> <silent> <C-s> :python run_this_line()<CR>
au FileType python imap <buffer> <silent> <C-s> <C-O>:python run_this_line()<CR>
au FileType python map  <silent> <M-s> :python dedent_run_this_line()<CR>
au FileType python vmap <buffer> <silent> <C-s> :python run_these_lines()<CR>
au FileType python vmap <buffer> <silent> <M-s> :python dedent_run_these_lines()<CR>

" Markdown behaviour
augroup markdown
    au! BufRead,BufNewFile *.markdown   setfiletype mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END

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

" Tab names, from http://blog.golden-ratio.net/2008/08/19/using-tabs-in-vim/
function! GuiTabLabel()
    " add the tab number
    let label = '['.tabpagenr()
 
    " modified since the last save?
    let buflist = tabpagebuflist(v:lnum)
    for bufnr in buflist
        if getbufvar(bufnr, '&modified')
            let label .= '*'
            break
        endif
    endfor
 
    " count number of open windows in the tab
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
        let label .= ', '.wincount
    endif
    let label .= '] '
 
    " add the file name without path information
    let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
    let label .= fnamemodify(n, ':t')
 
    return label
endfunction
set guitablabel=%{GuiTabLabel()}

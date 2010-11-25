" .vimrc   Arnar Birgisson

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
set showcmd
set incsearch
set hlsearch
set nobk
set wb
set sw=4
set ts=4
set et
set nolazyredraw
set showmatch mat=2
set switchbuf=usetab
set comments=sl:/*,mb:\ *\ ,elx:\ */
set scrolloff=5
set background=dark
set noeb vb t_vb=   "engar bjöllur takk
set grepprg=grep\ -nH\ $*
set listchars=eol:$,tab:»·,trail:·
set laststatus=2 statusline=%t%=%{fugitive#statusline()}\ (%{strlen(&ft)?&ft:'?'},%{&fenc},%{&ff})\ \ %-9.(%l,%c%V%)\ \ %<%P
set path+=**
let snips_author = 'Arnar Birgisson'
let mapleader=","
let g:mapleader=","

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

" Tab and window navigation
nmap <C-H> :tabprevious<CR>
nmap <C-L> :tabnext<CR>
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
set wmh=0

" reselect visual block after in/dedent
vnoremap < <gv
vnoremap > >gv

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
   "color wombat
   color mustang
   "color peaksea
   if has("gui_macvim") 
       set gfn=Andale\ Mono:h12.00
       set lines=47
       set columns=100
       color ir_black
        " Slaufa-f til að vekja find (ala slaufa-T í textmate)
        " opt-slaufa-f sama nema í nýjum tab
        " path uppf. til að leita recursive í cwd
        nmap <D-f> :find 
        nmap <M-D-f> :tabfind 
   else
       set gfn=Monospace\ 9
       set go-=Tm
   end
endif

" Menus for console mode (from help text).
if !has("gui_running")
    source $VIMRUNTIME/menu.vim
    set wildmenu
    set cpo-=<
    set wcm=<C-Z>
    map <Leader>m :emenu <C-Z>
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

" Use the F-keys wisely
map <F4> :NERDTree<CR>
map <F5> :GundoToggle<CR>

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

" Settings for Command-T
set wildignore+=*.o,*.obj,.git,*.pyc
noremap <leader>j :CommandT<CR>

" TeX/LaTeX specifics for LaTeX suite
au BufNewFile,BufRead  *.tex set ft=tex
let g:Tex_SmartQuoteOpen = "\"`"
let g:Tex_SmartQuoteClose = "\"'"
" let g:Tex_Menus = 0
let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_ViewRule_pdf = "/usr/bin/open"
let g:Tex_MenuPrefix = 'TeX.'
let g:Tex_UseUtfMenus = 1
let g:Tex_MultipleCompileFormats = "dvi,pdf"
let g:Tex_IgnoredWarnings =
\"Underfull\n".
\"Overfull\n".
\"specifier changed to\n".
\"You have requested\n".
\"Missing number, treated as zero.\n".
\"There were undefined references\n".
\"Citation %.%# undefined\n".
\"LaTeX Font Warning\n".
\"Reference %.%# undefined\n".
\"Label(s) may have changed".
\"Marginpar on page %.%# moved.\n"
let g:Tex_IgnoreLevel = 11
let g:Imap_FreezeImap = 1

" Various file-type specifics
au BufNewFile,BufRead  svn-commit.* setf svn
au BufNewFile,BufRead  *.cs set syn=html
au BufNewFile,BufRead  *.g  set syn=antlr3
au BufNewFile,BufRead   *.tmpl set enc=utf8
au Bufenter *.hs compiler ghc

" Charset recognition for Python files
" 2010-11-24: Commenting out since something is missing...
"let s:pep263='coding[:=]\s*\([-A-Za-z0-9_]\+\)'
"au BufReadPost *.py call ReloadWhenCharsetSet(1, s:pep263)
"au BufReadPost *.py call ReloadWhenCharsetSet(2, s:pep263)
au BufReadPost *.py syntax on
au BufReadPost *.py set ts=4 sw=4 et

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

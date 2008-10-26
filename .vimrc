" $Id$

" Options
set autoindent		" always set autoindenting on
set autoread		" Automatically read buffers if file changed on disk
set autowrite		" Automatically save before commands like :next and :make
set backspace=2		" allow backspacing over everything in insert mode
"set backup		" keep a backup file
set backupskip=/tmp/*,$TMPDIR/*,*.tmp
set nocompatible	" Use Vim defaults (much better!)
set fileencodings=ucs-bom,utf-8,default,latin1
set nofoldenable
set hidden		" use multiple buffers
set hlsearch		" highlight matches
set ignorecase		" Do case insensitive matching
set incsearch		" Incremental search
set list		" show tabs et al.
set lcs=tab:·\ ,trail:·	" how to show tabs
set nojoinspaces	" \frenchspacing
set nrformats=hex	" drop octal number format
set ruler		" Show the line and column numbers of the cursor 
set rulerformat=%22(%n:%l/%L,%c%V%=%P%)
set scrolloff=3		" always show n lines before and after current linE
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do case-sensitive case sensitive matching
"set statusline=\ %n:%<%f%M%R%W\ %y%a%=%l/%L,%c%V\ %P\ 
set nostartofline	" Do not move to start of line on buffer change etc.
"set textwidth=0		" Don't wrap words by default
set title		" Set xterm title ... to:
nmap _t :set titlestring=vim\ -\ %n:%f\ %(%{Tlist_Get_Tagname_By_Line()}\ %)%(%R%M%W\ %)%y%k<cr>:TlistUpdate<cr>
set titlestring=vim\ -\ %n:%f\ %(%R%M%W\ %)%y%k
"set nottybuiltin term=$TERM " Make vim consult the external termcap entries first
set viminfo='20,\"50,h	" read/write a .viminfo file, don't store more than
			" 50 lines of registers, do not highlight searches

let g:is_posix=1	" sh syntax is POSIX

filetype plugin indent on

" Key bindings
nmap <c-h> :bp<cr>
nmap <c-?> :bp<cr>
nmap <tab> :bn<cr>
imap <c-z> <esc><c-z>
nmap <space> <c-f>
nmap - <c-b>
nmap M :make!<cr><cr>
set pastetoggle=<f11> " turn on/off paste in insert mode
" wurstfinger mode
imap <f1> <esc>
nmap <f12> :set invlist<cr>
imap <f12> <c-o>:set invlist<cr>

nmap <f1>	:b1<cr>
nmap <f2>	:b2<cr>
nmap <f3>	:b3<cr>
nmap <f4>	:b4<cr>
nmap <f5>	:b5<cr>
nmap <f6>	:b6<cr>
nmap <f7>	:b7<cr>
nmap <f8>	:b8<cr>
nmap <f9>	:b9<cr>
nmap <f10>	:b10<cr>
nmap <s-f1>	:b11<cr>
nmap <s-f2>	:b12<cr>
nmap <s-f3>	:b13<cr>
nmap <s-f4>	:b14<cr>
nmap <s-f5>	:b15<cr>
nmap <s-f6>	:b16<cr>
nmap <s-f7>	:b17<cr>
nmap <s-f8>	:b18<cr>
nmap <s-f9>	:b19<cr>
nmap <s-f10>	:b20<cr>

" for imwheel
nmap <s-f11>	:bp<cr>
nmap <s-f12>	:bn<cr>
imap <s-f11>	<c-o>:bp<cr>
imap <s-f12>	<c-o>:bn<cr>

" swap C arguments
nmap __ :s/\([(,]\)\(.\{-0,\}\)\%#\(, *\)\(.\{-0,\}\)\([),]\)/\1\4\3\2\5/<cr>

" highlights
hi NonText cterm=NONE

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm is a color terminal
if &term =~ "xterm*"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Screen has a title bar
if &term =~ "screen*"
  set t_ts=]0;
  set t_fs=
endif

" Vim5 comes with syntaxhighlighting.
if has("syntax")
  let mysyntaxfile = "~/.vim/syntax.vim"
  syntax on
endif

if has("autocmd")

au BufNewFile,BufRead *.swml  setf wml

" HTML (.shtml for server side)
"augroup html
"  au!
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ä &auml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ä &Auml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ö &ouml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ö &Ouml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ü &uuml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ü &Uuml;
"  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ß &szlig;
"augroup END

" Set some sensible defaults for editing C-files
augroup cprog
  " Remove all cprog autocommands
  au!
  " When starting to edit a file:
  "   For *.c and *.h files set formatting of comments and set C-indenting on.
  "   For other files switch it off.
  "   Don't change the order, it's important that the line with * comes first.
  autocmd BufRead *       set formatoptions=tcql nocindent comments&
  autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

endif " has ("autocmd")

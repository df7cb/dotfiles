" $Id$

" Options
set autoindent		" always set autoindenting on
set autowrite		" Automatically save before commands like :next and :make
set backspace=2		" allow backspacing over everything in insert mode
set backup		" keep a backup file
set nocompatible	" Use Vim defaults (much better!)
set hidden		" use multiple buffers
set hlsearch		" highlight matches
set ignorecase		" Do case insensitive matching
set incsearch		" Incremental search
set list		" show tabs et al.
set lcs=tab:·\ ,trail:·	" how to show tabs
set nojoinspaces	" \frenchspacing
set nrformats=hex	" drop octal number format
set ruler		" Show the line and column numbers of the cursor 
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do case-sensitive case sensitive matching
set nostartofline	" Do not move to start of line on buffer change etc.
set textwidth=0		" Don't wrap words by default
set nottybuiltin term=$TERM " Make vim consult the external termcap entries first
set viminfo='20,\"50,h	" read/write a .viminfo file, don't store more than
			" 50 lines of registers, do not highlight searches

filetype plugin on

" Key bindings
nmap <c-h> :bp<cr>
nmap <tab> :bn<cr>
imap <c-z> <esc><c-z>
nmap <space> <c-f>
nmap - <c-b>
nmap M :make!<cr><cr>
nmap b <c-b>

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

" Vim5 comes with syntaxhighlighting.
if has("syntax")
  let mysyntaxfile = "~/.vim/syntax.vim"
  syntax on
endif

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIM/doc/help.txt.gz

if has("autocmd")

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

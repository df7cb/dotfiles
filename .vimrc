" $Id$
" Configuration file for gvim
" Written for Debian GNU/Linux by W.Akkerman <wakkerma@debian.org>
" Some modifications by J.H.M. Dassen <jdassen@wi.LeidenUniv.nl>


" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults (much better!)
" use Q for formatting, not ex-mode:
map Q gq
set backspace=2		" allow backspacing over everything in insert mode

" Now we set some defaults for the editor
set autoindent		" always set autoindenting on
set textwidth=0		" Don't wrap words by default
set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" Make vim consult the external termcap entries first, so we get all of
" Debian's termcap settings correct. This will be fixed upstream in 5.4
set nottybuiltin term=$TERM

" We know xterm is a color terminal
if &term =~ "xterm*"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Vim5 comes with syntaxhighlighting.
if has("syntax")
  syntax on
endif

" Debian uses compressed helpfiles. We must inform vim that the main
" helpfiles is compressed. Other helpfiles are stated in the tags-file.
" set helpfile=$VIM/doc/help.txt.gz

if has("autocmd")

" HTML (.shtml for server side)
augroup html
  au!
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ä &auml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ä &Auml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ö &ouml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ö &Ouml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ü &uuml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap Ü &Uuml;
  au BufNewFile,BufRead *.html,*.htm,*.shtml  imap ß &szlig;
augroup END

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

" Also, support editing of gzip-compressed files. DO NOT REMOVE THIS!
" This is also used when loading the compressed helpfiles.
augroup gzip
  " Remove all gzip autocommands
  au!

  " Enable editing of gzipped files
  "	  read:	set binary mode before reading the file
  "		uncompress text in buffer after reading
  "	 write:	compress file after writing
  "	append:	uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre	*.gz set bin
  autocmd BufReadPre,FileReadPre	*.gz let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost	*.gz '[,']!gunzip
  autocmd BufReadPost,FileReadPost	*.gz set nobin
  autocmd BufReadPost,FileReadPost	*.gz let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost	*.gz execute ":doautocmd BufReadPost " . %:r

  autocmd BufWritePost,FileWritePost	*.gz !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost	*.gz !gzip <afile>:r

  autocmd FileAppendPre			*.gz !gunzip <afile>
  autocmd FileAppendPre			*.gz !mv <afile>:r <afile>
  autocmd FileAppendPost		*.gz !mv <afile> <afile>:r
  autocmd FileAppendPost		*.gz !gzip <afile>:r
augroup END

augroup bzip2
  " Remove all bzip2 autocommands
  au!

  " Enable editing of bzipped files
  "       read: set binary mode before reading the file
  "             uncompress text in buffer after reading
  "      write: compress file after writing
  "     append: uncompress file, append, compress file
  autocmd BufReadPre,FileReadPre        *.bz2 set bin
  autocmd BufReadPre,FileReadPre        *.bz2 let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=2|'[,']!bunzip2
  autocmd BufReadPost,FileReadPost      *.bz2 set cmdheight=1 nobin|execute ":doautocmd BufReadPost " . %:r
  autocmd BufReadPost,FileReadPost      *.bz2 let &ch = ch_save|unlet ch_save

  autocmd BufWritePost,FileWritePost    *.bz2 !mv <afile> <afile>:r
  autocmd BufWritePost,FileWritePost    *.bz2 !bzip2 <afile>:r

  autocmd FileAppendPre                 *.bz2 !bunzip2 <afile>
  autocmd FileAppendPre                 *.bz2 !mv <afile>:r <afile>
  autocmd FileAppendPost                *.bz2 !mv <afile> <afile>:r
  autocmd FileAppendPost                *.bz2 !bzip2 -9 --repetitive-best <afile>:r
augroup END

endif " has ("autocmd")

" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ruler		" Show the line and column numbers of the cursor 
set ignorecase		" Do case insensitive matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make

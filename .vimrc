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
set isfname-==		" make foo=file^X^F work
set list		" show tabs et al.
set lcs=tab:·\ ,trail:·	" how to show tabs
set mouse=		" no mouse please
set nojoinspaces	" \frenchspacing
set nrformats=hex	" drop octal number format
set ruler		" Show the line and column numbers of the cursor 
set rulerformat=%22(%n:%l/%L,%c%V%=%P%)
set scrolloff=3		" always show n lines before and after current line
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do case-sensitive case sensitive matching
if has("spell")
  set spell spelllang=en_us,de_de spellfile=~/.vim/spell/all.utf-8.add,~/.vim/spell/de.utf-8.add,~/.vim/spell/en.utf-8.add
endif
"set statusline=\ %n:%<%f%M%R%W\ %y%a%=%l/%L,%c%V\ %P\ 
set nostartofline	" Do not move to start of line on buffer change etc.
"set textwidth=0		" Don't wrap words by default
set tags^=./.git/tags;	" Read ctags from .git dir
set title		" Set xterm title ... to:
nmap _t :set titlestring=vim\ -\ %n:%f\ %(%{Tlist_Get_Tagname_By_Line()}\ %)%(%R%M%W\ %)%y%k<cr>:TlistUpdate<cr>
set titlestring=vim\ -\ %n:%f\ %(%R%M%W\ %)%y%k
"set nottybuiltin term=$TERM " Make vim consult the external termcap entries first
"set viminfo='20,\"50,/10	" read/write a .viminfo file, don't store more than
			" 50 lines of registers, do not highlight searches
set virtualedit=block   " allow cursor movement on blank space in block mode
set wildmode=longest,list:longest,list:full " filename tab completion

" don't let netrw mess with directories (interferes with "set hidden" when directories are listed on the command line)
let loaded_netrwPlugin = 1

" load .vimrc file from project directories using
" http://www.vim.org/scripts/script.php?script_id=441
let g:localvimrc_name=".vimrc"
let g:localvimrc_blacklist="/home/[[:alnum:]]*/.vimrc"
let g:localvimrc_persistent=2 " Store and restore all decisions
let g:localvimrc_persistence_file=expand('$HOME') . "/.vim/localvimrc_persistent"

let g:is_posix=1	" sh syntax is POSIX

filetype plugin indent on

" Key bindings
nmap <c-h> :bp<cr>
nmap <c-?> :bp<cr>
nmap <tab> :bn<cr>
imap <c-l> <c-o><c-l>
imap <c-z> <esc><c-z>
nmap <space> <c-f>
nmap - <c-b>
nmap M :make!<cr><cr>

" wurstfinger mode
imap <f1> <esc>
nmap <f8>       :set nospell<cr>
imap <f8>  <c-o>:set nospell<cr>
nmap <f9>       :set spell spelllang=de_de,all spellfile=~/.vim/spell/de.utf-8.add,~/.vim/spell/all.utf-8.add<cr>
imap <f9>  <c-o>:set spell spelllang=de_de,all spellfile=~/.vim/spell/de.utf-8.add,~/.vim/spell/all.utf-8.add<cr>
nmap <f10>      :set spell spelllang=en_us,all spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/all.utf-8.add<cr>
imap <f10> <c-o>:set spell spelllang=en_us,all spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/all.utf-8.add<cr>
set pastetoggle=<f11> " turn on/off paste in insert mode
nmap <f12>      :set invlist<cr>:execute "set signcolumn=" .. (&signcolumn == "auto" ? "no" : "auto")<cr>
imap <f12> <c-o>:set invlist<cr><c-o>:execute "set signcolumn=" .. (&signcolumn == "auto" ? "no" : "auto")<cr>

" swap C arguments
nmap __ :s/\([(,]\)\(.\{-0,\}\)\%#\(, *\)\(.\{-0,\}\)\([),]\)/\1\4\3\2\5/<cr>

" highlights
hi NonText cterm=NONE
" make search wrap more visible
hi WarningMsg ctermfg=white ctermbg=red guifg=White guibg=Red gui=None

" gitgutter
highlight GitGutterAdd    guibg=#009900 ctermbg=2
highlight GitGutterChange guibg=#bbbb00 ctermbg=3
highlight GitGutterDelete guibg=#ff2222 ctermbg=1

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

" psql \e and \ef
autocmd BufRead psql.edit.* setf sql

" Force ft=debchangelog even with conflict markers in the file
autocmd BufRead debian/changelog set ft=debchangelog

" Prevent accidental editing of patch .orig files
autocmd BufRead *.orig set readonly

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

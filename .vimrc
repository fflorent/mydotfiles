source /etc/vim/vimrc
source /home/florent/.vim/plugin/matchit.vim
set autoindent
set copyindent
set mouse=a
set ignorecase
set smartcase
set hlsearch
set incsearch
set clipboard=unnamed
let mapleader=','


"""""""""""""""""""""""""""""""""""""""""""
" Vundle
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'walm/jshint.vim'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-surround'
Plugin 'kchmck/vim-coffee-script'
Plugin 'jaxbot/github-issues.vim'
Plugin 'marijnh/tern_for_vim'
Plugin 'fugitive.vim'

filetype plugin indent on    " required

vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
" map <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
map <C-Left> b
map <C-Right> e

inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"

nmap <Backspace> X
map <F10> <NOP>
let tern_request_timeout=10
execute pathogen#infect()

"Unite
nnoremap <C-P> :Unite -start-insert file_rec/async<cr>
nnoremap <space>/ :Unite grep:.<cr>
let g:unite_source_history_yank_enable = 1
nnoremap <space>y :Unite history/yank<cr>

"highlight SpecialKey ctermfg=DarkGray ctermbg=yellow


" Cursor color
if !has("gui_running")
	" À défaut de pouvoir changer la forme du curseur
	" en fonction du mode de Vim, on peut changer sa couleur
	" en passant par des fonctions de contrôle.
	if &term =~ "rxvt-unicode"
		" From ECMA-48:
		"   OSC - OPERATING SYSTEM COMMAND:
		"     Representation: 09/13 or ESC 05/13 (this is \033] here)
		"     OSC is used as the opening delimiter of a control string for operating system use.
		"     The command string following may consist of a sequence of bit combinations
		"     in the range 00/08 to 00/13 and 02/00 to 07/14.
		"     The control string is closed by the terminating delimiter STRING TERMINATOR (ST).
		"     The interpretation of the command string depends on the relevant operating system.
		" From :h t_SI:
		"   Added by Vim (there are no standard codes for these):
		"     t_SI start insert mode (bar cursor shape)
		"     t_EI end insert mode (block cursor shape)
		let &t_SI = "\033]12;red\007"
		let &t_EI = "\033]12;green\007"

		:silent !echo -ne "\033]12;green\007"
		autocmd VimLeave * :silent :!echo -ne "\033]12;green\007"
	endif
	" screen rajoute une couche qu'il faut percer.
	if &term =~ "screen"
		" From man screen:
		"   Virtual Terminal -> Control Sequences:
		"     ESC P  (A)  Device Control String
		"                 Outputs a string directly to the host
		"                 terminal without interpretation.
		"     ESC \  (A)  String Terminator
		let &t_SI = "\033P\033]12;red\007\033\\"
		let &t_EI = "\033P\033]12;green\007\033\\"

		:silent !echo -ne "\033P\033]12;green\007\033\\"
		autocmd VimLeave * :silent :!echo -ne "\033P\033]12;green\007\033\\"
	endif
endif

" Cursor line
if has("gui_running")
	hi CursorLine cterm=NONE ctermbg=lightgrey
	set cursorline
endif

" autocmd VimEnter * silent !konsoleprofile UseCustomCursorColor=1
" Entering insertion mode
" let &t_SI = "\<Esc>]50;BlinkingCursorEnabled=1;CursorShape=1\x7"
" Leaving insertion mode
" let &t_EI = "\<Esc>]50;BlinkingCursorEnabled=0;CursorShape=0\x7"
" set color when entering in vim
" silent !konsoleprofile CustomCursorColor=red
" when leaving vim, reset the konsole profile
"autocmd VimLeave * silent !konsoleprofile CustomCursorColor=black;BlinkingCursorEnabled=0

"  move text and rehighlight -- vim tip_id=224
vnoremap > ><CR>gv
vnoremap < <<CR>gv
" Gundo
nnoremap <F5> :GundoToggle<CR>
" undo options
set undofile

"JSHint
nnoremap <F6> :w<CR>:JSHint<CR>

" Firebug specific
augroup code_style
	au!
	" default : 2 space for indenting
	set expandtab
	set shiftwidth=2
	set softtabstop=2
	autocmd BufRead,BufNewFile ~/javascript/firebug/* call SetFirebugOptions()
	autocmd BufRead,BufNewFile ~/javascript/tracing-console/* call SetFirebugOptions()
	autocmd BufRead,BufNewFile ~/CV/* call SetCVOptions()
	autocmd BufRead,BufNewFile ~/cozy/* call SetFirebugOptions()
	" Firebug.next specific
	autocmd BufRead,BufNewFile ~/javascript/firebug.next/* call SetFirebugNextOptions()
	autocmd BufRead,BufNewFile /media/sdb1/projects/mozilla-central/* call SetFirebugNextOptions()
augroup END

" trailing spaces
augroup trailing_space
	au!
	autocmd BufWritePre * call RemoveTrailingSpace()
augroup END

function RemoveTrailingSpace()
	if search('\s\+$')
		let choice = confirm('Trailing spaces found. Remove them?', "&Yes\n&No")
		if choice == 1
			%s/\s\+$//e
		endif
	endif
endfunction

function SetFirebugOptions()
	setlocal shiftwidth=4
	setlocal softtabstop=4
	setlocal list listchars=trail:_
	match ErrorMsg '\%>100v.\+'
endfunction

function SetCVOptions()
	call SetFirebugOptions()
	match ErrorMsg ''
endfunction

function SetFirebugNextOptions()
	call SetFirebugOptions()
	setlocal shiftwidth=2
	setlocal softtabstop=2
	match ErrorMsg '\%>80v.\+'
endfunction

" vimdiff
hi DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
hi DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
hi DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black
hi DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black

" Hard mode !
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
imap jk <ESC>
imap kj <ESC>
map <C-K> :pyf ~/.vim/python/clang-format-3.6.py<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""
"Spell correction with vim7
"based on http://www.cs.swarthmore.edu/help/vim/vim7.html
if has("spell")
	" turn spelling on by default
	set spell

	" toggle spelling with F4 key
	map <F4> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

	" they were using white on white
	highlight PmenuSel ctermfg=black ctermbg=lightgray

	" limit it to just the top 10 items
	set sps=best,10
endif

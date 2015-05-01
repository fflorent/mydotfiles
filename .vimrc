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
set number
set relativenumber
let mapleader=' '
set synmaxcol=200 " don’t try to highlight super long lines

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=/home/florent/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('/home/florent/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Shougo/unite.vim'
NeoBundle 'walm/jshint.vim'
NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'kchmck/vim-coffee-script'
" too slow
" NeoBundle 'jaxbot/github-issues.vim'
NeoBundle 'fugitive.vim'
NeoBundle 'junegunn/vim-peekaboo'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
NeoBundle 'pbrisbin/vim-mkdir'
NeoBundle 'bling/vim-airline'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'fabi1cazenave/kalahari.vim'
NeoBundle 'fabi1cazenave/suckless.vim'
NeoBundle 'marijnh/tern_for_vim', {
      \ 'build' : {
      \      'others': 'sh -c "cd tern_for_vim && npm install"'
      \     }
      \ }
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Valloric/YouCompleteMe', {
     \ 'build' : {
     \     'mac' : './install.sh',
     \     'unix' : './install.sh',
     \     'windows' : './install.sh',
     \     'cygwin' : './install.sh'
     \    }
     \ }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
" execute pathogen for some plugins (still useful?)
execute pathogen#infect()

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

" Unite
nnoremap <C-P> :Unite -start-insert file_mru buffer file_rec/async<cr>
nnoremap // :Unite -start-insert line<CR>
nnoremap <leader>o :Unite -start-insert outline<CR>
nnoremap <leader>/ :Unite grep:.<cr>
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :Unite history/yank<cr>

" Ultisnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsEditSplit="vertical"

" kalahari

colorscheme kalahari

" Peekaboo
let g:peekaboo_window = 'vertical botright 30new'

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

"  move text and rehighlight -- vim tip_id=224
vnoremap > ><CR>gv
vnoremap < <<CR>gv

" Gundo
nnoremap <F5> :GundoToggle<CR>
" undo options
set undofile
" Manage sessions
map <F2> :mksession! ~/vim_session <cr> " Quick write session with F2
map <F3> :source ~/vim_session <cr>     " And load session with F3
"JSHint
nnoremap <F6> :w<CR>:JSHint<CR>

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline_theme='powerlineish'
set laststatus=2

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

function! RemoveTrailingSpace()
	if search('\s\+$')
		let choice = confirm('Trailing spaces found. Remove them?', "&Yes\n&No")
		if choice == 1
			%s/\s\+$//e
		endif
	endif
endfunction

function! SetFirebugOptions()
	setlocal shiftwidth=4
	setlocal softtabstop=4
	setlocal list listchars=trail:_
	match ErrorMsg '\%>100v.\+'
endfunction

function! SetCVOptions()
	call SetFirebugOptions()
	match ErrorMsg ''
endfunction

function! SetFirebugNextOptions()
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

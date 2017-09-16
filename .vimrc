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
set hidden
if has("nvim")
  set icm=split
endif

set runtimepath+=/home/florent/.config/nvim/bundles/repos/github.com/Shougo/dein.vim/

if dein#load_state('/home/florent/.config/nvim/bundles')
  call dein#begin('/home/florent/.config/nvim/bundles')

  call dein#add('Shougo/denite.nvim')
  call dein#add('sjl/gundo.vim')
  call dein#add('tpope/vim-surround')
  " too slow
  " call dein#add('jaxbot/github-issues.vim')
  call dein#add('tpope/vim-fugitive')
  call dein#add('junegunn/vim-peekaboo')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')
  call dein#add('pbrisbin/vim-mkdir')
  call dein#add('bling/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('Shougo/neomru.vim')
  " call dein#add('Shougo/unite-outline')
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('fabi1cazenave/kalahari.vim')
  call dein#add('fabi1cazenave/suckless.vim')
  call dein#add('fflorent/macrobug.vim')
  " call dein#add('ujihisa/unite-locate')
  " call dein#add('junegunn/vader.vim')
  call dein#add('carlitux/deoplete-ternjs', {
        \ 'build': {
          \ 'mac': 'npm install -g tern',
          \ 'unix': 'sudo npm install -g tern'
        \ }})
  call dein#add('scrooloose/syntastic')
  " call dein#add('tomtom/tcomment_vim')
  call dein#add('xolox/vim-misc') " required by vim-session
  call dein#add('xolox/vim-session', {'depends': 'xolox/vim-misc'})
  " call dein#add('glts/vim-textobj-comment', {
  "       \ 'depends': 'kana/vim-textobj-user'
  "       \ })
  " call dein#add('marijnh/tern_for_vim', {
  "       \ 'build' : {
  "       \      'others': 'sh -c "cd /home/florent/.vim/bundle/tern_for_vim && npm install"'
  "       \     }
  "       \ })
  call dein#add('rust-lang/rust.vim')
  " call dein#add('Valloric/YouCompleteMe', {
  "      \ 'build' : {
  "      \     'mac' : './install.sh',
  "      \     'unix' : './install.sh',
  "      \     'windows' : './install.sh',
  "      \     'cygwin' : './install.sh'
  "      \    }
  "      \ })
  call dein#add('racer-rust/vim-racer')

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on

vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
" map <C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p

inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
      \ "\<lt>C-n>" :
      \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
      \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
      \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"

nmap <Backspace> X
map <F10> <NOP>
let g:deoplete#enable_at_startup = 1
let g:tern_request_timeout = 5

" Denite
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
nnoremap <silent> <A-p> :<C-u>Denite
      \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>

call denite#custom#map('insert', '<A-l>', '<denite:do_action:vsplit>', 'noremap')
call denite#custom#map('insert', '<A-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<A-j>', '<denite:move_to_next_line>', 'noremap')

" Unite
" nnoremap <C-P> :Unite -start-insert -smartcase file_rec/git:--exclude-standard<cr>
" nnoremap // :Unite -start-insert -smartcase line<CR>
" nnoremap <leader>o :Unite -start-insert outline<CR>
" call unite#filters#sorter_default#use(['sorter_ftime'])
nnoremap <leader>/ :Denite grep:.<cr>
" call denite#custom#var('grep', 'default_opts',
"   \ ['-i', '--color'])
" let g:unite_source_history_yank_enable = 1
" nnoremap <leader>y :Unite history/yank<cr>

" Ultisnips
let g:UltiSnipsExpandTrigger="<a-j>"
let g:UltiSnipsJumpForwardTrigger="<a-j>"
let g:UltiSnipsJumpBackwardTrigger="<a-k>"
let g:UltiSnipsEditSplit="vertical"

" ESLint
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
nnoremap <leader>se :SyntasticCheck<CR> :SyntasticToggleMode<CR>
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0 " disabled due to large mozilla-central files
let g:syntastic_check_on_wq = 0
nnoremap <leader>cj :lnext<cr>
nnoremap <leader>ck :lprev<cr>
nnoremap <leader>cc :lopen<cr>
nnoremap <leader>cx :lopen<cr>

" kalahari

colorscheme kalahari

" Peekaboo
let g:peekaboo_window = 'vertical botright 30new'

" vim-session
let g:session_autosave='yes'
let g:session_autoload='no'
nnoremap <leader>so :OpenSession
nnoremap <leader>ss :SaveSession
nnoremap <leader>sd :DeleteSession<cr>
nnoremap <leader>sc :CloseSession<cr>

" Cursor shape when in insert mode
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

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

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled=1
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

augroup filetypes
  au!
  autocmd BufRead,BufNewFile *.jsm set filetype=javascript
augroup end

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

" Remap keys for navigating
if has("nvim")
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  tnoremap <A-q> <C-\><C-n>
endif
" Hard mode !
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
imap jk <ESC>
imap kj <ESC>
nnoremap <a-o> <c-o>
nnoremap <a-i> <c-i>
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

" Racer configuration
let g:racer_cmd = "/home/florent/.cargo/bin/racer"

au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

let g:deoplete#sources#rust#racer_binary=g:racer_cmd
let g:deoplete#sources#rust#rust_source_path=$RUST_SRC_PATH
let g:deoplete#sources#rust#documentation_max_height=20

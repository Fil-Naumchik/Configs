"Автоматическая установка менеджера плагинов при старте вим
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

set nocompatible " отключить режим совместимости с классическим Vi
"filetype off
"%{FugitiveStatusline()}

let mapleader="\<Space>"

call plug#begin('~/.vim/plug.vim')
"плагин работы с папками The-Nerd-tree toggle
Plug 'scrooloose/nerdtree'
"плагин цветовой схемы
Plug 'morhetz/gruvbox'
"автоматом ставит вторые пары ( " и т.д.
Plug 'jiangmiao/auto-pairs'
"позволяет . работать со всем
Plug 'tpope/vim-repeat'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'Shougo/vimshell.vim'
"для git
Plug 'tpope/vim-fugitive'
Plug 'stephpy/vim-yaml', { 'for': 'yaml'  }
"для vagrant
Plug 'hashivim/vim-vagrant'
"поддержка большого кол-ва языков
Plug 'sheerun/vim-polyglot'
"php code sniffer
"Plug 'vsushkov/vim-phpcs'
Plug 'phpactor/phpactor', {'for': 'php', 'do': 'composer install'}
Plug 'vim-scripts/groovy.vim'
"fzf plugin
Plug 'junegunn/fzf.vim'
call plug#end()

"NerdTreeToggle вызывается с помощью  
"map <c-n> :NERDTreeToggle<cr>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

if did_filetype()
    finish
endif
    if getline(1) =~ '^#!.*[/\\]groovy\>'
    setf groovy
endif

"включить нумерацию
set number

"цвет фона
set background=dark

colorscheme gruvbox

set rtp+=/home/maksim/.local/lib/python3.8/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
"сколько cтрок внизу и вверху экрана показывать при скроллинге
"set scrolloff=3 

" Enable hotkeys for Russian layout
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"включает поддержку мыши при работе в терминале (без GUI)
"set mouse=a 

"показывать незавершенные команды в статусбаре (автодополнение ввода)
"set showcmd 

"перемещение > < после выделения на 4
set shiftwidth=4

"показывать первую парную скобку после ввода второй
set showmatch 

"подсветка синтаксиса 
syntax on 

"Включаем фолдинг (сворачивание участков кода)
"set foldenable

"Сворачивание по отступам
"set fdm=indent

"пробелы вместо Tab
set expandtab
"4 пробела вместо Tab
set tabstop=4
set noswapfile


"set clipboard=autoselect,unnamed,exclude:cons\|linux

"copy to os bufer
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif


"подсветка поиска
"set hlsearch
"set incsearch

"функция открытия нового окна 
map <silent> <C-h> :call WinMove('h')<CR>
map <silent> <C-j> :call WinMove('j')<CR>
map <silent> <C-k> :call WinMove('k')<CR>
map <silent> <C-l> :call WinMove('l')<CR>

function! WinMove(key)
  let t:curwin = winnr()
  exec "wincmd ".a:key
  if (t:curwin == winnr())
     if (match(a:key,'[jk]'))
        wincmd v
     else
        wincmd s
     endif
     exec "wincmd ".a:key
  endif
endfunction


function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

map cch :norm i#<CR>
map ccs :norm i//<CR>
vmap uc :norm ^x<CR>

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

"функция для перемещения строки Ctrl + Shift + Up/Down вверх/вниз
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <c-s-up> :call <SID>swap_up()<CR>
noremap <silent> <c-s-down> :call <SID>swap_down()<CR>

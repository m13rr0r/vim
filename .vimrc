"avoiding annoying CSApprox warning message
let g:CSApprox_verbose_level = 0

"necessary on some Linux distros for pathogen to properly load bundles
filetype on
filetype off

"load pathogen managed plugins
"call pathogen#infect()

"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history

set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

" " Формат строки состояния
set statusline=%<%f%h%m%r\ %{&encoding}
set laststatus=2

set showbreak=...
set wrap linebreak nolist
set ch=1
set autoindent
set termencoding=utf-8
set encoding=utf-8
set mouse=a
set mousemodel=popup
set novisualbell
set t_vb=
"add some line space for easy reading
set linespace=4

"disable visual bell
set visualbell t_vb=

"try to make possible to navigate within lines of wrapped lines
nmap <Down> gj
nmap <Up> gk
set fo=l

let g:syntastic_enable_signs=1
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']

"RVM
set statusline+=%=      "left/right separator
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2
"turn off needless toolbar on gvim/mvim
set guioptions-=T
"turn off the scroll bar
set guioptions-=L
set guioptions-=r

" " Включаем "умные" отспупы ( например, автоотступ после {)
set smartindent
" " Fix <Enter> for comment
set fo+=cr
" Поиск по словарю
imap <F1> <Esc><S-K>
nmap <F1> <S-K>
imap <F2> <Esc> g]
nmap <F2> g]
imap <F3> <Esc><C-T>
nmap <F3> <C-T>
imap <F19> <Esc> i
nmap <F19> i

" " Заставляем shift-insert работать как в Xterm
map <S-Insert> <MiddleMouse>

" " Выключаем ненавистный режим замены
imap <Ins> <Esc>i<RIGHT>

" " Редко когда надо [ без пары =)
"imap [ []<LEFT>
"imap { {}<LEFT>
"imap ( ()<LEFT>
"imap < <><LEFT>

" " Меню выбора кодировки текста (koi8-r, cp1251, cp866, utf8)

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

command -range=% -nargs=* Tidy <line1>,<line2>!perltidy

fun DoTidy()
    let Pos = line2byte( line( "." ) )
    :Tidy
    exe "goto " . Pos
endfun
au Filetype perl nmap <F5> :call DoTidy()<CR>
au Filetype perl vmap <F5> :Tidy<CR>

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction

"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"indent settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wcm=<Tab>
menu Encoding.koi8-r  :e ++enc=koi8-r<CR>
menu Encoding.cp1251  :e ++enc=cp1251<CR>
menu Encoding.utf-8   :e ++enc=utf-8<CR>
map <F7> :emenu Encoding.<Tab>
imap <F7> <Esc><F7>
menu Run.PHPCheck  :w\|! php -l %
menu Run.PHP  :w\|! php %
menu Run.PerlCheck  :w\|! perl -cw %
menu Run.Perl  :w\|! perl %
menu Run.Python   :w\|! python %
map <F6> :emenu Run.<Tab>
imap <F6> <Esc><F6>

map <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 0


"display tabs and trailing spaces
"set list
"set listchars=tab:\ \ ,extends:>,precedes:<
" disabling list because it interferes with soft wrap

set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"hide buffers when not displayed
set hidden

"Activate smartcase
set ic
set smartcase

if has("gui_running")
    "tell the term has 256 colors
    set t_Co=256

    colorscheme molokai
    set guitablabel=%M%t
    set lines=40
    set columns=115

    if has("gui_gnome")
        set term=gnome-256color
        colorscheme molokai
        set guifont=Monospace\ Bold\ 12
    endif

    if has("gui_mac") || has("gui_macvim")
        set guifont=Menlo:h12
        set transparency=7
    endif

    if has("gui_win32") || has("gui_win32s")
        set guifont=Consolas:h12
        set enc=utf-8
    endif
else
    "dont load csapprox if there is no gui support - silences an annoying warning
    let g:CSApprox_loaded = 1

    "set railscasts colorscheme when running vim in gnome terminal
    if $COLORTERM == 'gnome-terminal'
        set term=gnome-256color
        colorscheme molokai
    else
        if $TERM == 'xterm'
            set term=xterm-256color
            colorscheme molokai
        else
            colorscheme default
        endif
    endif
endif

" PeepOpen uses <Leader>p as well so you will need to redefine it so something
" else in your ~/.vimrc file, such as:
" nmap <silent> <Leader>q <Plug>PeepOpen

"map to bufexplorer
nnoremap <leader>b :BufExplorer<cr>
"map to bufergator
let g:buffergator_suppress_keymaps = 1
nnoremap <leader>bg :BuffergatorToggle<cr>

"disable resizing when calling buffergator
let g:buffergator_autoexpand_on_split = 0

"map to CommandT TextMate style finder
nnoremap <leader>t :CommandT<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"bindings for ragtag
let g:ragtag_global_maps = 1

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

"snipmate setup

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    "%s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()


let ScreenShot = {'Icon':0, 'Credits':0, 'force_background':'#FFFFFF'}

"Enabling Zencoding
let g:user_zen_settings = {
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'c',
  \  },
  \  'xml' : {
  \    'extends' : 'html',
  \  },
  \  'haml' : {
  \    'extends' : 'html',
  \  },
  \  'erb' : {
  \    'extends' : 'html',
  \  },
 \}

" when press { + Enter, the {} block will expand.
imap {<CR> {}<ESC>i<CR><ESC>O

" NERDTree settings
nmap <F12> :NERDTreeToggle<cr>
imap <F12> <esc>:NERDTreeToggle<cr>i
vmap <F12> <esc>:NERDTreeToggle<cr>i
let NERDTreeIgnore=['\.swp$']

" Создание буфера
nmap <F9> <Esc>:tabnew<cr>
vmap <F9> <esc>:tabnew<cr>
map <F9> <esc>:tabnew<cr>

" F6 - предыдущий буфер
map <F10> :tabp<cr>
map <F10> <esc>:tabp<cr>
map <F10> <esc>:tabp<cr>

" F7 - следующий буфер
map <F11> :tabn<cr>
map <F11> <esc>:tabn<cr>
map <F11> <esc>:tabn<cr>

" Автозавершение слов по tab =)
function InsertTabWrapper()
     let col = col('.') - 1
     if !col || getline('.')[col - 1] !~ '\k'
         return "\<tab>"
     else
         return "\<c-p>"
     endif
endfunction
"" Слова откуда будем завершать
set complete=""
" Из текущего буфера
set complete+=.
"   Из словаря
set complete+=k
"    Из других открытых буферов
set complete+=b
"     из тегов
set complete+=t
"
" Включаем filetype плугин. Настройки, специфичные для определынных файлов мы разнесём по разным местам
"
filetype plugin on
au BufRead,BufNewFile *.php    set filetype=php
au BufRead,BufNewFile *.inc    set filetype=php
au BufRead,BufNewFile *.thtml    set filetype=php
au BufRead,BufNewFile *.tpl    set filetype=php
au BufRead,BufNewFile *.pl    set filetype=perl
au BufRead,BufNewFile *.pm    set filetype=perl

" " Настройки для SessionMgr
let g:SessionMgr_AutoManage = 0
let g:SessionMgr_DefaultName = "mysession"
" "
"  Настройки для Tlist (показвать только текущий файл в окне навигации по
"  коду)
let g:Tlist_Show_One_File = 1
"
set completeopt-=preview
set completeopt+=longest
set mps-=[:]

if has("balloon_eval")
  set noballooneval
endif

au FileType javascript call JavaScriptFold()

set errorformat=%m\ in\ %f\ on\ line\ %l

noremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR>

imap <Tab> <c-r>=InsertTabWrapper()<cr>
nmap <Tab> <C-W>w

autocmd BufWritePre *.php :%s/\s\+$//e

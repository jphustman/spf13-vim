" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker spell:
"
"                    __ _ _____              _
"         ___ _ __  / _/ |___ /      __   __(_)_ __ ___
"        / __| '_ \| |_| | |_ \ _____\ \ / /| | '_ ` _ \
"        \__ \ |_) |  _| |___) |_____|\ V / | | | | | | |
"        |___/ .__/|_| |_|____/        \_/  |_|_| |_| |_|
"            |_|
"
"   This is the personal .vimrc file of Steve Francia.
"   While much of it is beneficial for general use, I would
"   recommend picking out the parts you want and understand.
"
"   You can find me at http://spf13.com
" }

" Environment {

    " Basics {
        set nocompatible        " Must be first line
        set shell=/bin/sh
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if has('win32') || has('win64')
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Setup Bundle Support {
        " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype on
        filetype off
        set rtp+=~/.vim/bundle/vundle
        call vundle#rc()
    " }

" }

" Bundles {

    " Use local bundles if available {
        if filereadable(expand("~/.vimrc.bundles.local"))
            source ~/.vimrc.bundles.local
        endif
    " }

    " Use fork bundles if available {
        if filereadable(expand("~/.vimrc.bundles.fork"))
            source ~/.vimrc.bundles.fork
        endif
    " }

    " Use bundles config {
        if filereadable(expand("~/.vimrc.bundles"))
            source ~/.vimrc.bundles
        endif
    " }

" }

" General {

    set background=dark         " Assume a dark background
    if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has ('x') && has ('gui') " On Linux use + register for copy-paste
        set clipboard=unnamedplus
    elseif has ('gui')          " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.bundles.local file:
    "   let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.bundles.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {

    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        color solarized                 " Load a colorscheme
    endif
        let g:solarized_termtrans=1
        let g:solarized_contrast="high"
        let g:solarized_visibility="high"
    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background for
                                    " things like vim-gitgutter

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set nowrap                      " Wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,python,twig,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.bundles.local file:
    "   let g:spf13_leader='\'
    if !exists('g:spf13_leader')
        let mapleader = ','
    else
        let mapleader=g:spf13_leader
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add let g:spf13_no_easyWindows = 1
    " in your .vimrc.bundles.local file

    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    nnoremap j gj
    nnoremap k gk

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.bundles.local file:
    "   let g:spf13_no_fastTabs = 1
    if !exists('g:spf13_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Toggle search highlighting
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Fix home and end keybindings for screen, particularly on mac
    " - for some reason this fixes the arrow keys too. huh.
    map [F $
    imap [F $
    map [H g0
    imap [H g0

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

" }

" Plugins {

    " PIV {
        let g:DisableAutoPHPFolding = 0
        let g:PIVAutoClose = 0
    " }

    " Misc {
        let g:NERDShutUp=1
        let b:match_ignorecase = 1
    " }

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
    " }

    " NerdTree {
        map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
        map <leader>e :NERDTreeFind<CR>
        nmap <leader>nt :NERDTreeFind<CR>

        let NERDTreeShowBookmarks=1
        let NERDTreeIgnore=['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        let NERDTreeChDirMode=0
        let NERDTreeQuitOnOpen=1
        let NERDTreeMouseMode=2
        let NERDTreeShowHidden=1
        let NERDTreeKeepTreeInNewTab=1
        let g:nerdtree_tabs_open_on_gui_startup=0
    " }

    " Tabularize {
    "   nmap <Leader>a& :Tabularize /&<CR>
    "   vmap <Leader>a& :Tabularize /&<CR>
    "   nmap <Leader>a= :Tabularize /=<CR>
    "   vmap <Leader>a= :Tabularize /=<CR>
    "   nmap <Leader>a: :Tabularize /:<CR>
    "   vmap <Leader>a: :Tabularize /:<CR>
    "   nmap <Leader>a:: :Tabularize /:\zs<CR>
    "   vmap <Leader>a:: :Tabularize /:\zs<CR>
    "   nmap <Leader>a, :Tabularize /,<CR>
    "   vmap <Leader>a, :Tabularize /,<CR>
    "   nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    "   vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    " }

    " PyMode {
        let g:pymode_lint_checker = "pyflakes"
        let g:pymode_utils_whitespaces = 0
        let g:pymode_options = 0
    " }

    " ctrlp {
        let g:ctrlp_working_path_mode = 'ra'
        nnoremap <silent> <D-t> :CtrlP<CR>
        nnoremap <silent> <D-r> :CtrlPMRU<CR>
        let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

        " On Windows use "dir" as fallback command.
        if has('win32') || has('win64')
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'dir %s /-n /b /s /a-d'
            \ }
        else
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': 'find %s -type f'
            \ }
        endif
    "}

    " TagBar {
        nmap <F8> :TagbarToggle<CR>

        " If using go please install the gotags program using the following
        " go install github.com/jstemmer/gotags
        " And make sure gotags is in your path
        let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
                \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
                \ 'r:constructor', 'f:functions' ],
            \ 'sro' : '.',
            \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
            \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
            \ }
    "}

    " PythonMode {
    " Disable if python support not present
        if !has('python')
            let g:pymode = 1
        endif
    " }

    " Fugitive {
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>:GitGutter<CR>
        nnoremap <silent> <leader>gg :GitGutterToggle<CR>
    "}

    " neocomplete {
        if count(g:spf13_bundle_groups, 'neocomplcache')
        " Disable AutoComplPop.
        let g:acp_enableAtStartup = 0
        " Use neocomplete.
        let g:neocomplete#enable_at_startup = 1
        " Use smartcase.
        let g:neocomplete#enable_smart_case = 1
        " Set minimum syntax keyword length.
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

        " Define dictionary.
        let g:neocomplete#sources#dictionary#dictionaries = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplete#undo_completion()
        inoremap <expr><C-l>     neocomplete#complete_common_string()

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return neocomplete#smart_close_popup() . "\<CR>"
            " For no inserting <CR> key.
            "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
        endfunction
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplete#close_popup()
        inoremap <expr><C-e>  neocomplete#cancel_popup()
        " Close popup by <Space>.
        "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

        " For cursor moving in insert mode(Not recommended)
        "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
        "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
        "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
        "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
        " Or set this.
        "let g:neocomplete#enable_cursor_hold_i = 1
        " Or set this.
        "let g:neocomplete#enable_insert_char_pre = 1

        " AutoComplPop like behavior.
        "let g:neocomplete#enable_auto_select = 1

        " Shell like behavior(not recommended).
        "set completeopt+=longest
        "let g:neocomplete#enable_auto_select = 1
        "let g:neocomplete#disable_auto_complete = 1
        "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

        " For perlomni.vim setting.
        " https://github.com/c9s/perlomni.vim
        let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

    " neosnippet {
        " Plugin key-mappings.
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " SuperTab like snippets behavior.
        imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                    \ "\<Plug>(neosnippet_expand_or_jump)"
                    \: pumvisible() ? "\<C-n>" : "\<TAB>"
        smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                    \ "\<Plug>(neosnippet_expand_or_jump)"
                    \: "\<TAB>"

            " For snippet_complete marker.
            if has('conceal')
                set conceallevel=2 concealcursor=i
            endif

        let g:neosnippet#enable_snipmate_compatibility = 1
        let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    " }
    endif
    " }

    " UndoTree {
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    " }

    " indent_guides {
        if !exists('g:spf13_no_indent_guides_autocolor')
            let g:indent_guides_auto_colors = 1
        else
            " For some colorschemes, autocolor will not work (eg: 'desert', 'ir_black')
            autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#212121 ctermbg=3
            autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#404040 ctermbg=4
        endif
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_enable_on_vim_startup = 1
    " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if has("gui_gtk2")
            set guifont=Andale\ Mono\ Regular\ 16,Menlo\ Regular\ 15,Consolas\ Regular\ 16,Courier\ New\ Regular\ 18
        elseif has("gui_mac")
            set guifont=Andale\ Mono\ Regular:h16,Menlo\ Regular:h15,Consolas\ Regular:h16,Courier\ New\ Regular:h18
        elseif has("gui_win32")
            set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
        endif
        if has('gui_macvim')
            set transparency=5      " Make the window slightly transparent
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " UnBundle {
    function! UnBundle(arg, ...)
      let bundle = vundle#config#init_bundle(a:arg, a:000)
      call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
    endfunction

    com! -nargs=+         UnBundle
    \ call UnBundle(<args>)
    " }

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    " }

    " Initialize NERDTree as needed {
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }

    " Strip whitespace {
    function! StripTrailingWhitespace()
        " To disable the stripping of whitespace, add the following to your
        " .vimrc.local file:
        "   let g:spf13_keep_trailing_whitespace = 1
        if !exists('g:spf13_keep_trailing_whitespace')
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endif
    endfunction
    " }

" }

" Use fork vimrc if available {
    if filereadable(expand("~/.vimrc.fork"))
        source ~/.vimrc.fork
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }

" Use local gvimrc if available and gui is running {
    if has('gui_running')
        if filereadable(expand("~/.gvimrc.local"))
            source ~/.gvimrc.local
        endif
    endif
" }

" Finish local initializations {
    call InitializeDirectories()
" }

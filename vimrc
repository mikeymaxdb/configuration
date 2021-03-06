set nocompatible
filetype off

" Reload vimrc when edited
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

augroup tex
    autocmd!
    au BufRead,BufNewFile *.tex setlocal columns=80 wrap
augroup END

if has('nvim')
    augroup neovim_terminal
        autocmd!
        autocmd TermOpen * startinsert
        autocmd TermOpen * :set nonumber norelativenumber
    augroup END
endif

" Auto install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Get bash aliases into vim
let $BASH_ENV = "~/configuration/bash_aliases"

au VimResized * :wincmd =              " Resize splits when the window is resized

" Plugin manager vim-plug
call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'          " Gitgutter
Plug 'morhetz/gruvbox'                 " Gruvbox colorscheme
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                " Fast file searching
Plug 'junegunn/vim-plug'               " Plugin manager
Plug 'mattn/emmet-vim'                 " Quick html
Plug 'michaeljsmith/vim-indent-object' " Selecting by indent level vii vai vaI
Plug 'scrooloose/nerdtree'             " File tree
Plug 'sheerun/vim-polyglot'            " Many language packs
Plug 'terryma/vim-multiple-cursors'    " Edit multiple locations at once <C-n>
Plug 'tpope/vim-commentary'            " Comment/uncomment lines
Plug 'tpope/vim-fugitive'              " Git wrapper
Plug 'tpope/vim-repeat'                " Enable plugins to repeat with '.'
Plug 'tpope/vim-speeddating'           " Quickly work with dates
Plug 'tpope/vim-surround'              " Quickly surround with quotes
Plug 'wellle/targets.vim'              " More text objects
Plug 'yggdroot/indentline'             " Vertical line for space indents

if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/nvim-compe'
    " Plug 'nvim-lua/completion-nvim'
    " Plug 'steelsojka/completion-buffers'
    " Plug 'nvim-treesitter/nvim-treesitter'
    " Plug 'nvim-treesitter/completion-treesitter'
endif

" Must be last
Plug 'ryanoasis/vim-devicons'

call plug#end()

" App Settings
syntax enable                       " Syntax highlighting
set background=dark                 " Using dark background
colorscheme gruvbox                 " Fav colorscheme
set notermguicolors
filetype plugin on                  " Read filetype stuff
filetype indent on                  " Match file indents
set encoding=utf8                   " Set utf8 as standard encoding
set ffs=unix,dos,mac                " Use Unix as the standard file type
set history=1000                    " Long history
set undofile                        " Enable persistent undo
set undolevels=1000                 " How many undos
set undoreload=10000                " Number of lines to save for undo
set undodir=~/.vim/undo//           " Where to save undo histories
set backupdir=~/.vim/backup//       " Backup directory
set directory=~/.vim/swap//         " Swap directory
set autoread                        " Update file when changed outside of vim
set hidden                          " Retain buffers until quit
set visualbell                      " No bells
set ttyfast                         " Faster scrolling
set splitbelow                      " Window splitting behavior
set splitright                      " Window splitting behavior
set shortmess+=aAIsT                " Less initial messaging
set clipboard=unnamed               " Enable clipboard
set foldmethod=syntax               " Enable folding by indent
set nofoldenable                    " Folds open by default
set lazyredraw                      " Don't render everything

" UI Settings
set number                          " Line numbers
set noshowmode                      " Only have the mode in the statusline
set showcmd                         " Show commands
set showmatch                       " Highlight matching brace
set incsearch                       " Highlight search as you type
set hlsearch                        " Highlight search results
set laststatus=2                    " Always show status
set list                            " Show invisible characters
set listchars=tab:\|\ ,trail:·,extends:›,precedes:‹ " Show vertical line for tabs
set fillchars+=vert:│               " Make the split line solid
set signcolumn=yes                  " Always leave space for git/lint column

" Behavior Settings
set mouse=a                         " Enable mouse
set scrolloff=3                     " Keep cursor away from the top/bottom
set nowrap                          " No line wrapping
set backspace=indent,eol,start      " Backspace
set matchtime=3                     " Brace highlight time
set notimeout                       " Time out on key codes but not mappings.
set ttimeout                        " Terminal keycode timeount
set ttimeoutlen=10                  " Terminal timeout length
set updatetime=300
set expandtab                       " Use spaces
set autoindent                      " Auto indent
set nojoinspaces                    " One space after punctuation
set softtabstop=4                   " Tab size
set shiftwidth=4                    " Tab size
set tabstop=4                       " Tab size
set smarttab                        " Smart tab size
set ignorecase                      " Ignore case when searching
set smartcase                       " Smart case-sensitivity
set wildmenu                        " Path/file expansion in colon-mode
set wildmode=longest:full,list:full,list:longest
set wildchar=<TAB>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=*/node_modules/*,*/bower_components/*
set wildignore+=*/build/*

if has('nvim')
    set inccommand=nosplit          " Hightlight replace as you type
endif


function SwitchToCorresponding(split)
    let extension = expand('%:e') == 'jsx' ? '.scss' : '.jsx'
    let fileName = expand('%:r') . extension
    if filereadable(fileName)
        if a:split
            if winnr('$') > 1
                execute "wincmd w"
                execute "edit " . fileName
            else
                execute "vsplit " . fileName
            endif
        else
            execute "edit " . fileName
        endif
    else
        echohl WarningMsg | echomsg 'No corresponding file exists (' . fileName . ')' | echohl None
    endif
endfunction

" Map spacebar to leader
nmap <space> <leader>
nmap <space><space> <leader><leader>
xmap <space> <leader>

" Move using display lines
nnoremap j gj
nnoremap k gk

" Add saving with sudo
command! W w !sudo tee % >/dev/null
" Yank till eol with Y
nmap Y y$
" Put without yank
vnoremap p "0p
vnoremap P "0P
" Quick Save
nnoremap <Leader><Leader> :update<CR>
" Clear search highlight on enter
nnoremap <silent> <CR> :noh<CR><CR>
" Reindent the file
nnoremap <Leader>= mzgg=G`z
" Switch to corresponding file
nnoremap <silent> <Leader>c :call SwitchToCorresponding(0)<CR>
nnoremap <silent> <Leader>C :call SwitchToCorresponding(1)<CR>
" Save all buffers
nnoremap <Leader>w :wa<CR>
" Toggle fold
nnoremap <Leader>z za
" Open all folds
nnoremap <Leader>Z zR

" NerdTree
nnoremap <Leader>n :NERDTreeFind<CR>
nnoremap <Leader>N :NERDTreeToggle<CR>

" FZF
" Search in current buffer or all buffers
nnoremap <Leader>f :BLines<CR>
nnoremap <Leader>F :Lines<CR>
" Search for git files or all files
nnoremap <expr> <Leader>o fugitive#head() != '' ? ":GFiles<CR>" : ":Files<CR>"
nnoremap <Leader>O :Files<CR>
" Search file contents for word under cursor or in all files
nnoremap <Leader>* :Rg <C-R><C-W><CR>
nnoremap <Leader>G :Rg<Cr>
" List loaded buffers
nnoremap <Leader>b :Buffers<CR>

" GIT
" List git status
nnoremap <Leader>gs :GitFiles?<CR>
" List commit log
nnoremap <Leader>gl :Commits<CR>
" List commit log for current buffer
nnoremap <Leader>gt :BCommits<CR>
" Git blame
nnoremap <Leader>gb :Git blame<CR>
" Git diff
nnoremap <Leader>gd :Git difftool<CR>
" Git mergetool
nnoremap <Leader>gm :Git mergetool<CR>
" Add files and start commit
nnoremap <Leader>gc :!gaa<CR>:Gcommit<CR>
" Add all files
nnoremap <Leader>ga :!gaa<CR>

" Splits
" Side to side split
nnoremap <leader>sh <C-w>v<C-w>l
" Top/bottom split
nnoremap <leader>sv <C-w>s<C-w>l
" Close split
nnoremap <leader>sc <C-w>c
" Swap splits
nnoremap <leader>ss <C-w>r
" Navigate splits more easily
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Start calculator
nnoremap <leader>u a<C-r>=

" Buffers
" Previous buffer
nnoremap <c-p> :bprevious<CR>
" Next buffer
nnoremap <c-n> :bnext<CR>
" Close buffer
nnoremap <leader>q :bp<bar>bd#<CR>

" Comment lines with ctrl + / (vim-commentary)
nmap <C-_> gcc
vmap <C-_> gc

" Switch between files with backspace
nnoremap <bs> <c-^>

" Un-undo with shift + u
nnoremap U :redo<CR>

" Easier A
nnoremap <leader>a A

" Trigger Emmet
nmap <leader>e <C-Y>,

" Reload buffers
nnoremap <leader>r :bufdo e<CR>

" Open terminal in split
nmap <Leader>t :split<CR>:terminal<CR>


" FZF
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = { 'ctrl-q': function('s:build_quickfix_list') }

" Indentline
let g:indentLine_char = '│'
let g:indentLine_color_term = 237

" React
let g:jsx_ext_required = 0
let g:user_emmet_settings = {'javascript' : {'extends' : 'jsx'}}

" Autocomplete
set completeopt=menuone,noselect
set shortmess+=c

if has('nvim-0.5')
:lua << EOF
    local nvim_lsp = require('lspconfig')
    local on_attach_vim = function(client)
        require'completion'.on_attach(client)
    end

    local servers = {'tsserver', 'cssls', 'html', 'vimls', 'jsonls'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup { on_attach = on_attach_vim }
    end

    -- require'nvim-treesitter.configs'.setup { ensure_installed = "all", highlight = { enable = true }, indent = { enable = true } }
EOF
endif

" Completion-nvim
" let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
" let g:completion_sorting = 'length'
" let g:completion_chain_complete_list = [{'complete_items': ['buffers', 'lsp', 'path']}]
" let g:completion_matching_smart_case = 1
" let g:completion_trigger_on_delete = 1
" let g:completion_trigger_keyword_length = 1
" let g:completion_timer_cycle = 20
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Nvim-Compe
if has('nvim-0.5')
:lua << EOF
    require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'enable',
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
            path = true,
            buffer = true,
            nvim_lsp = true,
        },
    }

    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    local check_back_space = function()
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return true
        else
            return false
        end
    end

    -- Use (s-)tab to:
    --- move to prev/next item in completion menuone
    --- jump to prev/next snippet's placeholder
    _G.tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-n>"
        elseif check_back_space() then
            return t "<Tab>"
        else
            return vim.fn['compe#complete']()
        end
    end

    _G.s_tab_complete = function()
        if vim.fn.pumvisible() == 1 then
            return t "<C-p>"
        else
            return t "<S-Tab>"
        end
    end

    vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
    vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
EOF
endif

" Signcolumn colors
hi clear SignColumn
hi GitGutterAdd ctermfg=014
hi GitGutterChange ctermfg=012
hi GitGutterDelete ctermfg=009
hi GitGutterChangeDelete ctermfg=012

" Nerdtree colors
hi NERDTreeDir ctermfg=004

" Linenumbers color
hi LineNr ctermfg=239
" Split color
hi VertSplit ctermfg=239
" Column limit color
hi ColorColumn ctermbg=234
" Search color
hi Search ctermfg=175

" Statusline
set statusline=
set statusline+=%#uMode#
set statusline+=\ %{toupper(mode())}
set statusline+=\ 
set statusline+=%#uDir#
set statusline+=\ %r
set statusline+=\ %f
set statusline+=\ %M
set statusline+=%=
set statusline+=%#uFileT#
set statusline+=%{fugitive#head()}
" set statusline+=\ %Y
set statusline+=%#uInfo#
set statusline+=\ %p%%
set statusline+=\ %l/%L:%c
set statusline+=\ 
" Statusline colors
hi uMode ctermfg=000 ctermbg=010
hi uInfo ctermfg=013 ctermbg=237
hi uBuff ctermfg=229 ctermbg=239
hi uDir ctermfg=15 ctermbg=237
hi uFileT ctermfg=14 ctermbg=237
" Change mode color when entering/exiting insert mode
au InsertEnter * hi uMode ctermfg=015 ctermbg=004
au InsertLeave * hi uMode ctermfg=000 ctermbg=010

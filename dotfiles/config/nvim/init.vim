let g:python3_host_prog='/home/armonge/.pyenv/versions/neovim/bin/python'
let g:python2_host_prog='/home/armonge/.pyenv/versions/neovim2/bin/python'
let g:python_host_prog='/home/armonge/.pyenv/versions/neovim2/bin/python'

"dein Scripts-----------------------------
set nocompatible               " Be iMproved

" Required:
set runtimepath+=/home/armonge/.cache/dein/repos/github.com/Shougo/dein.vim
let g:dein#install_process_timeout = 240

" Required:
if dein#load_state('/home/armonge/.cache/dein')
  call dein#begin('/home/armonge/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/armonge/.cache/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:

  " Helps with writing HTML
  " html <C-y><Leader>
  call dein#add('mattn/emmet-vim')

  call dein#add('editorconfig/editorconfig-vim')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('lambdalisue/suda.vim')
  call dein#add('fatih/vim-go')
  call dein#add('wakatime/vim-wakatime')

  " Tagbar starts with <Leader>t
  call dein#add('majutsushi/tagbar')

  " encrypts files ending with .gpg
  call dein#add('jamessan/vim-gnupg')

  " File explorer
  " <C-e>
  call dein#add('scrooloose/nerdtree')

  " Syntax checker and fixer
  call dein#add('w0rp/ale')

  " Show indent guides
  " <Leader>ig
  call dein#add('nathanaelkane/vim-indent-guides')

  " Search in your project <C-s>
  call dein#add('mileszs/ack.vim')

  " Add licenses to the top of your file
  " :Mit :Apache :etc
  call dein#add('antoyo/vim-licenses')

  " watch images in vim
  call dein#add('ashisha/image.vim') 

  " Search files
  " <C-p>
  call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0 })
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  " Show which lines are covered
  call dein#add('ruanyl/coverage.vim')

  " Comments
  " <C-c>n
  call dein#add('scrooloose/nerdcommenter')

  " Notes
  call dein#add('xolox/vim-misc')
  call dein#add('xolox/vim-notes')

  " Support for syntax hightlighting of many languages
  call dein#add('sheerun/vim-polyglot')

  " completions
  call dein#add('Valloric/YouCompleteMe', { 'build': './install.py --ts-completer' })

  " General Programming {
  call dein#add('vim-scripts/sessionman.vim')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')
  call dein#add('SirVer/ultisnips')
  call dein#add('honza/vim-snippets')

  " colorscheme
  call dein#add('iCyMind/NeoSolarized')
  call dein#add('sickill/vim-monokai')
  call dein#add('ErichDonGubler/vim-sublime-monokai')
  call dein#add('dracula/vim')

  " python
  call dein#add('lambdalisue/vim-pyenv')
  call dein#add('tweekmonster/django-plus.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable


" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
syntax on

" The default leader is '\', but many people prefer ',' as it's in a standard
let mapleader = ','

cmap w!! w suda://%
set clipboard=unnamed,unnamedplus
set foldlevel=9
set relativenumber
filetype plugin indent on   " Automatically detect file types.
scriptencoding utf-8

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Restore cursor to file position in previous editing session
function! ResCur()
  if line("'\"") <= line("$")
    silent! normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

set backup                  " Backups are nice ...
set backupdir=$HOME/.vimbackup
silent !mkdir $HOME/.vimbackup > /dev/null 2>&1
if has('persistent_undo')
  set undofile                " So is persistent undo ...
  set undolevels=1000         " Maximum number of changes that can be undone
  set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

syntax enable

set termguicolors
set background=dark
colorscheme dracula
let g:airline_theme='dracula'

set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present
set wildmenu                    " Show list instead of just completing
"set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set foldenable                  " Auto fold code
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

set nowrap                      " Do not wrap long lines
"set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2                " Use indents of 4 spaces
set expandtab                   " Tabs are spaces, not tabs
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
"set matchpairs+=<:>             " Match, to be used with %
set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
"set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks


" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

"autocmd FileType go autocmd BufWritePre <buffer> Fmt
autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead .bashenv set filetype=sh

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}

let g:ale_python_auto_pipenv = 1
let g:ale_sh_shfmt_options='-i 2'
let g:ale_sign_column_always = 1
let g:ale_linters = {
      \   'go': ['gofmt'],
      \   'xml': ['xmllint', 'remove_trailing_lines', 'trim_whitespace'],
      \   'yaml': ['yamllint', 'remove_trailing_lines', 'trim_whitespace'],
      \   'htmldjango': ['htmlhint', 'proselint', 'trim_whitespace', 'remove_trailing_lines'],
      \   'rst': ['alex', 'proselint', 'redpen', 'rstcheck', 'vale', 'writegood', 'trim_whitespace', 'remove_trailing_lines'],
      \   'sh': ['shellcheck'],
      \}

let g:ale_fixers = {
      \   'go': ['gofmt'],
      \   'javascript': ['prettier', 'eslint', 'remove_trailing_lines', 'trim_whitespace'],
      \   'typescript': ['prettier', 'tslint', 'remove_trailing_lines', 'trim_whitespace'],
      \   'json': ['prettier', 'trim_whitespace', 'remove_trailing_lines'],
      \   'python': ['black', 'trim_whitespace', 'remove_trailing_lines'],
      \   'html': ['tidy', 'trim_whitespace', 'remove_trailing_lines'],
      \   'htmldjango': ['trim_whitespace', 'remove_trailing_lines'],
      \   'rst': ['trim_whitespace', 'remove_trailing_lines'],
      \   'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines']
      \}

" Set this setting in vimrc if you want to fix files automatically on save.
" This is off by default.
let g:ale_fix_on_save = 1

" When set to `1` in your vimrc file, this option will cause ALE to run
" linters when you leave insert mode.
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1
" AutoCloseTag {
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

" Strip whitespace {
function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
" }

" YouCompletMe
let g:ycm_autoclose_preview_window_after_insertin = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_python_binary_path = "/home/armonge/.pyenv/shims/python"

nnoremap <Leader>rn :YcmCompleter RefactorRename 
nnoremap <C-g> :YcmCompleter GoToDefinition<CR>
nnoremap <F9> :YcmCompleter FixIt<CR>
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
nnoremap <F8> :YcmCompleter OrganizeImports<CR>

" Go
autocmd FileType go nnoremap<buffer> <Leader>rn :GoRename 
autocmd FileType go nnoremap<buffer> <F5> :GoBuild<CR>

" NerdTree {
map <C-e> <plug>NERDTreeTabsToggle<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
nnoremap <C-e> :NERDTreeToggle<CR>
" }

" FZF
nnoremap <C-p> :FZF<CR>
let g:fzf_buffers_jump = 1


" UltiSnips triggering
let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

" ack.vim {
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_autoclose = 1

" Don't go directly to the file
nnoremap <C-s> :Ack! 
" }

"  coverage
let g:coverage_json_report_path = 'coverage/coverage-final.json'

" licenses
let g:licenses_authors_name = 'Rain Agency <contact@rain.agency>'
let g:licenses_copyright_holders_name = 'Rain Agency <contact@rain.agency>'

" Tagbar
nmap <Leader>t :TagbarToggle<CR>
let g:tagbar_type_typescript = {                                                  
  \ 'ctagsbin' : 'tstags',                                                        
  \ 'ctagsargs' : '-f-',                                                           
  \ 'kinds': [                                                                     
    \ 'e:enums:0:1',                                                               
    \ 'f:function:0:1',                                                            
    \ 't:typealias:0:1',                                                           
    \ 'M:Module:0:1',                                                              
    \ 'I:import:0:1',                                                              
    \ 'i:interface:0:1',                                                           
    \ 'C:class:0:1',                                                               
    \ 'm:method:0:1',                                                              
    \ 'p:property:0:1',                                                            
    \ 'v:variable:0:1',                                                            
    \ 'c:const:0:1',                                                              
  \ ],                                                                            
  \ 'sort' : 0                                                                    
\ }                                                                               

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
\ }

" Notes
let g:notes_directories = ['~/Notes']

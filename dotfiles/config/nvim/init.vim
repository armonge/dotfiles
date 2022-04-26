" Python2 for neovim
if filereadable($HOME.'/.pyenv/versions/nvim2/bin/python')
    let g:python_host_prog=$HOME.'/.pyenv/versions/nvim2/bin/python'
    let g:python2_host_prog=$HOME.'/.pyenv/versions/nvim2/bin/python'
endif

" Python3 for neovim
if filereadable($HOME.'/.pyenv/versions/nvim3/bin/python')
    let g:python3_host_prog=$HOME.'/.pyenv/versions/nvim3/bin/python'
endif


"dein Scripts-----------------------------
set nocompatible               " Be iMproved

" Required:
set runtimepath+=~/.dein.cache/repos/github.com/Shougo/dein.vim
let g:dein#install_process_timeout = 240
let g:dein#enable_notification = 1
let g:dein#auto_recache = 1

" Required:
if dein#load_state('~/.dein.cache')
  call dein#begin('~/.dein.cache')

  " Let dein manage dein
  " Required:
  call dein#add('~/.dein.cache/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here:
  call dein#add('editorconfig/editorconfig-vim')

  " statusline
  call dein#add('liuchengxu/eleline.vim')
  
  call dein#add('lambdalisue/suda.vim')
  " call dein#add('mhinz/vim-startify')

  " call dein#add('fatih/vim-go')
  call dein#add('wakatime/vim-wakatime')

  " Colors
  call dein#add('arcticicestudio/nord-vim')

  " encrypts files ending with .gpg
  call dein#add('jamessan/vim-gnupg')

  " File explorer
  " <C-e>
  call dein#add('kevinhwang91/rnvimr')

  " Icons in file explorer, requires https://github.com/ryanoasis/nerd-fonts
  " call dein#add('ryanoasis/vim-devicons')

  " Show indent guides
  " <Leader>ig
  " call dein#add('nathanaelkane/vim-indent-guides')
  " call dein#add('Yggdroot/indentLine')
  " call dein#add('lukas-reineke/indent-blankline.nvim')
  " call dein#add('lukas-reineke/indent-blankline.nvim')

  " Search in your project <C-s>
  call dein#add('mileszs/ack.vim')

  " Add licenses to the top of your file
  " :Mit :Apache :etc
  call dein#add('antoyo/vim-licenses')

  " watch images in vim
  call dein#add('cxwx/image.vim', { 'build': 'pip install Pillow' })

  " Show import cost of javascript requires
  " call dein#add('yardnsm/vim-import-cost', { 'build': 'npm install' })

  " Search files
  " <C-p>
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })

  " lua format
  call dein#add('andrejlevkovitch/vim-lua-format')

  " Comments
  " <Leader>c<Space>
  call dein#add('scrooloose/nerdcommenter')

  " Support for syntax hightlighting of many languages
  " call dein#add('tpope/vim-sleuth')
  call dein#add('sheerun/vim-polyglot')
  " call dein#add('mboughaba/i3config.vim')
  " call dein#add('dart-lang/dart-vim-plugin')

  " completions
  call dein#add('neoclide/coc.nvim', {'merge':0, 'rev': 'release'})
  call dein#add("honza/vim-snippets")

  " Tagbar
  " call dein#add('liuchengxu/vista.vim')

  " <C-y),
  call dein#add("mattn/emmet-vim")

  " General Programming {
  call dein#add('vim-scripts/sessionman.vim')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('tpope/vim-repeat')
  call dein#add('tpope/vim-surround')
  call dein#add('embear/vim-uncrustify')

  " Clojure
  call dein#add('Olical/conjure')
  call dein#add('luochen1990/rainbow')
  call dein#add('tpope/vim-dispatch')
  call dein#add('clojure-vim/vim-jack-in')
  call dein#add('radenling/vim-dispatch-neovim')
  call dein#add('eraserhd/parinfer-rust', { 'build': 'cargo build --release' })

  " Writing prose in vim
  " <Leader>V
  " call dein#add('mikewest/vimroom')

  " Shows git commit messages for some line
  call dein#add('rhysd/git-messenger.vim', {
        \   'lazy' : 1,
        \   'on_cmd' : 'GitMessenger',
        \   'on_map' : '<Plug>(git-messenger',
        \ })

  " Required:
  call dein#end()
  call dein#save_state()
endif



" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

filetype plugin indent on
syntax enable

let gtkTheme = system('gsettings get org.gnome.desktop.interface gtk-theme')

" Nord {
set termguicolors 
if stridx(gtkTheme, 'dark') >= 0
  set background=dark
else
  set background=light
endif
colorscheme nord
" }


" The default leader is '\', but many people prefer ',' as it's in a standard
let mapleader=","
let maplocalleader=","

cmap w!! w suda://%
set clipboard=unnamed,unnamedplus

" Fold {
set foldenable                " Auto fold code
set foldlevel=9
set foldmethod=syntax
" set foldcolumn=1
set foldnestmax=4
set mouse=a
" }

set relativenumber
filetype plugin indent on   " Automatically detect file types.
scriptencoding utf-8
set fileencoding=utf-8
set nobomb
set autoread " Automatically reload file on external changes

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
autocmd BufNewFile,BufRead .envrc set filetype=sh
autocmd BufNewFile,BufRead .eslintrc set filetype=json
autocmd BufNewFile,BufRead ~/.config/regolith/i3/config set filetype=i3config
autocmd BufNewFile,BufRead ~/.ask/cli_config set filetype=json

function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}


" AutoCloseTag {
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }

if executable('intelephense')
  augroup LspPHPIntelephense
    au!
    au User lsp_setup call lsp#register_server({
        \ 'name': 'intelephense',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'intelephense --stdio']},
        \ 'whitelist': ['php'],
        \ 'initialization_options': {'storagePath': '/tmp/intelephense'},
        \ 'workspace_config': {
        \   'intelephense': {
        \     'files': {
        \       'maxSize': 1000000,
        \       'associations': ['*.php', '*.phtml', '*.module'],
        \       'exclude': [],
        \     },
        \     'completion': {
        \       'insertUseDeclaration': v:true,
        \       'fullyQualifyGlobalConstantsAndFunctions': v:false,
        \       'triggerParameterHints': v:true,
        \       'maxItems': 100,
        \     },
        \     'format': {
        \       'enable': v:true
        \     },
        \   },
        \ }
        \})
  augroup END
endif





" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=auto


" coc.nvim {
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-snippets', 'coc-prettier', 'coc-yaml', 'coc-html', 'coc-css', 'coc-eslint', 'coc-tsserver', 'coc-diagnostic', 'coc-pyright']

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Change floating window background
" highlight CocFloating ctermfg=Blue guifg=Blue

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" augroup mygroup
  " autocmd!
  " " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " " Update signature help on jump placeholder
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

" xmap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap if <Plug>(coc-funcobj-i)
" omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
nnoremap <silent> <space>l  :<C-u>CocList<cr>
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" }

" sql {
let g:sql_type_default = "sql.vim"
" }

"rnvimr {
tnoremap <silent> <M-i> <C-\><C-n>:RnvimrResize<CR>
nnoremap <silent> <C-e> :RnvimrToggle<CR>
tnoremap <silent> <C-e> <C-\><C-n>:RnvimrToggle<CR>
"}

" FZF {
let g:fzf_buffers_jump = 1
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --theme='Nord' --color=always --style=header,grid --line-range :300 {}'  "
colorscheme nord
" }
let $FZF_DEFAULT_COMMAND='ag --follow --nocolor --filename-pattern "" --hidden --ignore ".git/*" --ignore "node_modules/*" --depth=-1'
let g:vista_fzf_preview = ['right:60%']

nmap <C-]> :Vista!!<CR>
nnoremap <C-p> :Files<CR>
" }

" ack.vim {
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
let g:ack_autoclose = 1

" Don't go directly to the file
nnoremap <C-s> :Ack! 
" }

" licenses
let g:licenses_authors_name = 'Andrés Reyes Monge <armonge@gmail.com>'
let g:licenses_copyright_holders_name = 'Andrés Reyes Monge <armonge@gmail.com>'

" Git Messenger {
let g:git_messenger_no_default_mappings = v:true
nmap <C-w>m <Plug>(git-messenger)
"}
"

" Vimroom {
" let g:vimroom_ctermbackground="none"
" let g:vimroom_navigation_keys = 1
" }

" Eleline {
let g:eleline_powerline_fonts = 1
" }

" Airline {
" let g:airline#extensions#coc#enabled = 1

" function! s:update_git_status()
  " let g:airline_section_b = "%{get(g:,'coc_git_status','')}"
" endfunction

" let g:airline_section_b = "%{get(g:,'coc_git_status','')}"

autocmd User CocGitStatusChange call s:update_git_status()
" }

let g:uncrustify_language_mapping = {
      \   "c"      : "c",
      \   "objc"   : "oc",
      \   "objcpp" : "oc+",
      \   "cs"     : "cs",
      \   "java"   : "java",
      \   "vala"   : "vala"
      \ }

autocmd BufWritePre *.vala | call Uncrustify()


" Import cost{
" augroup import_cost_auto_run
  " autocmd!
  " autocmd InsertLeave *.js,*.jsx,*.ts,*.tsx ImportCost
  " autocmd BufEnter *.js,*.jsx,*.ts,*.tsx ImportCost
  " autocmd CursorHold *.js,*.jsx,*.ts,*.tsx ImportCost
" augroup END
" }
"
"
" let g:node_client_debug = 1
nmap gx :silent execute "!xdg-open " . shellescape("<cWORD>")<CR>
let g:rnvimr_ranger_cmd=$HOME.'/.pyenv/versions/nvim3/bin/ranger' 

" Lua
  autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
  autocmd BufWrite *.lua call LuaFormat()

  " SQL
  autocmd BufWritePre   *.sql call CocAction('format')


  " Clojure
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

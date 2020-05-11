set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.fzf
call vundle#begin()

" Vundle to manage vundle
Plugin 'VundleVim/Vundle.vim'

" Install YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

" Nerdtree plugin
Plugin 'scrooloose/nerdtree'
Plugin 'xuyuanp/nerdtree-git-plugin'

" Nerdcommenter plugin
Plugin 'scrooloose/nerdcommenter'

" ALE lint plugin
Plugin 'w0rp/ale'

" Vim-Airline plugin
Plugin 'vim-airline/vim-airline'

" Vim-Airline theme plugin
Plugin 'vim-airline/vim-airline-themes'

" Vim-fugitive git plugin
Plugin 'tpope/vim-fugitive'

" Show git diff in gutter
Plugin 'airblade/vim-gitgutter'

" Vim-Dispatch plugin
Plugin 'tpope/vim-dispatch'

" Docker file plugin
Plugin 'ekalinin/Dockerfile.vim'

" fzf
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" Distraction free mode
Plugin 'junegunn/goyo.vim'

" Solarized color scheme
Plugin 'altercation/vim-colors-solarized'

" Onedark color scheme
Plugin 'joshdick/onedark.vim'

" Auto ctags update on file change
Plugin 'soramugi/auto-ctags.vim'

" My own plugin
Plugin 'arunachalashiva/mvndisp'

call vundle#end()
filetype plugin indent on
syntax on

nnoremap <C-i> :YcmCompleter GoTo<CR>
nnoremap <C-j> :YcmCompleter GoToReferences<CR>

" nerdtree short cut to toggle open/close
nnoremap <silent> <expr> <leader>t g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" fzf shortcuts for files and tags
nnoremap <Leader>ff :call FzfFiles()<CR>
nnoremap <Leader>ft :call FzfTags()<CR>
nnoremap <Leader>fg :call FzfRg()<CR>

nnoremap <C-Right> :call BufferNext()<CR>
nnoremap <C-Left> :call BufferPrevious()<CR>

nnoremap <Leader>cd :CDir 

nnoremap <Leader>af :ALEFix<CR>
nnoremap <Leader>yf :YcmCompleter FixIt<CR>

" Airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ycm#enabled = 1
let g:airline#extensions#ycm#error_symbol = 'E:'
let g:airline#extensions#ycm#warning_symbol = 'W:'

" fzf settings
let g:fzf_tags_command = 'ctags -R'
let g:fzf_layout = { 'window': 'enew' }

let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1

" YCM settings
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.','re![_a-zA-z0-9]'],
  \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
  \             're!\[.*\]\s'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::','re![_a-zA-Z0-9]'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
" lombok work around for youcompleteme
let $JAVA_TOOL_OPTIONS = '-javaagent:/usr/local/share/vim/lombok-1.18.8.jar -Xbootclasspath/p:/usr/local/share/vim/lombok-1.18.8-sources.jar'

" Instant markdown settings
let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
let g:instant_markdown_slow = 1
let g:instant_markdown_browser = "firefox --new-window"

" Settings for my plugin mvndiskp
" Need to unset the above set JAVA_TOOL_OPTIONS (lombok work around) for mvn
" to work.
let g:mvndisp_mvn_cmd = 'unset JAVA_TOOL_OPTIONS && mvn'

" Color Schemes
let g:solarized_termcolors = 256
set background=dark
silent! colorscheme solarized
silent! call togglebg#map("<F5>")
silent! colorscheme onedark

" Open file from last location
if has("autocmd")
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" add yaml stuffs
autocmd! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set encoding=utf-8
set switchbuf=usetab
set tabline=[%t]
set cursorline
set number
set incsearch
" set spell

" Disable fzf shortcuts in nerdtree buffer
fun! FzfFiles()
  if &filetype != "nerdtree"
    exe ':Files'
  endif
endfun

fun! FzfTags()
  if &filetype != "nerdtree"
    exe ':Tags'
  endif
endfun

fun! FzfRg()
  if &filetype != "nerdtree"
    exe ':Rg'
  endif
endfun

fun! BufferNext()
  if &filetype != "nerdtree"
    exe ':bnext'
  endif
endfun

fun! BufferPrevious()
  if &filetype != "nerdtree"
    exe ':bprevious'
  endif
endfun

fun! ChDir(dir)
  exe ':cd' . a:dir
  if &filetype != "nerdtree"
    exe ':NERDTreeCWD'
  endif
endfun

fun! MyHelp()
  echom("vimide shortcuts")
  echom("'\\t'  - Open Close NERDTree")
  echom("'\\ff' - Open fzf Files")
  echom("'\\ft' - Open fzf Tags")
  echom("'\\fg' - Open fzf Rg (grep)")
  echom("'\\af' - Run ALEFix (fixer for lint errors)")
  echom("'\\yf' - Run YouCompleteMe FixIt")
  echom("'<Ctrl><Left>' - Switch to previous buffer")
  echom("'<Ctrl><Right>' - Switch to next buffer")
  echom("'\\cd' - Calls CDir <dir> directory and refresh NERDTree")
  echom("'\\mas' - Run :MvnCompile all")
  echom("'\\mat' - Run :MvnTest all")
  echom("'\\mms' - Run :MvnCompile submodule")
  echom("'\\mmt' - Run :MvnTest submodule")
  echom("'\\mtt' - Run :MvnTest current-test")
  echom("")
  echom("vimide commands")
  echom("':CDir <dir>' - Switch to <dir> directory and refresh NERDTree")
endfun

" Command to change to a directory (also refreshes NERDTree)
command! -nargs=1 -complete=dir CDir :call ChDir(<q-args>)
command! -nargs=0 HelpVimide :call MyHelp()

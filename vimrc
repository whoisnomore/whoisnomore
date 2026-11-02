" ~/.vimrc
syntax on
set notermguicolors
set background=dark

" Absolute line numbers
set number
set norelativenumber
set numberwidth=4
set cursorline

augroup TermColors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NonText ctermbg=NONE
  autocmd ColorScheme * highlight LineNr ctermfg=8 ctermbg=NONE
  autocmd ColorScheme * highlight CursorLineNr ctermfg=3 ctermbg=NONE cterm=bold
  autocmd ColorScheme * highlight CursorLine cterm=NONE ctermbg=0
  autocmd ColorScheme * highlight Visual ctermbg=8 ctermfg=NONE
  autocmd ColorScheme * highlight Comment ctermfg=8 cterm=italic
  autocmd ColorScheme * highlight StatusLine ctermfg=7 ctermbg=0 cterm=NONE
  autocmd ColorScheme * highlight StatusLineNC ctermfg=8 ctermbg=0 cterm=NONE
  autocmd ColorScheme * highlight VertSplit ctermfg=8 ctermbg=NONE cterm=NONE
  autocmd ColorScheme * highlight Pmenu ctermfg=7 ctermbg=0
  autocmd ColorScheme * highlight PmenuSel ctermfg=0 ctermbg=4
augroup END

colorscheme default

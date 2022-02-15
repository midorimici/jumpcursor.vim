" jumpcursor.vim
" Author: skanehira
" License: MIT

if exists('loaded_jumpcursor')
  finish
endif
let g:loaded_jumpcursor = 1

if !exists('jumpcursor_guihl')
  let g:jumpcursor_guihl = 'guibg=#ffeedd guifg=#ff7700 gui=bold'
endif

if !exists('jumpcursor_offset')
  let g:jumpcursor_offset = 0
endif

augroup jumpcursor_init_hl
  autocmd!
  autocmd VimEnter * call jumpcursor#init_hl()
augroup end

nnoremap <silent> <Plug>(jumpcursor-jump) :call jumpcursor#jump()<CR>

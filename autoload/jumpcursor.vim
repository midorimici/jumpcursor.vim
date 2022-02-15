" jumpcursor.vim
" Author: skanehira
" License: MIT

let g:jumpcursor_marks = get(g:, 'jumpcursor_marks', split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@[;:],./_-^\1234567890', '\zs'))

let s:jumpcursor_mark_lnums = {}
let s:jumpcursor_mark_cols = {}

let s:jumpcursor_hl_group_target = 'JumpCursorTarget'
let s:vscode_lines_items = []

function! jumpcursor#init_hl() abort
  let group_default = s:jumpcursor_hl_group_target . 'Default'
  execute printf('hi default %s %s', group_default, g:jumpcursor_guihl)
endfunction

function! s:vscode_fill_letters(parts) abort
  let s:vscode_lines_items = items(a:parts)
  if len(s:vscode_lines_items) > 0
    call VSCodeSetTextDecorations(s:jumpcursor_hl_group_target, s:vscode_lines_items)
  endif
endfunction

function! s:fill_window() abort
  " let start_line = line('w0')
  " let end_line = line('w$')
  let mark_len = len(g:jumpcursor_marks)

  " By default, line('w0') and line('w$') is incongruent with visible ranges
  " on VS Code. Instead, display marks around the current cursor.
  let cur_line = line('.')
  let start_line = cur_line - mark_len/2 + g:jumpcursor_offset
  if start_line < 1
    let start_line = 1
  endif
  let end_line = start_line + mark_len - 1

  " [[1, 1], [1,2], [1,5]]
  let mark_idx = 0
  let parts = {}

  while start_line <= end_line
    if mark_idx >= mark_len
      break
    endif
    let text = getline(start_line)
    let mark = g:jumpcursor_marks[mark_idx]

    let parts[start_line] = [[1, repeat(mark, len(text))]]

    let s:jumpcursor_mark_lnums[mark] = start_line
    let mark_idx += 1
    let start_line += 1
  endwhile

  " fill letters
  call s:vscode_fill_letters(parts)
endfunction

function! s:fill_specific_line(lnum) abort
  let text = getline(a:lnum)
  let mark_idx = 0
  let mark_len = len(g:jumpcursor_marks)
  let parts = {}

  for i in range(len(text))
    if mark_idx >= mark_len
      break
    endif

    if text[i] ==# ' ' || text[i] ==# "\t"
      continue
    endif

    let mark = g:jumpcursor_marks[mark_idx]
    let mark_idx += 1

    " set parts to fill
    if has_key(parts, a:lnum)
      call add(parts[a:lnum], [i+1, mark])
    else
      let parts[a:lnum] = [[i+1, mark]]
    endif

    let s:jumpcursor_mark_cols[mark] = i
  endfor

  " fill letters
  call s:vscode_fill_letters(parts)

  redraw!
endfunction

function! jumpcursor#jump() abort
  call s:fill_window()
  redraw!

  let mark = getcharstr()
  call s:jump_cursor_clear()

  if mark ==# '' || mark ==# ' ' || !has_key(s:jumpcursor_mark_lnums, mark)
    return
  endif

  let lnum = s:jumpcursor_mark_lnums[mark]

  call s:fill_specific_line(lnum)

  let mark = getcharstr()
  call s:jump_cursor_clear()

  if mark ==# '' || mark ==# ' ' || !has_key(s:jumpcursor_mark_cols, mark)
    return
  endif

  let col = s:jumpcursor_mark_cols[mark] + 1

  call setpos('.', [bufnr(), lnum, col, 0])

  let s:jumpcursor_mark_lnums = {}
  let s:jumpcursor_mark_cols = {}
endfunction

function! s:jump_cursor_clear() abort
  if len(s:vscode_lines_items) > 0
    call VSCodeSetTextDecorations(s:jumpcursor_hl_group_target, [])
  endif
endfunction

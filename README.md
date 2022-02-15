This is a fork of [jumpcursor.vim](https://github.com/skanehira/jumpcursor.vim) to use with [vscode-neovim](https://github.com/vscode-neovim/vscode-neovim).

## Installation

Example for installation with [vim-plug](https://github.com/junegunn/vim-plug):

```vim
" use normal jumpcursor when in normal vim
Plug 'skanehira/jumpcursor.vim', Cond(!exists('g:vscode'))
" use vscode version when in vscode
Plug 'midorimici/jumpcursor.vim', Cond(exists('g:vscode'), { 'as': 'vsc-jumpcursor.vim' })
```

For details, please see [descriptions from vscode-neovim documentation](https://github.com/vscode-neovim/vscode-neovim#conditional-initvim).

## Configuration

### Text styles

You can change background or foreground colours of mark texts with `g:jumpcursor_guihl` as follows:

```vim
" Default value: guibg=#ffeedd guifg=#ff7700 gui=bold
let g:jumpcursor_guihl = 'guibg=#ffeeff guifg=#0077ff gui=bold'
```

### Mark ranges

By default, `line('w0')` and `line('w$')` are incongruent with visible ranges on VS Code, leading marks out of sight when the plugin triggered at a bottom of a file.
To prevent this behaviour, this plugin set mark ranges so that the current line will be at the middle of the ranges. For instance, the current cursor line will be `L` by default.

To change characters that appear in visible ranges, you can change `g:jumpcursor_marks` (from the original plugin) as follows:

```vim
" Default value: split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@[;:],./_-^\1234567890', '\zs')
let g:jumpcursor_marks = split('abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ@[;:],./_-^\', '\zs')
```

This configuration also alters character order in the second key type (i.e. jumping to a specific column in a line).
If you feel like to shift mark ranges in window-filled state, you can set `g:jumpcursor_offset` as follows:

```vim
" Default value: 0
let g:jumpcursor_offset = 6
```

This results in range shift like this (though whitespace characters are ignored and it may be not the same result):

```
before:
  abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@[;:],./_-^\1234567890
           <------ visible ranges ----- ^ cursor ---------------->

after:
  abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@[;:],./_-^\1234567890
     <------ visible ranges ----- ^ cursor ---------------->
```

The original documentation for [jumpcursor.vim](https://github.com/skanehira/jumpcursor.vim) follows.

---

# jumpcursor.vim
## **THIS PLUGIN IS AN EXPERIMENTAL ONE.**

With this plugin, you can move cursor anywhere you want.  
This behavior is similar [vim-easymotion](https://github.com/easymotion/vim-easymotion) or [vim-searchx](https://github.com/hrsh7th/vim-searchx).

The key concept of this plugin is that you can move cursor anywhere you want without moving your eyes and by typing a letter twice.

![cursor_jump](https://user-images.githubusercontent.com/7888591/151286736-3e0e7db6-203d-419f-b557-d2d4a4523951.gif)

## NOTE
This plugin only support Neovim.  
But if this experiment is good for me, I'll support Vim.

## Usage
Please add your own mapping and use it.  
Then you can chose mark that you want to move.

```vim
nmap [j <Plug>(jumpcursor-jump)
```

## Author
skanehira

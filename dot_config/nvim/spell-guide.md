# Neovim Spell Checking Guide

## 🔍 Spelling Commands

### Navigation
- `]s` - Jump to next misspelled word
- `[s` - Jump to previous misspelled word

### Fixing Words
- `z=` - Show spelling suggestions for word under cursor
- `1z=` - Use first suggestion immediately
- `2z=` - Use second suggestion immediately

### Dictionary Management
- `zg` - Add word under cursor to personal dictionary
- `zw` - Mark word as incorrect (remove from dictionary)
- `zug` - Mark word as good for current session only

### Word Suggestions
- `z=` - Show all suggestions (select by number)
- `zG` - Add word to dictionary case-insensitive
- `zW` - Mark word as incorrect case-insensitive

## 🎯 Quick Fix Process

1. **Find errors**: `]s` (next) or `[s` (previous)
2. **Get suggestions**: `z=` 
3. **Choose fix**: Press number 1, 2, 3...
4. **Add word**: `zg` (if correct but not in dictionary)

## 📋 Keybindings Added

- `<leader>ss` - Toggle spell checking
- `<leader>sp` - Show spelling suggestions (`z=`)
- `<leader>sn` - Next misspelled word (`]s`)
- `<leader>sp` - Previous misspelled word (`[s`)
- `<leader>sa` - Add to dictionary (`zg`)
- `<leader>si` - Ignore this session (`zug`)

## ⚙️ Settings

```vim
set spell           -- Enable spell checking
set spelllang=en_gb -- Set language to British English
set spelllang=en_us -- Set language to US English
set nospell        -- Disable spell checking
```

## 🇬🇧🇺🇸 Language Switching

### UK vs US English Differences
| UK (en_gb) | US (en_us) |
|------------|------------|
| colour | color |
| favourite | favorite |
| analyse | analyze |
| centre | center |
| realise | realize |
| organise | organize |
| metre | meter |
| theatre | theater |
| dialogue | dialog |

### Quick Switching
- `<leader>sl` - Toggle between UK/US spelling
- `:set spelllang=en_gb` - Set to British English
- `:set spelllang=en_us` - Set to US English

## 🔤 Dictionary Location

Personal dictionary: `~/.config/nvim/spell/en.utf-8.add`
UK-specific: `~/.config/nvim/spell/en_gb.utf-8.add`
US-specific: `~/.config/nvim/spell/en_us.utf-8.add`
# The Power of 'z' Key in Neovim

## 🎯 Most Used Z-Keys

### Scroll & Position
| Command | Action | Mnemonic |
|---------|--------|----------|
| `zz` | Center cursor on screen | **z**oom center |
| `zt` | Put cursor line at top | **z**oom **t**op |
| `zb` | Put cursor line at bottom | **z**oom **b**ottom |
| `z.` | Center cursor | dot = center |

### Spell Checking  
| Command | Action | Mnemonic |
|---------|--------|----------|
| `z=` | Spelling suggestions | **z**pell **=** |
| `zg` | Add word to dictionary | **z**pell **g**ood |
| `zw` | Mark word as wrong | **z**pell **w**rong |
| `zug` | Ignore word this session | **z**pell **u**ndo **g**ood |

### Folding
| Command | Action | Mnemonic |
|---------|--------|----------|
| `za` | Toggle fold | **z**fold **a**lternate |
| `zc` | Close fold | **z**fold **c**lose |
| `zo` | Open fold | **z**fold **o**pen |
| `zf` | Create fold | **z**fold **f**old |

## 🚀 Essential Combinations

### Navigation & Positioning
```vim
zz          " Center current line
zt          " Put current line at top
zb          " Put current line at bottom
z<Return>   " Same as zt
z+          " Put cursor line at top
z-          " Put cursor line at bottom
```

### Advanced Scrolling
```vim
zj          " Move cursor down one fold
zk          " Move cursor up one fold
[z          " Move to start of previous fold
]z          " Move to start of next fold
```

### Folding Power
```vim
zR          " Open all folds in buffer
zM          " Close all folds in buffer
zi          " Toggle folding entirely
zc          " Close one fold
zo          " Open one fold
za          " Toggle one fold
```

## 💡 Pro Tips

1. **Quick Centering**: After searching/jumping, press `zz` to center
2. **Fold Navigation**: Use `zj` and `zk` to jump between folded sections
3. **Spell Fix Workflow**: `]s` → `z=` → choose number → `zg` (if needed)
4. **View Management**: `zt` before long scrolling, `zz` when reading

## 🎮 Practice Exercise

1. Open a long file: `nvim ~/.config/nvim/init.lua`
2. Search: `/spell` 
3. Press `zz` to center
4. Press `zt` to move to top
5. Press `zb` to move to bottom
6. Press `za` if you have folds enabled

The `z` key is your "view and text manipulation" command center!
# Neovim Autocompletion Cheat Sheet

## ✨ Smart Autocompletion (New Setup)

### Navigation
- **Tab** - Next completion item
- **Shift+Tab** - Previous completion item  
- **Enter** - Accept selected completion
- **Escape** - Cancel completion
- **Ctrl+Space** - Manually trigger completion

### Traditional Vim Completion (Works Always)
- **Ctrl+n** - Next word completion
- **Ctrl+p** - Previous word completion
- **Ctrl+x Ctrl+n** - Next word from buffer
- **Ctrl+x Ctrl+p** - Previous word from buffer

### Advanced Completion
- **Ctrl+x Ctrl+o** - Omni completion (LSP/syntax aware)
- **Ctrl+x Ctrl+l** - Line completion
- **Ctrl+x Ctrl+f** - File name completion

## 🎯 Usage Examples

### Word Autocompletion
1. Type partial word: `autocom`
2. Press **Tab** or **Ctrl+Space** 
3. Select from popup with **Tab/Shift+Tab**
4. Press **Enter** to accept

### In Insert Mode
```
# You type:
markdown

# Press Tab, get:
markdown-preview.nvim
```

### Command Line Completion
```
# Type in command mode:
:Markdown

# Press Tab, get:
:MarkdownPreview
```

## ⚡ Quick Tips

1. **Auto-complete words**: Start typing, press **Tab**
2. **See all options**: Press **Ctrl+Space** manually
3. **Dismiss suggestions**: Press **Escape**
4. **Navigate suggestions**: Use **Tab/Shift+Tab** or **↑/↓**

## 🔧 Configuration

Your setup includes:
- ✅ nvim-cmp (completion engine)
- ✅ Buffer completion (words in current buffer)
- ✅ Path completion (file paths)  
- ✅ LSP completion (when available)
- ✅ Traditional Vim word completion
## What is better-terminal.nvim?
better-terminal.nvim allows you to keep one terminal session in a floating window that can easily be toggled.
## Limitations

- This plugin is built for my personal workflow so expect breaking changes without notice.
-  Some terminal emulators might not support the default binding `"<C-;>"`

## lazy.nvim setup (with default values)
```lua
{
  "dotpluto/better-terminal.nvim",
  opts = {
    keymap = {
      --[[
        Normal mode keybind for toggling the terminal window.
      ]]--
      normal = "<C-;>",
      --[[
        Terminal mode keybind for closing the terminal window.
        Make sure you know what you are doing before changing this.
      ]]--
      terminal = "<C-;>",
    },
  },
}
```

vim.g.mapleader = " " -- set leader key before Lazy

require("danny.lazy") -- load plugins via lazy
require("danny.remap") -- set key rebindings
require("danny.set") -- set options
require("danny.lsp") -- lsp configuration

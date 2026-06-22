local M = {}

function M.setup()
  require("base16-colorscheme").setup({
    base00 = "",
    base01 = "",
    base02 = "",
    base03 = "",
    base04 = "",
    base05 = "",
    base06 = "",
    base07 = "",
    base08 = "",
    base09 = "",
    base0A = "",
    base0B = "",
    base0C = "",
    base0D = "",
    base0E = "",
    base0F = "",
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi("TelescopeNormal", { fg = "", bg = "" })
  hi("TelescopeBorder", { fg = "", bg = "" })
  hi("TelescopePromptNormal", { fg = "", bg = "" })
  hi("TelescopePromptBorder", { fg = "", bg = "" })
  hi("TelescopePromptPrefix", { fg = "", bg = "" })
  hi("TelescopePromptCounter", { fg = "", bg = "" })
  hi("TelescopePromptTitle", { fg = "", bg = "" })
  hi("TelescopePreviewTitle", { fg = "", bg = "" })
  hi("TelescopeResultsTitle", { fg = "", bg = "" })
  hi("TelescopeSelection", { fg = "", bg = "" })
  hi("TelescopeSelectionCaret", { fg = "", bg = "" })
  hi("TelescopeMatching", { fg = "", bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates)
local signal = vim.uv.new_signal()
signal:start(
  "sigusr1",
  vim.schedule_wrap(function()
    package.loaded["matugen"] = nil
    require("matugen").setup()
  end)
)

return M

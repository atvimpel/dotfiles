return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        -- termguicolors is set in config/options.lua; matugen owns all colors via
        -- colors/matugen.vim (guifg/guibg). No cterm overrides here — they clobber
        -- the matugen palette.
        local hl = vim.api.nvim_set_hl

        -- transparency & core UI (bg only, never force cterm colors over matugen)
        hl(0, "Normal", { bg = "NONE" })
        hl(0, "NormalNC", { bg = "NONE" })
        hl(0, "SignColumn", { bg = "NONE" })
        hl(0, "NormalFloat", { bg = "NONE" })
        hl(0, "FloatBorder", { bg = "NONE" })
        hl(0, "Pmenu", { bg = "NONE" })
        hl(0, "WinSeparator", { bg = "NONE" })
        hl(0, "NeoTreeNormal", { bg = "NONE" })
        hl(0, "NeoTreeNormalNC", { bg = "NONE" })
        hl(0, "SnacksExplorerNormal", { bg = "NONE" })
      end,
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    enabled = false,
    -- load immediately: the dashboard and noice can otherwise leave the
    -- native statusline in place until the first delayed event
    lazy = false,
    init = function()
      -- keep a real bottom statusline even while the plugin is lazy-loading
      vim.opt.laststatus = 3
    end,
    opts = function(_, opts)
      vim.opt.cmdheight = 1

      -- lualine theme built from matugen_res.lua so the status bar stays in
      -- sync when the wallpaper changes
      local ok, res = pcall(require, "matugen_res")
      local m3_theme
      if ok and res then
        m3_theme = {
          normal = {
            a = { fg = res.on_primary, bg = res.primary, gui = "bold" },
            b = { fg = res.on_surface, bg = res.surface_container_high },
          c = { fg = res.on_surface, bg = "NONE" },
          },
          insert = { a = { fg = res.on_secondary, bg = res.secondary, gui = "bold" } },
          visual = { a = { fg = res.on_tertiary, bg = res.tertiary, gui = "bold" } },
          command = { a = { fg = res.on_primary, bg = res.primary, gui = "bold" } },
          replace = { a = { fg = res.on_error_container, bg = res.error_container, gui = "bold" } },
          inactive = { c = { fg = res.outline, bg = "NONE" } },
        }
      else
        m3_theme = "auto"
      end

      opts.options = {
        theme = m3_theme,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      }

      opts.sections = {
        lualine_a = {
          {
            function()
            return "> " .. vim.fn.mode():lower()
            end,
            padding = { left = 1, right = 1 },
            separator = "",
          },
        },
        lualine_b = {
          {
            "branch",
            icon = "git:",
            padding = { left = 1, right = 1 },
            colored = true,
          },
        },
        lualine_c = {
          {
            function()
              local name = vim.fn.expand("%:t")
              return name == "" and "untitled" or name
            end,
            icon = "file:",
            padding = { left = 1, right = 0 },
            color = { fg = res and res.on_surface or nil, gui = "bold" },
          },
          {
            function()
              local dir = vim.fn.expand("%:p:h:t")
              return dir ~= "" and ("  / " .. dir) or ""
            end,
            padding = { left = 0, right = 1 },
            color = { fg = res and res.outline or nil },
          },
        },
        lualine_x = {
          {
            function()
              local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
              local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
              if errors == 0 and warnings == 0 then return "clean" end
              return string.format("%s×  %s△", errors, warnings)
            end,
            padding = { left = 1, right = 1 },
          },
          { "filetype", icon = "type:", padding = { left = 0, right = 1 } },
        },
        lualine_y = {
          {
            function() return "line " .. vim.fn.line(".") .. ":" .. vim.fn.col(".") end,
            padding = { left = 1, right = 1 },
          },
        },
        lualine_z = {
          {
            function()
              return string.format("%d%%", math.floor(vim.fn.line(".") / math.max(vim.fn.line("$"), 1) * 100))
            end,
            padding = { left = 1, right = 1 },
          },
        },
      }
      opts.winbar = {}
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
      vim.opt.laststatus = 3
      -- some dashboard/window plugins reset the option after startup
      vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "WinEnter" }, {
        callback = function()
          vim.opt.laststatus = 3
          vim.cmd("redrawstatus")
        end,
      })
      vim.api.nvim_set_hl(0, "lualine_transparent", {
        fg = (res and res.on_surface) or "#f9dcd9",
        bg = (res and res.surface_container) or "#2b1c1a",
      })
    end,
  },
  { "lukas-reineke/indent-blankline.nvim", enabled = false },
}

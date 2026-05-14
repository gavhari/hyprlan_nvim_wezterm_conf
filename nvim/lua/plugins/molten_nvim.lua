return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_auto_open_output = false -- cannot be true if molten_image_provider = "wezterm"
      vim.g.molten_output_show_more = true
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_virt_lines = true
      vim.g.molten_split_direction = "right" --direction of the output window, options are "right", "left", "top", "bottom"
      vim.g.molten_split_size = 20 --(0-100) % size of the screen dedicated to the output window
      vim.g.molten_virt_text_output = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_auto_image_popup = false
      -- vim.g.molten_output_win_zindex = 50
      vim.g.molten_wrap_output = true
      -- Tambahkan di hook VenvSelected sebelumnya
      vim.api.nvim_create_autocmd("User", {
        pattern = "VenvSelected",
        callback = function()
          local venv_path = require("venv-selector").get_active_venv()
          if not venv_path then
            return
          end

          local python = venv_path .. "/bin/python"
          local jupyter = venv_path .. "/bin/jupyter" -- ← pakai jupyter dari venv
          local kernel_name = vim.fn.fnamemodify(venv_path, ":t")

          -- Arahkan Molten ke jupyter milik venv
          vim.g.molten_jupyter_command = jupyter

          -- Register kernel
          vim.fn.jobstart({
            python,
            "-m",
            "ipykernel",
            "install",
            "--user",
            "--name",
            kernel_name,
            "--display-name",
            "Python (" .. kernel_name .. ")",
          }, {
            on_exit = function(_, code)
              if code == 0 then
                vim.schedule(function()
                  pcall(vim.cmd, "MoltenDeinit")
                  vim.cmd("MoltenInit " .. kernel_name)
                end)
              end
            end,
          })
        end,
      })
    end,
  },
}

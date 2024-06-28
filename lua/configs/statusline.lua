local config = {}

if pcall(require, "auto-session") then
  config["sections"] = {
    lualine_c = {
      require("auto-session.lib").current_session_name,
      "filename",
    },
  }
end

require("lualine").setup(config)

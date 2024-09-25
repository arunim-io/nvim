if nixCats("language-support.treesitter") then
	require("config.ls.treesitter")
end
if nixCats("language-support.lsp") then
	require("config.ls.servers")
end

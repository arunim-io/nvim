if nixCats("language-support.treesitter") then
	require("config.language-support.treesitter")
end
if nixCats("language-support.lsp") then
	require("config.language-support.servers")
end
if nixCats("language-support.completion") then
	require("config.language-support.completion")
end
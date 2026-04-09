local ok, javelin = pcall(require, "javelin")
if not ok then
	return
end

vim.api.nvim_create_user_command("Javelin", function()
	javelin.show_complexity()
end, {
	desc = "Show Go function complexity virtual text",
})

vim.api.nvim_create_user_command("JavelinClear", function()
	javelin.clear()
end, {
	desc = "Clear Javelin virtual text",
})

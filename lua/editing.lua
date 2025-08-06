local Editing = {}

function Editing.configure()
    require("autoclose").setup()
    require("nvim-surround").setup()
end

Editing.configure()

return Editing

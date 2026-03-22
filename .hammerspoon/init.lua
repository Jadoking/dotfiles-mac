-- Define Hyper modifiers
local hyper = {"alt", "ctrl", "shift"}

-- Define App Mode
local appMode = hs.hotkey.modal.new(hyper, "delete")

-- Exit App mode
appMode:bind({}, "escape", function()
  appMode:exit()
end)



-- Function to bind app keys inside modal
local function bindAppKey(key, appName)
  appMode:bind({}, key, function()
    hs.application.launchOrFocus(appName)
    appMode:exit()
  end)
end

bindAppKey("a", "Ghostty")
bindAppKey("s", "Vivaldi")
bindAppKey("d", "Spotify")
bindAppKey("/", "Finder")
bindAppKey("p", "iPhone Mirroring")
bindAppKey("c", "Discord")
bindAppKey("f", "Notion")
bindAppKey("v", "Todoist")
bindAppKey("m", "Blender")
bindAppKey("o", "Obsidian")
bindAppKey("l", "Line")
bindAppKey("z", "Zed")

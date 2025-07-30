-- Define Hyper modifiers
local hyper = {"alt", "ctrl", "shift"}

-- Define App Mode
local appMode = hs.hotkey.modal.new(hyper, "delete")

-- Exit App mode
appMode:bind({}, "escape", function()
  appMode:exit()
end)



local function focusApp(appName)
  local scriptPath = os.getenv("HOME") .. "/.hammerspoon/aerowin.sh"

  local task = hs.task.new(scriptPath,
    function(exitCode, stdOut, stdErr)
      print("Script exited with code:", exitCode)
      if stdOut and #stdOut > 0 then print("STDOUT:", stdOut) end
      if stdErr and #stdErr > 0 then print("STDERR:", stdErr) end
      return true
    end,
    { appName }
  )

  if not task:start() then
    print("Failed to start script:", scriptPath)
  end
end

-- Function to bind app keys inside modal
local function bindAppKey(key, appName)
  appMode:bind({}, key, function()
    pcall(function()
      focusApp(appName)
    end)
    appMode:exit()
  end)
end

bindAppKey("a", "Ghostty")
bindAppKey("s", "Zen")
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

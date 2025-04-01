-- Define Hyper modifiers
local hyper = {"cmd", "alt", "ctrl", "shift"}

-- Define App Mode
local appMode = hs.hotkey.modal.new(hyper, "space")

local function focusAppOnCurrentDisplay(appName, fallback)
  local app = hs.application.find(appName)
  if not app then
    if fallback then
      hs.alert("Launching " .. appName)
      hs.application.launchOrFocus(appName)
    else
      hs.alert("App not found: " .. appName)
    end
    return
  end

  local currentScreen = hs.mouse.getCurrentScreen()

  for _, win in ipairs(app:allWindows()) do
    local screen = win:screen()
    local isMatch = screen and (screen:getUUID() == currentScreen:getUUID())

    if win:isStandard() and isMatch then
      win:focus()
      return
    end
  end

  hs.alert("No " .. appName .. " window on this display")
end

-- Function to bind app keys inside modal
local function bindAppKey(key, appName)
  appMode:bind({}, key, function()
    pcall(function()
      focusAppOnCurrentDisplay(appName, true)
    end)
    appMode:exit()
  end)
end

bindAppKey("a", "Ghostty")
bindAppKey("s", "Zen")
bindAppKey("d", "Spotify")
bindAppKey("/", "Finder")
bindAppKey("x", "iPhone Mirroring")
bindAppKey("c", "Discord")


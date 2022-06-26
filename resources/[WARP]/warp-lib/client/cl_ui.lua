local registered = {}

function RegisterUICallback(name, cb)
  local function interceptCb(data, innerCb)
    cb(data, function(result)
      if result.meta.ok then
        result.meta.message = "done"
      end
      innerCb(result)
    end)
  end
  AddEventHandler(('_vui_uiReq:%s'):format(name), interceptCb)

  if (GetResourceState("warp-ui") == "started") then 
    exports["warp-ui"]:RegisterUIEvent(name) 
  end

  registered[#registered + 1] = name
end

function SendUIMessage(data)
  exports["warp-ui"]:SendUIMessage(data)
end

function SetUIFocus(hasFocus, hasCursor)
  exports["warp-ui"]:SetUIFocus(hasFocus, hasCursor)
end

function GetUIFocus()
  return exports["warp-ui"]:GetUIFocus()
end

AddEventHandler("_vui_uiReady", function()
  for _, eventName in ipairs(registered) do
    exports["warp-ui"]:RegisterUIEvent(eventName)
  end
end)

Void.Commands = Void.Commands or {}
Void.Commands.Registered = Void.Commands.Registered or {}

AddEventHandler("warp-base:exportsReady", function()
    addModule("Commands", Void.Commands)
end)

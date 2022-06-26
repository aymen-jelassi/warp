const registered = [];

function RegisterUICallback(name, cb) {
    AddEventHandler(`_vui_uiReq:${name}`, cb);

    if (GetResourceState('warp-ui') === 'started') exports['warp-ui'].RegisterUIEvent(name);

    registered.push(name);
}

function SendUIMessage(data) {
    exports['warp-ui'].SendUIMessage(data);
}

function SetUIFocus(hasFocus, hasCursor) {
    exports['warp-ui'].SetUIFocus(hasFocus, hasCursor);
}

function GetUIFocus() {
    return exports['warp-ui'].GetUIFocus();
}

AddEventHandler('_vui_uiReady', () => {
    registered.forEach((eventName) => exports['warp-ui'].RegisterUIEvent(eventName));
});
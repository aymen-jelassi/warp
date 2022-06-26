window.addEventListener('message',function(event){
    const action = event.data.action;
    const msg = event.data;
    switch (action) {	
        case "status-hud":
        if (msg.data.show == true) {
            $(".status-title").html("");
            $(".status-dealers").html("");
            $(".status-hand").html("");
            if (msg.data.title) {
                $(".status-title").append("<span>"+msg.data.title+"</span>");
            }
            if (msg.data.hand) {
                $(".status-hand").append("<span>"+msg.data.hand+"</span>");
            }
            if (msg.data.dealers) {
                $(".status-dealers").append("<span>"+msg.data.dealers+"</span>");
            }
            $("#container-status").show();
        }else{
            $(".status-title").html("");
            $(".status-dealers").html("");
            $("#container-status").hide();
        }
        break;
    default:
        return;
    }
})
$(document).ready(function() {
    CountdownMeter = new ProgressBar.Square("#countdownmeter", {
        color: "#4a4a4a",
        trailColor: "#ffffff",
        strokeWidth: 10,
        trailWidth: 10,
        duration: 250,
        easing: "easeInOut",
    });
});

window.addEventListener("message", function(event) {
    let data = event.data;
    
    if (data.countCheck == true) {
        $(".countdown").text(data.time);
        $(".countdown").fadeIn();
        $(".centertextwrapper").fadeIn();
        $(".heartwrapper").fadeIn();
        $(".respawnlable").hide();
    } else if (data.countCheck == false) {
        $(".centertextwrapper").fadeOut();
        $(".heartwrapper").fadeOut();
        $(".countdown").fadeOut();
        $(".respawnlable").fadeOut();
    }

    if (data.respawn == true) {
        $(".centertextwrapper").fadeIn();
        $(".countdown").fadeIn();
        $(".countdown").text(0);
        $(".heartwrapper").fadeIn();
        $(".respawnlable").fadeIn();
        $(".respawnlable").text(data.respawnInfo);
    } else if (data.respawn == false) {
        $(".centertextwrapper").fadeOut();
        $(".heartwrapper").fadeOut();
        $(".countdown").fadeOut();
        $(".respawnlable").fadeOut();
    }
});
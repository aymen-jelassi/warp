window.addEventListener('message', function(event) {
    if (event.data.type == 'open') {
        $('#adminmenu').fadeIn('fast')
    }
    if (event.data.type == 'close') {
        $('#adminmenu').fadeOut('fast')
    }
    if (event.data.type == 'evan_in_dev') {
        $('#developer-active').fadeIn('fast')
        $('#developer-inactive').fadeOut('fast')
    }
    if (event.data.type == 'evan_not_dev') {
        $('#developer-active').fadeOut('fast')
        $('#developer-inactive').fadeIn('fast')
    }
    if (event.data.type == 'evan_not_debug') {
        $('#debug-inactive').fadeOut('fast')
        $('#debugmode-active').fadeIn('fast')
    }
    if (event.data.type == 'evan_in_debug') {
        $('#debugmode-active').fadeIn('fast')
        $('#debug-inactive').fadeOut('fast')
    }
})

document.onkeydown = function(evt) {
    evt = evt || window.event;
    var isEscape = false;
    if ("key" in evt) {
        isEscape = (evt.key === "Escape" || evt.key === "Esc");
    } else {
        isEscape = (evt.keyCode === 27);
    }
    if (isEscape) {
      $('#adminmenu').fadeOut('fast');
      $.post('https://warp-admin/close');
    }
}

function pressButton(data) {
    $.post('https://warp-admin/buttonpress', JSON.stringify({id: data}));
}

function ReviveDist() {
    $.post('https://warp-admin/evan-rev-dist', JSON.stringify({}))
}
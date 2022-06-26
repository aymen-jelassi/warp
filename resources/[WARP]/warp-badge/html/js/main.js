$(document).ready(function(){
  window.addEventListener('message', function( event ) {
    if (event.data.action == 'open') {
      $('#rm_badge').show();
      $(".infos h4").text(event.data.grade);
      $(".infos h5").text(event.data.name);
      if(event.data.img == '0'){
        $("#imgdisplay1").attr("src", './assets/black.png');
      }else{
        $("#imgdisplay1").attr("src",event.data.img);
      }
    } else if (event.data.action == 'close') {
      $('#rm_badge').hide();
    }
  });
});

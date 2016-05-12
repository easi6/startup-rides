$(function() {
  $("input[type=file]").nicefileinput({label: "+ Add pitch file"});
});

$(window).scroll(function(){
  var topbar_height = 0;
  // Get container scroll position
  var fromTop = $(this).scrollTop() + topbar_height;
  var
    sticky_css = {
      "position":"fixed"
    },
    non_sticky_css = {
      "position":"relative"
    }

  if (fromTop > 370) {
    $('nav').css(sticky_css);
  } else {
    $('nav').css(non_sticky_css);
  }

});

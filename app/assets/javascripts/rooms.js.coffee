# Pjax links for room sidebar menu
$ ->
  $('#room-menu a:not(.leave)').pjax('#content').live 'click', () ->
    $('#room-menu a').removeClass('active')
    $(this).addClass('active')
    false

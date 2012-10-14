$(document).ready ->
  $b = $('body')
  if $b.data('organization') and $('#nav_cordion').length>0
    #$('#nav_cordion .collapse').collapse('hide')
    $('#nav_cordion #collapse_'+$b.data('organization')).collapse('show')
  $(document).pjax('a.p',
    container: '#content_wrapper'
  ).on 'pjax:end', ->
    $('a[title], h6[title], div[title], span[title]').tooltip()
  $('a[title], h6[title], div[title], span[title]').tooltip()

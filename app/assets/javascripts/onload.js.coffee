$(document).ready ->
  $b = $('body')
  if $b.data('organization') and $('#nav_cordion').length>0
    #$('#nav_cordion .collapse').collapse('hide')
    $('#nav_cordion #collapse_'+$b.data('organization')).collapse('show')
    

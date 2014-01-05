# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
attach_editor = (sf_elem) ->
  elem = $(sf_elem).find('.ace_editor_wrapper')
  lexer = elem.data('lexer')
  id = elem.data('id')
  id = Math.random().toString(36).substring(7) unless id
  id = "sf"+id
  editor_div = $(elem.children()[0])
  unless editor_div.attr('id')
    editor_div.attr('id', id)
    editor = ace.edit(id)
    editor.getSession().setMode("ace/mode/plain_text")
    editor.resize()
    editor.getSession().setUseWrapMode(true)
    window.editors[id] = editor

$ ->
  if $('body').hasClass 'scraps'
    $('#scrap_form .single_files_wrapper .fields').each (idx, elem)->
      attach_editor(elem)
    $('#scrap_form').on 'submit', ->
      for own id, editor of window.editors
        textarea = $('.ace_textarea #'+id).parents('.ace_textarea').children('textarea')
        textarea.val editor.getValue()
      true
    $(document).on 'nested:fieldAdded:single_files', (event)->
      field = event.field
      attach_editor(field)


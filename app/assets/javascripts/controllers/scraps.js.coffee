# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
attach_editor = (sf_elem) ->
  elem = $(sf_elem).find('.ace_editor_wrapper')
  id = elem.data('id')
  unless id
    id = Math.random().toString(36).substring(7)
    elem.data('id', id)
  id = "sf"+id
  editor_div = $(elem.children()[0])
  unless editor_div.attr('id')
    editor_div.attr('id', id)
    editor = ace.edit(id)
    editor.resize()
    editor.getSession().setUseWrapMode(true)
    editor.setReadOnly(true) if elem.data('read-only')
    window.editors[id] = editor
    set_lexer(elem)

set_lexer = (wrapper) ->
  wrapper = $(wrapper)
  id = 'sf'+wrapper.data('id')
  editor = window.editors[id]
  file_name = wrapper.data('file-name')
  lexer = wrapper.data('lexer')
  if lexer
    editor.getSession().setMode("ace/mode/"+lexer)
  else
    modelist = ace.require('ace/ext/modelist')
    mode = modelist.getModeFromPath(file_name).mode
    editor.getSession().setMode(mode)

$ ->
  setup_ace()
  $(document).on 'pjax:end', ->
    setup_ace()

setup_ace = ->
  form = $('#scrap_form')
  if form.length > 0
    $('#scrap_form .single_files_wrapper .fields').each (idx, elem)->
      attach_editor(elem)
    form.on 'submit', ->
      for own id, editor of window.editors
        textarea = $('.ace_textarea #'+id).parents('.ace_textarea').children('textarea')
        textarea.val editor.getValue()
      true
    $(document).on 'nested:fieldAdded:single_files', (event)->
      field = event.field
      attach_editor(field)
    $('#scrap_form').on 'change', '.lexer_name', ->
      $this = $(this)
      $wrapper = $this.parents('.fields').find('.ace_editor_wrapper')
      id = $wrapper.data('id')
      editor = window.editors['sf'+id]
      editor.getSession().setMode("ace/mode/"+$this.val())

  else
    $('.ace_editor_wrapper').each (idx, elem)->
      attach_editor($(elem).parent())



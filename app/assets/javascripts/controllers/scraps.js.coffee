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
    mode = get_modelist().getModeForPath(file_name).mode
    editor.getSession().setMode(mode)

$ ->
  setup_ace()
  $(document).on 'pjax:end', ->
    setup_ace()

setup_ace = ->
  get_modelist()
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
      $this.data('dirty', true)
      $wrapper = $this.parents('.fields').find('.ace_editor_wrapper')
      id = $wrapper.data('id')
      editor = window.editors['sf'+id]
      editor.getSession().setMode("ace/mode/"+$this.val())
    $('#scrap_form').on 'keyup', '.scrap_name', ->
      $this = $(this)
      $parent = $this.parents('.fields')
      $select = $parent.find('.lexer_name')
      unless $select.data('dirty')
        $wrapper = $parent.find('.ace_editor_wrapper')
        id = $wrapper.data('id')
        editor = window.editors['sf'+id]
        mode = get_modelist().getModeForPath($this.val()).mode
        if mode
          mode_split = mode.split('/')
          if mode_split.length == 3
            $select.val(mode_split[2])
          editor.getSession().setMode(mode)

  else
    $('.ace_editor_wrapper').each (idx, elem)->
      attach_editor($(elem).parent())

get_modelist = ->
  unless window.modelist
    window.modelist = ace.require('ace/ext/modelist')
  window.modelist



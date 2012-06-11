# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
      $('[class^=mcoc_asset]').click( ->
          form = this.form
          $(form).append(
                  $('<input/>')
                      .attr('type', 'hidden')
                      .attr('name', 'handle_delete_additional_attachment')
                      .val('Y')
              )
          
          $.post(
             $(form).attr('action')
             $(form).serialize()
             processDeleteRequest
          )
          return false
      )
processDeleteRequest = (data,  textStatus, jqXHR) ->
      $('#additional_asset_delete_message').html('<p>Attachment deleted.</p>')
  
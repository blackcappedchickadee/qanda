$ ->
  $('#clear_attachment_ude').click( ->
      form = this.form
      $.post(
         $(form).attr('action')
         $(form).serialize()
         processDeleteRequest
      )
      return false
  )
processDeleteRequest = (data,  textStatus, jqXHR) ->
      $('#ude_current_report').html('')
      $('#ude_upload_text').html('<p>Instructions: Browse to your UDE Completeness Report, then click \'Attach UDE Completeness Report\'.</p>')


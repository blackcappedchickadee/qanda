$ ->
  $('#clear_attachment_ude').click( ->
      form = this.form
      $.post(
         $(form).attr('action')
         $(form).serialize()
         processDeleteRequestForUDE
      )
      return false
  )
  
$ ->
  $('#clear_attachment_apr').click( ->
      form = this.form
      $.post(
         $(form).attr('action')
         $(form).serialize()
         processDeleteRequestForAPR
      )
      return false
  )
processDeleteRequestForUDE = (data,  textStatus, jqXHR) ->
      $('#ude_current_report').html('')
      $('#ude_upload_text').html('<p>Instructions: Browse to your UDE Completeness Report, select the file, then click \'Upload\'.</p>')
      
processDeleteRequestForAPR = (data,  textStatus, jqXHR) ->
      $('#apr_current_report').html('')
      $('#apr_upload_text').html('<p>Instructions: Browse to your APR Report, select the file, then click \'Upload\'.</p>')



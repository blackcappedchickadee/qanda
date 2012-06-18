$ ->
  $('#clear_attachment_ude').click( ->
      form = this.form
      alert('form = ' + form)
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
  
$ -> 
  $('#ude_attach_report').click( ->
      form = this.form
      alert(form)
      $('#loading_ude').show()
      $.post(
         $(form).attr('action')
         $(form).serialize()
         processUploadRequestForUDE
      )
      return false
   )

processUploadRequestForUDE = (data, textStatus, jqXHR) ->
      $('#loading_ude').hide()
   
processDeleteRequestForUDE = (data,  textStatus, jqXHR) ->
      $('#ude_current_report').html('')
      $('#ude_upload_text').html('<p>Instructions: Browse to your UDE Completeness Report, select the file, then click \'Upload\'.</p>')
      
processDeleteRequestForAPR = (data,  textStatus, jqXHR) ->
      $('#apr_current_report').html('')
      $('#apr_upload_text').html('<p>Instructions: Browse to your APR Report, select the file, then click \'Upload\'.</p>')



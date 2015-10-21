#perform JavaScript after the document is scriptable.
$(document).ready(->

  # /**
  #  * Skin select elements
  #  */
  $('select').each(->
    select = this
    $(this).attr('size',$(this).find('option').length+1).wrap('<span class="ui-select" />')
      .before('<span class="ui-select-value" />')
      .bind('change, click', ->
        $(this).hide().prev().html($(this).find('option:selected').text())
      )
      .after('<a class="ui-select-button button button-gray"><span></span></a>')
      .next().click( ->
        if ($(select).toggle().is(':visible')) 
         $(select).focus()

        false
      )
      .prev().prev().html($(this).find('option:selected').text())
      .click( ->
        if ($(select).toggle().is(':visible')) 
          $(select).focus()
        
        false
      )
    $(this).blur( -> 
      $(this).hide()
    ).parent().disableSelection()
  )

  # /**
  #  * Skin file input elements
  #  */
  $(':file').each( ->
    file = this
    $(this).attr('size', 25).wrap('<span class="ui-file" />')
      .before('<span class="ui-file-value">No file chosen</span><button class="ui-file-button button button-gray">Browse...</button>')
      .change( ->
        $(file).parent().find('.ui-file-value').html( if $(this).val() then $(this).val() else 'No file chosen')
      )
      .hover(
        ->
          $(file).prev().addClass('hover')
        ->
          $(file).prev().removeClass('hover')
      ).mousedown(->
        $(file).prev().addClass('active')
      )
      .bind('mouseup mouseleave', ->
        $(file).prev().removeClass('active')
      )
      .parent().disableSelection()
  )

  geocoder = new Map.geocoder()
  $('#voice_location').change(->
    geocoder.geocode({address: this.value}, (results, statusResponse) ->
      if statusResponse is "OK" and results and not results[0].partial_match
        $('#voice_latitude').val(results[0].geometry.location.lat())
        $('#voice_longitude').val(results[0].geometry.location.lng())
      else
        $('#voice_latitude, #voice_longitude').val('')    
    )
  )
  
  $('.section-btn').click( ->
    $(this).next('div').toggle()
  )
  
  $('.location-tabs li').click( ->
    $('.location-tabs li').removeClass('selected')
    $(this).addClass('selected')
    Tab = $(this).attr("data-tab")
    $('.tab-option').addClass('hide-panel')
    $(Tab).removeClass('hide-panel')  
  )
  
  $('.ask-me').hover(
     ->
       $(this).parent().next('.answere').fadeIn('fast')
     ->
       $(this).parent().next('.answere').fadeOut('fast')
  )

)

Class('FacesPanel')({
  addAvatar: (uid, url, name) ->
    item = $('<li />').attr('data-uid', uid).addClass('grid-item').append('<img src="' + url + '" title="' + name + '" />')
    $('.connections_grid').append(item)

    if $('.connections_grid li').length > 0
      $('.facebook-container').removeClass('no-fb-face')
      $('.fb-arrow-cont').show()
      $('.connections_grid').show()
      $('.fb-button').show()
      $('.fb-btn-cont').hide()

  destroyAvatar: (uid) ->
    $('.connections_grid li[data-uid=' + uid + ']').remove()

    if $('.connections_grid li').length == 0
      $('.facebook-container').addClass('no-fb-face')
      $('.fb-arrow-cont').hide()
      $('.connections_grid').hide()
      $('.fb-button').hide()
      $('.fb-btn-cont').show()

  prototype: {
    init: ->
      @element = $('.connections_grid')
      @fbContainer = $('.facebook-container')
      @arrowContainer = $('.fb-arrow-cont')
      @squareContainer = $('.fb-btn-cont')
      @fbBtn = $('.fb-button')
      @arrow = $('.fb-arrow')
      @expanded = false
      @_countFaces()
      @_bindEvents()

    _bindEvents: ->
      @arrow.click =>
        if $('.connections_grid li').length > 0
          @toggle()
        
        false
      
    _countFaces: ->
      if @element.children().size() == 0
        @fbContainer.addClass('no-fb-face')
        @arrowContainer.hide()
        @element.hide()
        @fbBtn.hide()
        @squareContainer.show()
      else
        @fbContainer.removeClass('no-fb-face')
        @arrowContainer.show()
        @element.show()
        @fbBtn.show()
        @squareContainer.hide()

    toggle: ->
      if @expanded
        @element.css({ height: '' })
        @expanded = false
      else
        @element.css({ height: 'auto' })
        @expanded = true
      
      @arrow.toggleClass('fb-arrow fb-arrow-open')
  }
})
Class('SlideSection')({
  slides: []

  closeAll: ->
    for slide in slides
        @slide.close()
    undefined

  prototype: {
    init: (element, section) ->
      @element = if typeof element is 'string' then $(element) else element
      @section = if typeof section is 'string' then $(section) else section

      @_bindEvents()
      @constructor.slides.push(this)
    
    _bindEvents: ->
      @element.click =>
          @toggle()
          false

      @section.find('.cancel').click =>
          @close()
          false
    
    open: ->
        @constructor.closeAll()
        @section.slideDown('slow')
    
    close: ->
        @section.slideUp('slow')

    toggle: ->
      if @section.is(':visible') then @close() else @open()
    }
});

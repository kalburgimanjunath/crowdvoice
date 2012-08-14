Class('VideoOverlay')({
  prototype: {
    init: (element, options) ->
      @options = {
        overlay : '#overlay',
        overlayContainer : '.vide-overlay-container',
        closeBtn : '.close-voice-container'
      }
      @element = if typeof element is 'string' then $(element) else element
      @overlay = $(@options.overlay)
      @overlayContainer = $(@options.overlayContainer)
      @win = $(window)
      @closeBtn = $(@options.closeBtn)
      @_bindEvents()

    _bindEvents: ->
      @element.click =>
        @buildOverlay()

      @overlay.click =>
        @hide()

      @closeBtn.click =>
        @hide()

    buildOverlay: ->
      $('body').css('overflow-y', 'hidden')
      @showTopOverlay()
    
    showTopOverlay: ->
      @overlay.css('top', $(document).scrollTop()).fadeIn()
      @show()
        
    show: ->
      top = (@win.height() - @overlayContainer.height()) / 2
      left = (@win.width() - @overlayContainer.width()) / 2
      
      @overlayContainer.css({
        'top': top + $(document).scrollTop(),
        'left': left
      }).show()

    hide: ->
      $('body').css('overflow-y', 'auto')
      @overlayContainer.fadeOut('slow')
      @overlay.fadeOut('slow')
  }
});
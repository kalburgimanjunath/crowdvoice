Class('Message')({
  prototype : {
    init : (element, options) ->
      @options = {
        closeBtn : '.close-message',
        effect   : true
      }
      $.extend(@options, options)
      @element = if typeof element is 'string' then $(element) else element
      @closeBtn = $(@options.closeBtn)
      @_bindEvents()

    _bindEvents: ->
      closeBtn = @element.children().children(@options.closeBtn)
      
      closeBtn.click =>
        @hide()
        false

    hide: ->
      if @options.effect
        @element.fadeOut =>
          @element.trigger('flash.close')
      else 
        @element.hide() and @element.trigger('flash.close')
  }
});
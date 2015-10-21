Class('Treshold')({
  prototype: {
    init: (element, options) ->
      @options = {
        container: '#voiting-treshold',
        maxInput: '#max-value',
        minInput: '#min-value'
      }
      
      $.extend(@options, options)
      
      @element = if typeof element is 'string' then $(element) else element
      @container = $(@options.container)
      @maxInput = $(@options.maxInput)
      @minInput = $(@options.minInput)
      @rangeSlider = $('<div></div>').slider({
        min: -10, 
        max: 10, 
        step: 1, 
        values: [@minInput.val(), @maxInput.val()], 
        range: true,
        animate: true,
        slide: (e,ui) ->
          $('#min').val(minimo)
          $('#max').val(maximo)
           
          if ui.values[0] > -1 or ui.values[1] < 1
            ui.stop()
         
          @maxInput.val(ui.values[ 1 ])
          @minInput.val(ui.values[ 0 ])
        })
 
      @_bindEvents()

    _bindEvents: ->
      @container.after(@rangeSlider).hide()

  }
})
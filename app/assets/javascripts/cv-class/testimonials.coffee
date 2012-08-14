Class('Testimonial')({
  prototype: {
    init: (element, options) ->
      @options = {
        step: 1,
        current: 0,
        visible: 3,
        speed: 500,
        liSize: 219,
        carouselHeight: 276
      }
      $.extend(@options, options);
      @element = if typeof element is 'string' then $(element) else element
      @container = @element
      @list = @element.children('ul')
      @listSize = @list.children('li').size()
      @ulSize = @options.liSize * @listSize
      @divSize = @options.liSize * @options.visible
      @carouselHeight = @options.carouselHeight
      @step = @options.step
      @current = @options.current
      @visible = @options.visible
      @speed = @options.speed
      @liSize = @options.liSize
      @_bindEvents()

    _bindEvents: ->
      container = @container
      list = @list
      listSize = @listSize
      ulSize = @ulSize
      divSize = @divSize
      carouselHeight = @carouselHeight
      current = @current
      liSize = @liSize
     
      container.css("width", "625px")
      .css("margin", "0px auto")
      .css("height", carouselHeight+"px")
      .css("visibility", "visible")
      .css("overflow", "hidden")
      .css("position", "relative")
      
      list.css("width", ulSize+"px")
      .css("left", -(current * liSize))
      .css("position", "absolute")
      
      @element.prev().children('.cite-slide-right-arrow').click =>
        @_moveRight()

      @element.prev().prev().children('.cite-slide-left-arrow').click =>
        @_moveLeft()

      undefined

    _moveRight: ->
      if @current + @step < 0 or @current + @step > @listSize - @visible
        return
      else
        @current = @current + @step
        @list.animate({left: -(@liSize * @current)}, @speed, null)

      false

    _moveLeft: ->
      if @current - @step < 0 or @current - @step > @listSize - @visible
        return
      else
        @current = @current - @step;
        @list.animate({left: -(@liSize * @current)}, @speed, null)

      false
  }
});

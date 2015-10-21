Class('Discuss')({
  prototype: {
    init: (element, options) ->
      @options = {
        discussArea:     '.discuss'
        tab:             '.discuss-tab'
        discussContiner: '.discuss-container'
      }

      $.extend(@options, options)
      @element = if typeof element is 'string' then $(element) else element

      @discussArea = $(@options.discussArea)
      @tabs = $(@options.tab)
      @discussContiner = $(@options.discussContiner)
      @open = false
      @_bindEvents()

    _bindEvents: ->
      area = @discussArea

      @tabs.click =>
        if not @open
          @show()
          @_showContainer($(this))
        else
          if not $(this).parent().is('.front')
            @_showContainer($(this))

      @discussContiner.hover (
        ->
          $(this).prev().children().addClass('hover-tab')
        
        ->
          $(this).prev().children().removeClass('hover-tab')
      )
      
      $('.close-discuss, .close-btn-control').click =>
         @hide()
      
      $('.close-btn-control').hover(
        ->
          $(this).prev().addClass('hover-close-bar')
        
        ->
          $(this).prev().removeClass('hover-close-bar')
      )

      $('.close-discuss').hover(
        ->
          $(this).next().addClass('hover-btn-control')
        
        ->
          $(this).next().removeClass('hover-btn-control')
      )

      $('.tweets-list > li:odd').css('float', 'right')
      
    show: ->
      @discussArea.animate({
        height: '250px'
      }, 300)
      $('.discuss').addClass('openTabs')
      $('.pagination').css('margin-bottom', '220px')
      @open = true

    hide: ->
      @discussArea.animate({
        height: '35px'
      }, 300)
      $('.discuss').removeClass('openTabs')
      $('.pagination').css('margin-bottom', '0px')
      @open = false

    _showContainer: (tab) ->
      if not tab.hasClass('back')
        tab.parent().siblings().addClass('back')

      tab.parent().siblings().removeClass('front')
      tab.parent().removeClass('back')
      tab.parent().addClass('front')

  }##prototype
})
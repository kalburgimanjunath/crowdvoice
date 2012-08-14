Class('SidebarToggler')({
  prototype: {
    init: ->
      @element = $('.tab-controller')
      @closeWidth = 5
      @openWidth = 268
      @open = true
      @postInput = $('.post > input')
      @aside = $('.voice')
      @_bindEvents()

    _bindEvents: ->
      $('.tab-controller').click =>
        @toggle()

    toggle: ->
      if @open then @hide() else @show()

    show: ->
      tcurrentLeft = parseInt($('.tweets').css('left')) - 169
      fbcurrentLeft = parseInt($('.fbcomments').css('left')) - 169
      excerpt = parseInt( $('.voice-subtitle').css('padding-right') ) + 268
      
      postWidth = @postInput.width()
      postOpen = postWidth - @openWidth + @closeWidth
      $('.voice').animate({ width: @openWidth }, 300)
      $('hgroup').animate({ width: @openWidth - 1 }, 300)
      $('.tweets').css("left", tcurrentLeft)
      $('.fbcomments').css("left", fbcurrentLeft)
      $('.panel-padding').animate({ marginLeft: @openWidth }, 300)
      $('.voice-subtitle').css('padding-right', excerpt + 'px')
      @postInput.animate({ width: postOpen }, 300)
      @element.animate { left: @openWidth }, 300, ->
        $(this).removeClass('close-control')
        $(this).trigger('sidebar.toggle')
        DynamicMeasures.update()
      @open = true

    hide: ->
      tcurrentLeft = parseInt($('.tweets').css('left')) + 169
      fbcurrentLeft = parseInt($('.fbcomments').css('left')) + 169
      excerpt = parseInt( $('.voice-subtitle').css('padding-right') ) - 268
      postWidth = @postInput.width()
      postClose = postWidth + @openWidth - @closeWidth

      $('.voice').animate({ width: @closeWidth }, 300)
      $('hgroup').animate({ width: @closeWidth - 1}, 300)
      $('.tweets').css("left", tcurrentLeft)
      $('.fbcomments').css("left", fbcurrentLeft)           
      $('.panel-padding').animate({ marginLeft: @closeWidth }, 300)
      $('.voice-subtitle').css('padding-right', excerpt + 'px')
      @postInput.animate({ width: postClose }, 300)
      @element.animate { left: @closeWidth }, 300, ->
        $(this).addClass('close-control')
        $(this).trigger('sidebar.toggle')
        DynamicMeasures.update()
      @open = false
      tcurrentLeft = parseInt($('.tweets').css('left')) + 169
      fbcurrentLeft = parseInt($('.fbcomments').css('left')) + 169
  }
});
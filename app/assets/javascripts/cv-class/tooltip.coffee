Class('Tooltip')({
  prototype: {
    init: (element, options) ->
      @element = if typeof element == 'string' then $(element) else element
      @tooltip = @element.find('.tooltip')
      @_get_tooltip_name()
      @_hoverTooltip()
      @_mapClick()
      @_moderatorClick()
      @_publicClick()
      @_hide_extra_data()

    _get_tooltip_name: ->
      @tooltip_name = ''

      if @element.find('a.media-type').attr('title') isnt undefined
        @tooltip_name = @element.find('a.media-type').attr('title').toLowerCase()
      
    _hoverTooltip: ->
      _this = this;
      @element.hover(
        (e) ->
          if $(this).is('.selected')
            _this.tooltip.hide();
          else if $(this).is('.addVoice')
            $(this).find('.tooltip').show()
          _this.show()

        ->
        _this.detectContent()
      )

      @tooltip.children().children('.media-type-info').mouseleave =>
        @detectContent()
      
      @tooltip.children().children('form').mouseleave =>
        @detectContent()

    _hide_extra_data: ->
      switch @tooltip_name
        when 'image'
          @element.find('.with-image').hide()
          @element.find('.without-image').show()
          
        when 'link'
          @element.find('.without-link').show()
          @element.find('.with-link').hide()

    _show_extra_data: ->
      if  $('#post_source_url').val() isnt ''
        switch @tooltip_name
          when 'image'
            @element.find('.without-image').hide()
            @element.find('.with-image').show()
            
          when 'link'
            @element.find('.without-link').hide()
            @element.find('.with-link').show()
            
    _mapClick: ->
     _this = this
     @element.children('a').click ->
       if $(this).is('.map-btn')
         _this.hide();
         _this.tooltip.children().children().children('strong').text('Hide Voices on the Map')
       
       if $(this).is('.map-active')
         _this.hide()
         _this.tooltip.children().children().children('strong').text('Show Voices on the Map')

    _moderatorClick: ->   #functionality for moderate public items view
     _this = this
     @element.children().children('a').click ->
       if $(this).parent().parent().is('.mod')
         _this.tooltip.children().children().children('strong').text('')
         _this.tooltip.children().children().children('p').html('<span>Thank you! The page is refreshing with unmoderated posts!</span>')
       
    _publicClick: ->   #functionality for moderate public items view
     _this = this
     @element.children().children('a').click ->
       if $(this).parent().parent().is('.public')
        _this.tooltip.hide()
        tt_moderate.tooltip.children().children().children('strong').text('Participate!')
        tt_moderate.tooltip.children().children().children('p').html('<span>Help us approve images, videos and external links.</span> Flag any content that you feel should not be posted here.');

    detectContent: ->
      if $.inArray(@tooltip_name, ['image','video','link'] ) >= 0 and $('#post_source_url').val() isnt '' and $('.media > a.active').length is 1 and not $('.tooltip.notice').is(':visible')
        @tooltip.parent().css('z-index', 10)
      else
        @hide()

    show: ->
      $('a', @element).addClass('active')

      if typeof(Post) isnt 'undefined'

        if Post.isVideo($('#post_source_url').val()) and $('a', @element).hasClass('active') and @tooltip_name is 'video'
          false

        if ( Post.isImage($('#post_source_url').val()) or ($('#post_source_url').val() isnt '') ) and $('#post_source_url').val() isnt '' and $('a', @element).hasClass('active') and @tooltip_name is 'image'
          @_show_extra_data()

        if Post.isLink($('#post_source_url').val()) and $('#post_source_url').val() isnt '' and $('a', @element).hasClass('active') and @tooltip_name is 'link'
          @_show_extra_data()

      @tooltip.show()

    hide: ->
      @tooltip.hide()

      if $('.media > a.active').length is 1 and $.inArray(@tooltip_name, ['image','video','link'] ) >= 0
        @_hide_extra_data()
        @tooltip.parent().css('z-index', 5)

      $('a', @element).removeClass('active')
  }
});

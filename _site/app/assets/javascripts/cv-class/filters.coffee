Class('Filters')({
  prototype: {
    init: (element, items) ->
      @element = if typeof element is 'string' then $(element) else element
      @filters = @element.find('input:checkbox')
      @items = if typeof items is 'string' then $(items) else items
      @toggleModerate = $('.mode-button')
      @_bindEvents()
      if not $.deparam.querystring().mod
        @deactivateModerator()


    _bindEvents: ->
      @filters.click =>
        self = this
        checked = @filters.filter(':checked')
        href = ''

        if checked.length > 0
          filters = $('.filters input:checkbox:checked').map(
            -> 
              $(this).attr('name')
          ).get().join(',')

          href = location.href.split('?')[0].replace('#', '') + '/?filters=' + filters
        else
          href = location.href.split('?')[0].replace('#', '')
      
        $.getScript href, =>
            @filter self.name, $(self).is(':checked')


    toggleModerator: (flag) ->
      if flag then @activateModerator() else @deactivateModerator()

    activateModerator: ->
      @moderator = true
      @toggleModerate.filter('.public').removeClass('selected')
      @toggleModerate.filter('.mod').addClass('selected')
      $('.voices-container').isotope({ filter: @_buildFilterSelector() })
    
    deactivateModerator: ->
      @moderator = false
      @toggleModerate.filter('.public').addClass('selected')
      @toggleModerate.filter('.mod').removeClass('selected')
      $('.voices-container').isotope({ filter: @_buildFilterSelector() })
    
    filter: (filter, show) ->
      $('.voices-container').isotope({ filter: @_buildFilterSelector() })
    
    _buildFilterSelector: ->
      checked = @filters.filter(':checked')
      selector = '*'
      that = this
      
      if checked.length == 0
        checked = @filters.attr('checked', true)
      
      selector = checked.map( ->
        if that.moderator
          '.voice-box.' + @name
        else
          '.voice-box:not(.unmoderated).' + @name  
      ).get().join(', ')

      selector

    _fetchPage: (href) ->
      $.getScript(href)

  }
})

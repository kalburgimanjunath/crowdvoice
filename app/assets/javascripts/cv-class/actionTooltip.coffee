Class('ActionTooltip')({
    prototype:{
      init: (element, options) ->
        @element = if typeof element is 'string' then $(element) else element
        @tooltip = @element.find '.tooltip'
        @_get_tooltip_name @element
        @_hoverTooltip()

      _get_tooltip_name: (element) ->
        @tooltip_name = ''
        flagData = element.find('.flag-tip').attr('data-post-id')
        thumbData = element.find('.thumb-tip').attr('data-post-id')

        if flagData?
          @tooltip_name = flagData

        if @tooltip_name is '' and thumbData?
          @tooltip_name = thumbData

      _hoverTooltip: ->
        @element.hover(
          ##first parameter
          (e) =>
            @_get_tooltip_name $ e.currentTarget
            @show()
          ##second parameter
          =>
            @hide()
        )

      show: ->
        isUnmoderated = @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').parent().parent().parent().hasClass('voice-unmoderated')

        if isUnmoderated
          @tooltip.filter('.thumb-tip[data-post-id='+@tooltip_name+']').show();
        else
          if not @tooltip.filter('.flags-tip[data-post-id='+@tooltip_name+']').siblings('a').hasClass('flag-pressed') and not isUnmoderated
            @tooltip.filter('.flags-tip[data-post-id='+@tooltip_name+']').siblings('a').addClass('flag-over').removeClass('flag')

          @tooltip.filter('.flag-tip[data-post-id='+@tooltip_name+']').show()

        @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').parent().parent().parent().addClass('bring-up').parent().addClass('bring-up')

      hide: ->
        element = @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').siblings('a')
        parent = @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').parent().parent().parent()
        isUnmoderated = parent.hasClass('voice-unmoderated')

        if not element.hasClass('flag-pressed') and not isUnmoderated
            @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').siblings('a').addClass('flag').removeClass('flag-over')
        

        if @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').find('.flag-tooltip span').html() == 'Thank you for your vote!'
            @tooltip.filter('.tooltip[data-post-id='+@tooltip_name+']').find('.flag-tooltip span').html("Vote already cast")

        @tooltip.hide()
        parent.removeClass('bring-up').parent().removeClass('bring-up')
    }
})
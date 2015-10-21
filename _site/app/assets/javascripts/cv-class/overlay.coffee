Class('Overlay')({
  prototype: {
    init: (element, options) ->
      @options = {
        overlay : '#overlay'
        overlayContainer : '.overlay-container'
        linkOverlayContainer : '.link-overlay'
        arrows : '.arrows'
        closeBtn : '.close-voice-container'
        content : { }
      }

      $.extend(@options, options)
      @overlay = $(@options.overlay)
      @overlayContainer = $(@options.overlayContainer)
      @linkOverlayContainer = $(@options.linkOverlayContainer)
      @overlayTemplate = @overlayContainer.html()
      @linkOverlayTemplate = @linkOverlayContainer.html()
      @win = $(window)
      @_elementSelector = element
      @_initZeroClipboard()
      @_bindEvents()
      @_alignMagnifier()
    

    _initZeroClipboard: ->
      ZeroClipboard.setMoviePath( '/javascripts/ZeroClipboard10.swf' )
      @zeroclip = new ZeroClipboard.Client()
      @zeroclip.addEventListener 'onMouseDown', =>
        @zeroclip.setText( $('.link-overlay iframe').attr('src') )
      
      @zeroclip.addEventListener 'complete', (client,text) ->
        alert('copied!')
    
    unbindEvents: ->
      @element.find('.voice-cont').unbind('click')
      @element.find('.comments').unbind('click')
      this

    bindEvents: ->
      _this = this
      @element = $(@_elementSelector)
      @element.find('.voice-cont').click ->
        _this.buildOverlay($(this).find('.source-url'))
        false

      @element.find('.comments').click ->
        _this.buildOverlay($(this).parent().prev().find('.source-url'))
        false

    _bindEvents: ->
      @bindEvents()

      $(@options.closeBtn).live 'click', =>
        @hide()
        false

      @overlay.click =>
        @hide()

      $('body').bind 'keydown', (ev) =>
        if ev.keyCode == 27 && @visible
          @hide()

      $('.voice-cont').css('margin-top', '0', 'margin-left', '0')

      $('.voice-arrow')
      .live 'mouseover', ->
        $(this).next('.tooltip-arrow').show()
      .live 'mouseout', ->
        $(this).next('.tooltip-arrow').hide()
      .live 'click', ->
        _this.buildOverlay($('.source-url.post-' + $(this).data('id')))
        false

      $('.back-to-voice span').live 'click', =>
        @_hideLinkOver()

      $('.toggle-comments').live 'click', =>
        @_toggleComments()

    _showLinkOver: ->
      winHeight = $('body').height()
      
      $('body').css('overflow-y', 'hidden').css({position: 'fixed', width: '100%'}).delay(500).animate({marginTop: winHeight + 'px'}, 500)
      
      $('.link-overlay').delay(200).slideDown =>
        @zeroclip.glue('d_clip_button', 'd_clip_container')
        $('.copy-url div').hover(
          ->
            $(this).css('cursor', 'pointer')
            $(this).prev('a').addClass('clipboard-btn')

          ->
            $(this).prev('a').removeClass('clipboard-btn')
        )

      $('.voice').css({position: 'relative'})
      $('.tab-controller').hide()

    _hideLinkOver: (callback) ->
      $('.link-overlay').slideUp('1000')
      $('body').animate {marginTop: '0px'}, 500, ->
        $(this).css('overflow-y', 'hidden').css({position: 'relative', width: '100%'})
        $('.voice').css({position: 'fixed'})
        $('.tab-controller').show()
        if $.isFunction(callback) 
          callback()

    _toggleComments: ->
      messages = $('.comment-zone-border')

      if messages.height() == 0
        messages.animate({
          height: '170px'
        }, 500)
      else
        messages.animate({
          height: '0px'
        }, 500)

    _alignMagnifier: ->
      @element.each ->
        hover = $(this).children().children().children('span')
        imageHeight = $(this).find('.thumb-preview').height()
        imageWidth = $(this).find('.thumb-preview').width()
        
        hover.css({
          'margin-top' : ( imageHeight / 2 ) - 21,
          'margin-left' : ( imageWidth / 2 ) - 21
        })

    _getData: (e) ->
      data = {}
      index = $('.voice-box:not(.isotope-hidden)').index(e.closest('.voice-box'))
      prev = $('.voice-box:not(.isotope-hidden):lt('+index+')').last()
      next = $('.voice-box:not(.isotope-hidden):gt('+index+')').first()

      data.title = e.data('title')
      data.ago = e.data('ago')
      data.href = e.attr('href')
      data.voice_slug = window.currentVoice.slug
      data.post_id = e.data('id')
      data.type = e.data('type')
      data.permalink = e.data('permalink')
      data.voted = e.data('voted')
      data.service = e.data('service')

      if prev.length
        data.prev = {
          image: prev.find('.voice-cont > a > img').attr('src'),
          title: prev.find('.voice-cont > a').data('title'),
          id: prev.find('.voice-cont > a').data('id')
        }

      if next.length
        data.next = {
          image: next.find('.voice-cont > a > img').attr('src'),
          title: next.find('.voice-cont > a').data('title'),
          id: next.find('.voice-cont > a').data('id')
        }

      data

    buildOverlay: (e) ->
      data = @_getData(e)
      $('body').css('overflow-y', 'hidden')
      @showTopOverlay()
      @_replaceContent(data)

    _replaceContent: (data) ->
      content = unescape (if data.type is 'link' then @linkOverlayTemplate else @overlayTemplate)
      width = 0
      maxWidth = parseInt($(document).width() * 0.80)
      maxHeight = parseInt($(window).height() * 0.80) - 150

      content = content.replace(/{{title}}/g, data.title)
      content = content.replace(/{{escaped_title}}/g, encodeURIComponent(data.title))
      content = content.replace(/{{time_ago}}/g, data.ago)
      content = content.replace(/{{source_url}}/g, data.href)
      content = content.replace(/{{voice_slug}}/g, data.voice_slug)
      content = content.replace(/{{post_id}}/g, data.post_id)
      content = content.replace(/{{rating}}/g, data.voted ? 1 : -1)

      if data.type == 'link'
        winHeight = $('body').height()
        @hide()
        @_onContentLoaded(content, $(document).width(), data)

      else
        @timeoutRequest = setTimeout ->
          $.post(
            '/notify_js_error',
            {e: 'There were a problem loading an embedly resource.', data: data},
            (data) ->,
            60000
          )

        $.embedly data.href, {
            key: 'a7a764a2bbc511e0902d4040d3dc5c07',
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            urlRe: new RegExp(window.embedlyURLre.source.substring(0, embedlyURLre.source.length-1) + "|(:?.*\\.(jpe?g|png|gif)(:?\\?.*)?$))", 'i')
          }, (oembed, dict) =>

            clearTimeout(@timeoutRequest)

            if oembed.html
              content = content.replace(/{{content}}/g, oembed.html)
              width = oembed.width
            else
              if oembed.type == 'link' && oembed.width == undefined
                content = content.replace(/{{content}}/g, '<a href="' + oembed.url + '"><img src="' + oembed.thumbnail_url + '" width="' + oembed.thumbnail_width + '" height="' + oembed.thumbnail_height + '" /></a>')
                width = oembed.thumbnail_width
              else
                content = content.replace(/{{content}}/g, '<img src="' + oembed.url + '" style="max-height: '+ maxHeight +'px" />')
                width = Math.round((oembed.width/oembed.height) * maxHeight)

                if data.service == 'Flickr'
                  width = oembed.width

            if width < 310
              width = 310

            @_onContentLoaded(content, width, data)

    _onContentLoaded: (content, width, data) ->
      _this = this

      content = content.replace(/{{content_width}}/g, width-11)
      content = content.replace(/{{voice_width}}/g, width)
      content = content.replace(/{{post_permalink}}/g, data.permalink)
      if data.prev
        content = content.replace(/{{prev_title}}/g, data.prev.title)
        content = content.replace(/{{prev_id}}/g, data.prev.id)
        content = content.replace(/{{prev_image}}/g, '<img src="' + data.prev.image + '" width="61">')
      
      if data.next
        content = content.replace(/{{next_title}}/g, data.next.title)
        content = content.replace(/{{next_id}}/g, data.next.id)
        content = content.replace(/{{next_image}}/g, '<img src="' + data.next.image + '" width="61">')
      

      $('.overlay-vote-post').unbind('click')
      content = @update_flag_status( $(content), data.voted)

      if data.type == 'link'
        if @zeroclip
          @zeroclip.destroy()
        
        @linkOverlayContainer.html('').append(content)
        @linkOverlayContainer.find('iframe').attr('src', data.href)
      else
        @overlayContainer.html('').append(content)

      new Votes('.overlay-vote-post')

      if not data.prev
        @linkOverlayContainer.find('.arrows .prev').remove()
        @overlayContainer.find('.arrows.prev').remove()

      if not data.next
        @linkOverlayContainer.find('.arrows .next').remove()
        @overlayContainer.find('.arrows.next').remove()

      if data.type == 'link'
        @_showLinkOver()
      else
        @_hideLinkOver =>

          if data.type == 'image'
            @overlayContainer.find('.voice-over-info > div > img').imagesLoaded (e) =>
              @show()
              @show() #Need to call it twice because when showing iframe, it measures the top wrong the first time.

              #reset the Image container to take the same width of the image

              if $('.voice-container .voice-over-info img').length > 0
                ImgElement = $(this)
                imgWidth = $(this).width()

                if imgWidth < 310
                  $(ImgElement).closest('.voice-container').css({width: 310})
                else
                  $(ImgElement).closest('.voice-container').css({width: imgWidth}).addClass('imgContainerWidth')

              top = ( $(window).height() - $('.overlay-container').height() ) / 2
              left = ( $(window).width() - $('.overlay-container').width() ) / 2
              arrowPosition = ( ( $('.overlay-container').height() / 2 ) - 30)

              $('.overlay-container').css({
                'top': top + $(document).scrollTop(),
                'left': left
              })

              $('.overlay-container .arrows').css({
                'margin-top': arrowPosition
              })

          else
            @show()
            @show() #Need to call it twice because when showing iframe, it measures the top wrong the first time.

    showTopOverlay: ->
      @overlay.css('top', $(document).scrollTop()).fadeIn()

    update_flag_status: (ele, voted) ->
      if voted == true
        ele.find('.flag-div a').toggleClass('flag flag-pressed')
        ele.find('.flag-tooltip span').html('Unflag Content')
      
      ele

    show: ->
      top = (@win.height() - @overlayContainer.height()) / 2
      left = (@win.width() - @overlayContainer.width()) / 2
      arrowPosition = ((@overlayContainer.height() / 2) - 30)

      $('body').css('overflow-y', 'hidden')
      
      @overlayContainer.css({
        'top': top + $(document).scrollTop(),
        'left': left
      }).show()

      $(@options.arrows).css({
        'margin-top': arrowPosition
      })

      @visible = true

    hide: ->
      $('body').css('overflow-y', 'hidden')

      $('.voice-over-info object, .voice-over-info iframe').remove()
      @overlay.fadeOut('slow')
      @overlayContainer.fadeOut('slow')
      @visible = false
    
  }
})

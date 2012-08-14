Class('Post')({
  detectUrl: (url) ->
    switch true
      when @isVideo(url)
        'video'
      when @isImage(url)
        'image'
      when @isLink(url)
        'link'
      else
        false

  isVideo: (url) ->
    regex = /^https?:\/\/(?:www\.)?(youtube\.com\/watch\?.*v=[^&]|vimeo\.com\/(?:.*#)?(\d+))/i
    regex.test(url)

  isImage: (url) ->
    regex = /^https?:\/\/(?:www\.)?(flickr\.com\/photos\/[-\w@]+\/\d+|twitpic\.com\/[^\/]+$|yfrog\.com\/[^\/]+$|.*\/.*\.(jpe?g|png|gif)(?:\?.*)?$)/i
    regex.test(url)

  isLink: (url) ->
    regex = /^https?:\/\/([\w-]+\.([\w-]+)){1,}([\/?#].*)?$/i
    regex.test(url)

  prototype: {
    init: (element, options) ->
      @options = {
        postPlaceHolder: '.post-paceholder'
      }
      $.extend(@options, options)
      @element = if typeof element is 'string' then $(element) else element
      @postPlaceHolder = $(@options.postPlaceHolder)
      @inputPost = $(@element.children('input'))
      @inputFile = $(@element.children('.post-paceholder').children('input'))
      @form = @element.parent()
      @lastSearch = ''
      @_setInput()
      @_bindEvents()

    _showTooltip: (type) ->
      $('.post-type .tooltip').hide()
      $('.tooltip.notice').hide()
      $('.media > a').removeClass('active')
      $('#post_remote_image_url').val('')
      carousel.clear()

      switch (type)
        when 'video'
          tt_video.show();
          
        when 'image'
          $('#image_description').val('')
          $('#image_title').val('')
          $('#post_copyright').val('')

          tt_image.show()
          
        when 'link'
          $('.carousel-image').find("img:not('.carousel-loader')").hide()
          $('.carousel-loader').show()
          carousel.show()
          @_call_for_page_info()

          tt_link.show()

    _bindEvents: ->
      input = @inputPost
      placeHolder = @postPlaceHolder
      inputFile = @inputFile

      placeHolder.children('span').click ->
        placeHolder.hide()
        input.focus()

      input.blur ->
        if input.val() is ''
          placeHolder.show()
          $('.video-tool').removeClass('active')
          tt_image._hide_extra_data()
          tt_link._hide_extra_data()
        else
          placeHolder.hide()

      input.focus ->
        placeHolder.hide()
      
      inputFile.hover(
        ->
          placeHolder.find('a').css("text-decoration","underline")
       
        ->
          placeHolder.find('a').css("text-decoration","none")
      )

      inputFile.change ->
        fileValue = $(this).val()
        if fileValue
          placeHolder.hide()
          fileValue = fileValue.split("\\")
          fileValue = fileValue[fileValue.length - 1]
          input.val(fileValue)
          _this._showTooltip('image')

      input.keyup (e) ->
        if (e.which <= 90 and e.which >= 48 and e.which != 86) or e.which == 8
          _this._showTooltip(_this.constructor.detectUrl($(this).val()))

      input.bind 'paste', =>
        setTimeout =>
          @_showTooltip(_this.constructor.detectUrl(input.val()))
        , 250
      
      @form.submit ->
        if input.val() and (_this.constructor.detectUrl(input.val()) or inputFile.val())
          if @lastSearch isnt input.val()

            $(this).ajaxSubmit {
              dataType: 'json',
              type: 'post',
              success: (data) ->
                if data.post
                  @lastSearch = input.val()
                  _this.inputFile.val('')
                  input.val('').blur()
                  $.get(
                    '/' + window.currentVoice.slug + '/posts/' + data.post.id,
                    (html) ->
                      post = $(html)
                      $('.post-type .tooltip').hide()
                      $('.media > a').removeClass('active')
                      posts_filter.toggleModerator(true)
                      carousel.clear()

                      $('.voices-container').prepend(post)
                      post.find('img.thumb-preview').bind 'load', ->
                        overlays.unbindEvents().bindEvents()
                        votes.unbindEvents().bindEvents()
                        
                        $('.voices-container')
                          .isotope('addItems', post)
                          .isotope('reloadItems')
                          .isotope({ sortBy: 'original-order' })
                          .isotope()
                  )
                  # TODO: show tooltip confirmation
                else #//error -- doesn't work with $.ajax error callback
                  for error in data
                    $('.post-type .tooltip').hide()
                    $('.media > a').removeClass('active')

                    if data.hasOwnProperty(error) and error is 'source_url'
                      $('.tooltip.notice .moderate-tooltip').html('Url '+data[error])
                      $('.tooltip.notice').show()
                  undefined
              }
        false
      
    _setInput: ->
      input = @inputPost
      placeHolder = @postPlaceHolder
      if input.val() is ''
        placeHolder.show()
      else
        placeHolder.hide()

    _call_for_page_info: ->
      $.ajax({
        url: "/remote_page_info",
        type: 'POST',
        data: "url=" + encodeURIComponent(@inputPost[0].value),
        # error: ->
        #   TODO: What to do when fail
        #   console.log('ERROR getting info')
        success: (data, status, xhr) ->
          carousel.loadHash(data)
          $('.carousel-image').find("img:not('.carousel-loader')").show()
          $('.carousel-loader').hide()

          # wait a bit before doing another ajax call
          setTimeout(
            -> 
              ajaxBusy = false
            ,2000
          )
        },
        dataType: "json"
      )
  }
})


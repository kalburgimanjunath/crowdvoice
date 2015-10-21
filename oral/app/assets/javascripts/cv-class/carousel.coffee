Class('Carousel')({
    prototype : {
      init: (element, options) ->
        @options =
          description : 'No description set.'
          title : 'No title set.'
          index : 0
          images : []
          picture: null
          DEFAULT_IMAGE: 'https://s3.amazonaws.com/crowdvoice-production/link-default.png'

        $.extend(@options, options)

        @element = if typeof element is 'string' then $(element) else element

        @picture = $(document.createElement('img'))
        @picture.css({'float': 'left', 'width': 89})
        @picture.attr({'id': 'img_74dd65a7c6'})

        $('.carousel-image').append(@picture)
        @_bindEvents()

      loadHash: (hash) ->
        @index = 0
        @title = hash.title
        @description = hash.description
        @images = []
        @picture.attr('src', @options.DEFAULT_IMAGE)
        
        #filter out the images that are useful
        if hash.error
          @clear()
          tt_link.hide()
          $('.tooltip.notice .moderate-tooltip').html(hash.error)
          $('.tooltip.notice').show()

        else
          for image in hash.images
            imgurl = image
            img = new Image()
            img.src = imgurl

            img.onload = =>
              if @width >= 50 and @height >= 50
               @addImage(@src)
               if @images.length >= 1 and @picture.attr('src') == @options.DEFAULT_IMAGE
                src = @current()

                if src isnt ''
                  @picture.show()
                  @picture.attr('src', @current())
                  $('#link_image').val(@current())
                  @update()

          @update(@current())
          @update_description()

      addImage: (img_src) ->
        @images.push(img_src)
        @update(@current())

      next: ->
        @index++
        if @index >= @images.length then @index = @images.length -1
        @current()

      prev: ->
        @index--
        if @index < 0 then @index = 0
        @current()

      current: ->
        if @images.length == 0 then @options.DEFAULT_IMAGE else @images[@index]

      label: ->
        if @images.length == 0 then 'no images found' else (@index + 1) + ' of ' + @images.length

      serialize: ->
        {
          'description' : @description
          'title' : @title
          'images' : @images
          'current' : @current()
        }

      clear: ->
          $('.carousel-counter').text('')
          $('#link_image').val('')
          $('#link_description').val('')
          @hide()

      show:->
        $('.tooltip-positioner.normal').hide()
        $('.tooltip-positioner.carousel').show()

      hide: ->
        $('.tooltip-positioner.carousel').hide()
        $('.tooltip-positioner.normal').show()

      update: (element) ->
        $('.carousel-image img').attr('src', element)
        $('.carousel-counter').text(@label())
        $('#link_image').val(@current())
        $('#post_remote_image_url').val(element)

      update_description: ->
        $('#link_title').val(carousel.title)
        $('#link_description').val(carousel.description)
        $('#link_image').val( if carousel.current() == $('.carousel-loader').attr('src') then '' else carousel.current() )

      _bindEvents: ->
        $('#carousel_right_arrow').unbind()
        $('#carousel_right_arrow').click =>
          @update(self.next())

        $('#carousel_left_arrow').unbind()
        $('#carousel_left_arrow').click =>
          @update(self.prev())


    } ##prototype 
})
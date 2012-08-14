#var landing_voices_loaded;

$(->
    new Testimonial('.peopleSay')
    new Testimonial('.testimonials')
    new Testimonial('.news')
    new FeatureSlider('.home-slider')

    $('.tab-controller').hide()
    $('hgroup').css('top', '50px')
    $('.voice').css('top', '113px')

    $('.welcome .close-message').click( ->
      $('.welcome').slideUp('1500')
      $('hgroup').animate({
          top: 0
      }, 300)
      $('.voice').animate({
          top: 63
      }, 300)
      $('.welcome-padding').animate({
          paddingTop: 0
      }, 300)
    )
    
    $('.mapit a').click(->
      $('.welcome').slideUp('1500')
      $('hgroup').css('top', '0px')
      $('.voice').css('top', '63px')
      $('.welcome-padding').css('padding-top', '0px')
    )
    
    #Home Columns
    columnsContainer = $('.home-columns')
    columnsContainerWidth = $(columnsContainer).width()
    
    $(columnsContainer).children().each(->
      $(this).css({width: (columnsContainerWidth / 3) - 15 + 'px'})
    )

    $(window).resize(->
      columnsContainer = $('.home-columns')
      columnsContainerWidth = $(columnsContainer).width()
  
      $(columnsContainer).children().each(->
          $(this).css({width: (columnsContainerWidth / 3) - 15 + 'px'})
      )
    )

    initHomeColumns = ->
      $('.home-columns .voice-list img').each(->
        imgWidth = $(this).width()
        imgHeight = $(this).height()
        aspectRatio = imgWidth / imgHeight
        parentWidth = $(this).parent().width()

        $(this).css({
            width: parentWidth,
            height: parentWidth / aspectRatio
        })
          
      )


    #get all data for controlled image loading
    $homeImages = $('.home-columns .voice-list img')
    homeImagesQty = $homeImages.length
    homeLoadedImages = 0

    #create new images to correctly trigger the load event
    $('.home-columns .voice-list img').each(->
      $orig = $(this)
      $newImage = $('<img />')

      $orig.replaceWith($newImage)

      $newImage.load(->
        reportLoad()
      ).attr('src', $orig.attr('src')).attr('alt', $orig.attr('alt'))
    )

    reportLoad = ->
      homeLoadedImages++
      #init the grid only after all images report they are loaded
      if homeLoadedImages is homeImagesQty
        initHomeColumns()

    $(window).resize(->
      $('.home-columns .voice-list img').each(->
        imgWidth = $(this).width()
        imgHeight = $(this).height()
        aspectRatio = imgWidth / imgHeight
        parentWidth = $(this).parent().width()

        $(this).css({
          width: parentWidth,
          height: parentWidth / aspectRatio
        })
      )
    )

    $('.vTooltip').bind({
      mouseover: ->
        vTip = $('.voice-count-tooltip').show()
        data = eval($(this).data('counts'))
        vTip.find('.photo-count').next('span').text(data.image)
        vTip.find('.video-count').next('span').text(data.video)
        vTip.find('.link-count').next('span').text(data.link)
        elementOffset = $(this).offset()
        elementWidth  = $(this).width()
        elementHeight = $(this).height()
        toolTipoffset = $(vTip).offset()
        toolTipWidth  = $(vTip).children().width()
        toolTipHeight = $(vTip).height()
        vTip.css({width: vTip.children().width() + 8, 'left': (elementOffset.left - toolTipWidth + 10) + 'px', 'top': (elementOffset.top - toolTipHeight - 10) + 'px' })
      },
      mouseout: ->
        $('.voice-count-tooltip').attr('style', '')
        $('.voice-count-tooltip').hide()
    )
)

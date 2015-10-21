Class('LiveFilter')({
  prototype: {
    init: (input, container) ->
      @input = if typeof input is 'string' then $(input) else input
      @container = if typeof container is 'string' then $(container) else container
      @originalContent = @container.html()
      @itemsContainer = $('<ul />').insertAfter(@container).hide()
      @items = @container.find('li').clone().appendTo(@itemsContainer)
      @clearBtn = @input.next('.clear-search')
      @_bindEvents()

    _bindEvents: ->
      that = this
      @input.bind 'keyup', ->
        that.filter($(this).val())
        if $(this) .val() is ''
          that.clearBtn.hide()
        else
          that.clearBtn.show()
      
      @input.focusout =>
        @clearBtn.addClass('invisible')
      
      @input.focus ->
        if $(this).val() is ''
          that.clearBtn.hide()
          that.clearBtn.removeClass('invisible')
        else
          that.clearBtn.show()
          that.clearBtn.removeClass('invisible')

      
      @clearBtn.click ->
        that.input.focus()
        that.input.val('')
        that.filter($(this).val())
        $(this).hide()

    filter: (value) ->
      if value is '' 
        @container.html(@originalContent)
        new Accordion('.accordion')
      else
        match = $.grep @items.clone(), (item) =>
          regex = new RegExp(value, 'i')
          regex.test( @removeAccents($(item).text()) )
        
        $('.accordion').parent().unbind('click')
        @container.html('').append($('<ul/>').append(match))

    removeAccents: (value) ->
      strArr = value.split('')
      strOut = new Array()
      accents = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž'
      accentsOut = ['A','A','A','A','A','A','a','a','a','a','a','a','O','O','O','O','O','O','O','o','o','o','o','o','o','E','E','E','E','e','e','e','e','e','C','c','D','I','I','I','I','i','i','i','i','U','U','U','U','u','u','u','u','N','n','S','s','Y','y','y','Z','z']
      for letter in strArr
        if accents.indexOf(letter) != -1
          strOut[_i] = accentsOut[accents.indexOf(letter)];
        else
          strOut[_i] = letter
      strOut = strOut.join('')
  }
});

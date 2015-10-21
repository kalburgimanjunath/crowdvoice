Class('JsonForm')({
  prototype: {
    init: (element, onSuccess) ->
      @element = if typeof element is 'string' then $(element) else element
      @onSuccess = onSuccess
      @_bindEvents()

    _bindEvents: ->
      @element.bind('submit', =>
        @submit($(this))
        false
      )

    submit: (form) ->
      @clearErrors()
      $.ajax {
        url: form.attr('action')
        data: form.serialize()
        type: 'post'
        dataType: 'json'
        success: (data) =>
          @handleSuccess(data, form)
        error: (xhr) ->
          @clearErrors()
          @handleError(eval('(' + xhr.responseText + ')'))
        
      }

    clearErrors: ->
      @element.find('tr.error').remove()
      @element.find('.error').removeClass('error')

    handleSuccess: (data, form) ->
      if @onSuccess
        @onSuccess(data, form)

    handleError: (errors) ->
      tpl = '<tr class="error"><td></td><td><span>%s</span></td></tr>'
      for attr in errors
        if errors.hasOwnProperty(attr)
          if attr is 'base'
            @element.find('tbody').append(
              tpl.replace(/%s/g, errors[attr])
            )
          else
            @element.find('[data-attribute=' + attr + ']')
              .addClass('error').closest('tr').after(
                tpl.replace(/%s/g, attr + ' ' + errors[attr][0])
              )
      undefined
  } #prototype
})

Class('Facebook')({
  prototype: {
    init: ->
      FB.init({
        appId: '101972966529938',
        xfbml: true
      })

      @element = $('.fb-button, .fb-button-square')
      @_bindEvents()

      @isLoggedIn( (session) ->
        if session
          that._updateLabel(session.uid)
      )

    _updateLabel: (uid) ->
      if uid isnt '' && uid isnt undefined and $('.connections_grid li[data-uid=' + uid + ']').length > 0
        $('.fb-button span span').html('Stop Supporting')
      else
        $('.fb-button span span').html('Support This')

    _bindEvents: ->
      @element.bind(
        'click'
        =>
          if $('.fb-button span span').html() == 'Stop Supporting' and $('.connections_grid li').length > 0
            @login (uid) -> @destroyAvatar(uid)
          else
            @login (uid) -> @saveAvatar(uid)
          
          false
        )

    saveAvatar: (uid) ->
      $.ajax({
        url: '/' + window.currentVoice.id + '/supporters.json'
        type: 'post'
        dataType: 'json'
        data: { uid: uid }
        context: this
        success: (data) ->
          FacesPanel.addAvatar(uid, data.url, data.username)
          $('.fb-button span span').html('Stop Supporting')
      })

    destroyAvatar: (uid) ->
      $.ajax({
        url: '/' + window.currentVoice.id + '/supporters/' + uid
        type: 'post'
        dataType: 'json'
        data: { _method: 'delete' }
        context: this
        success: (data) ->
          FacesPanel.destroyAvatar(data.uid)
          $('.fb-button span span').html('Support This')
      })

    isLoggedIn: (callback) ->
      FB.getLoginStatus (response) ->
        callback(response.session)

    login: (callback) ->
      FB.getLoginStatus (response) ->
        if response.session
          callback(response.session.uid)
        else
          FB.login (response) ->
            if response.session
              callback(response.session.uid)
  }
})

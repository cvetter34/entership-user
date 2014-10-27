$ ->
  togglePills = (listItem) ->
    console.log "toggling pills for", listItem
    hidePasswordField = ->
      $('#password-label').hide()
      $('#member_password').hide()
      $('#show-password-button').hide()
      $('#member_password').val('')
      $('#member_password').attr('required',null)

    showPasswordField = ->
      $('#password-label').show()
      $('#member_password').show()
      $('#show-password-button').show()
      $('#member_password').attr('required',true)

    switch listItem
      when 'enrollment-pill'
        $('legend').html('Please enter your email')
        $('#submit-button').val('Sign up')
        $('#form-type').val('register')
        hidePasswordField()
      when 'reset-pill'
        $('legend').html('Please enter your email')
        $('#submit-button').val('Reset Password')
        $('#form-type').val('reset')
        hidePasswordField()
      else
        $('legend').html('Please sign in')
        $('#submit-button').val('Sign in')
        $('#form-type').val('login')
        showPasswordField()

    $('#member_email').focus()
    $('.fading-login-form').fadeIn()

  setLoginOptions = (e) ->
    $('.login-options').find('li').removeClass('active')
    $(@).parent().addClass('active')
    togglePills($(@)[0].id)
    e.preventDefault()

  if $('.login-options')[0]
    togglePills $('.login-options li.active a').attr('id')

  $('.login-options').children('li').children('a').on 'click', setLoginOptions

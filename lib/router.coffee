openMenuIfDesktop = ->
  if $(window).width() > 768
    # if you visit a new route and you are in desktop mode the menu will show
    if !$('#toggleSidebarMenu').hasClass 'active'
      Meteor.defer ->
        $('#toggleSidebarMenu').click()
  else
    # if in mobile view close the menu after a new route has been chosen
    if $('#toggleSidebarMenu').hasClass 'active'
      Meteor.defer ->
        $('#toggleSidebarMenu').click()


requireLogin = (pause) ->
  if !Meteor.user()
    @layout 'layoutLoggedOut'
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render 'login'
      pause()
  else
    @layout 'layout'
    @next()

@userEnabled = () ->
  if Meteor.user()
    openMenuIfDesktop()

Router.configure 
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.onAfterAction @userEnabled,
  except: ['login']

#Do not require login for all public routes
Router.onBeforeAction requireLogin, 
  except: ['publicPage']

Router.onBeforeAction 'loading'

Router.onBeforeAction ->
  FlashMessages.clear()
  @next()

Router.map ->
  @route 'login',
    path: '/',
    onBeforeAction: ->
      if Meteor.user()
        Router.go 'dashboard'
  @route 'dashboard',
    path: '/dashboard',
    # waitOn: ->
    # data: ->


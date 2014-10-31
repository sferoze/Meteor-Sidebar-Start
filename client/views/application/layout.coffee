# consider using session?
closedMenuInDesktopView = false
@iphone = (/iPhone|iPod/).test(navigator.userAgent)
@mobile = (/iPhone|iPod|iPad|Android|BlackBerry/).test(navigator.userAgent)

Meteor.startup ->
  Meteor.Spinner.options = 
    top: '80px'

Accounts.ui.config
  passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"

# initializeClearable = () ->
#   tog = (v) ->
#     (if v then "addClass" else "removeClass")
#   $(document).on("input", ".clearable", ->
#     $(this)[tog(@value)] "x"
#   ).on("mousemove", ".x", (e) ->
#     $(this)[tog(@offsetWidth - 18 < e.clientX - @getBoundingClientRect().left)] "onX"
#   ).on "click", ".onX", ->
#     $(this).removeClass("x onX").val ""

Template.layout.events
  'click #toggleSidebarMenu': (e) ->
    $(e.target).trigger 'menu-click'
    classie.toggle e.target, "active"
    #classie.toggle document.body, "slide-menu-active"
    classie.toggle $('#sidebarMenu')[0], "sidebar-menu-open"
    if $('#sidebarMenu').hasClass 'sidebar-menu-open'
      $(document.body).addClass "slide-menu-active"
      #Session.set 'menuOpen', true
      if $(window).width() > 768
        closedMenuInDesktopView = false
      else
        $('body').append '<div id="close-main-menu-backdrop"></div>'
    else
      $('#close-main-menu-backdrop').remove()
      $(document.body).removeClass "slide-menu-active"
      #Session.set 'menuOpen', false
      if $(window).width() > 768
        closedMenuInDesktopView = true

Template.layout.rendered = () ->

  # document.ontouchmove = (e) ->     

  # Check for IE 10 or 11
  if navigator.appVersion.indexOf('Trident/') != -1 
    $("body").addClass("IE")

  $('body').on 'click', '#close-main-menu-backdrop', ->
    if $('#sidebarMenu').hasClass 'sidebar-menu-open'
      $('#toggleSidebarMenu').click()
    $('#close-main-menu-backdrop').remove()

  #initializeClearable()

  
  #This is to stop the page from navigating back on delete keypress

  $(document).keydown (e) ->
    preventKeyPress = undefined
    if e.keyCode is 8
      d = e.srcElement or e.target
      switch d.tagName.toUpperCase()
        when "TEXTAREA"
          preventKeyPress = d.readOnly or d.disabled
        when "INPUT"
          preventKeyPress = d.readOnly or d.disabled or (d.attributes["type"] and $.inArray(d.attributes["type"].value.toLowerCase(), [
            "radio"
            "checkbox"
            "submit"
            "button"
          ]) >= 0)
        when "DIV"
          preventKeyPress = d.readOnly or d.disabled or not (d.attributes["contentEditable"] and d.attributes["contentEditable"].value is "true")
        else
          preventKeyPress = true
    else
      preventKeyPress = false
    e.preventDefault()  if preventKeyPress
    return





  $(window).resize ->
    if Meteor.user()
      if $(window).width() > 768
        # if the user closed the menu in desktop view we wont open it upon resize from mobile
        #console.log !$('#show-left').hasClass 'active'
        if (!$('#toggleSidebarMenu').hasClass('active') && closedMenuInDesktopView is false)
          $('#toggleSidebarMenu').click() 
      else
        if $('#toggleSidebarMenu').hasClass('active')
          $('#toggleSidebarMenu').click()




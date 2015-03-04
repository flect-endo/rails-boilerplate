# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#generate_auth_token")
    .on 'ajax:complete', (event, ajax, status) ->
      response = $.parseJSON(ajax.responseText)
      $("#user_authentication_token").val response.token
  $("#delete_auth_token")
    .on 'ajax:complete', (event, ajax, status) ->
      $("#user_authentication_token").val ''
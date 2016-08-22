// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function initializeWizard() {
  $('#wizard').steps({
    headerTag: 'h1',
    bodyTag: 'section',
    transitionEffect: 'slideLeft',
    autoFocus: true
  });
}

$(document).on('turbolinks:load', initializeWizard);


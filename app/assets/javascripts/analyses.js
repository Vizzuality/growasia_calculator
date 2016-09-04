// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function initializeAnalysisFunctions() {
  $('#wizard').steps({
    headerTag: 'h1',
    bodyTag: 'section',
    autoFocus: true,
    enableFinishButton: false
  });

  $('#country').change(function() {
    if($(this).val() !== '') {
      $.get('/geo_locations/states_for/'+$(this).val());
    } else {
      $("#state-selection").addClass("hidden");
    }
  });
}



$(document).on('turbolinks:load', initializeAnalysisFunctions);


(function(App) {

  'use strict';

  App.Controller = App.Controller || {};

  App.Controller.Analysis = App.Controller.Page.extend({

    show: function() {
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
    },
  });


})(this.App);

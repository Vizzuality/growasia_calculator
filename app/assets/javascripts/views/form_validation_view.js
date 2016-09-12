(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  App.Helper.FormValidation = Backbone.View.extend({

    constraints: {
      required: {
        presence: true
      },
      numeric: {
        presence: true,
        numericality: true
      }
    },

    numericValidation: function(value) {
      return validate.single(value, this.constraints.numeric);
    },

    requiredValidation: function(value) {
      return validate.single(value, this.constraints.required);
    }



  });

})(this.App);

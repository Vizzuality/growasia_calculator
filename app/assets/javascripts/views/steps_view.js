(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Steps = Backbone.View.extend({

    currentSlide: 0,

    events: {
      'click .js--slider-handler' : 'changeDiapo',
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend( this.defaults, opts );
    },

    render: function() {
    },

    changeDiapo: function(e) {

    }


  });

})(this.App);

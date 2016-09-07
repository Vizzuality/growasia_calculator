(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Steps = Backbone.View.extend({

    currentSlide: 1,

    events: {
      'click .js--slider-handler' : 'changeDiapo',
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend( this.defaults, opts );

      this.cacheVars();
    },

    cacheVars: function() {
      this.$allSliders = $('.js--slide');
    },

    changeDiapo: function(e) {
      $(e.currentTarget).data('step') === 'next' ? this.currentSlide += 1 : this.currentSlide -= 1;

      this.showDiapo();
    },

    showDiapo: function() {
      this.$allSliders.removeClass('-is-current');
      $('#slide-' + this.currentSlide).addClass('-is-current');
    }


  });

})(this.App);

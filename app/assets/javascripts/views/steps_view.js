(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Steps = Backbone.View.extend({

    nextSlide: 1,
    currentPath: '',

    events: {
      'click .js--slider-handler' : 'onClickChangeDiapo',
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
      this.$allSliders = this.$el.find('.js--slide');
      this.btnPrev = this.$el.find('.js--slider-handler[data-step="prev"]');
      this.btnNext = this.$el.find('.js--slider-handler[data-step="next"]');
    },

    onClickChangeDiapo: function(e) {
      //Obiously, we need to improve all this part to make it automatique and more scalable.
      //But keep it for instance to think about add a library.

      var currentSlide = this.nextSlide;

      $(e.currentTarget).data('step') === 'next' ? this.nextSlide += 1 : this.nextSlide -= 1;

      if (currentSlide === 2) {
        var crop = $('#analysis_crop').val();
        if (crop === 'rice') {
          this.nextSlide = 9;
          this.currentPath = 'rice';
        } else {
          this.currentPath = 'crop';
        };
      }

      if (this.currentPath === 'crop') {
        if ( this.nextSlide >= 8 ) {
          this.nextSlide = 8;
          this.lastSlide = true;
        } else if(this.nextSlide <= 1 ) {
          this.nextSlide = 1;
          this.firstSlide = true;
        } else {
          this.firstSlide = false;
          this.lastSlide = false;
        }
      } else {
        if ( this.nextSlide >= 14 ) {
          this.nextSlide = 14;
          this.lastSlide = true;
        } else if(this.nextSlide <= 1) {
          this.nextSlide = 1;
          this.firstSlide = true;
        } else {
          this.firstSlide = false;
          this.lastSlide = false;
        }
      }

      this.manageHandlers();
      this.showDiapo();
    },

    showDiapo: function() {
      this.$allSliders.removeClass('-is-current');
      $('#slide-' + this.nextSlide).addClass('-is-current');
    },

    manageHandlers: function() {
      this.firstSlide ? this.btnPrev.addClass('is-hidden') : this.btnPrev.removeClass('is-hidden');
      this.lastSlide ? this.btnNext.addClass('is-hidden') : this.btnNext.removeClass('is-hidden');
    }
  });

})(this.App);

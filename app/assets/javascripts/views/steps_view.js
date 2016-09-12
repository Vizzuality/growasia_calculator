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

      this.validator = new App.Helper.FormValidation();

      this.cacheVars();
    },

    cacheVars: function() {
      this.$allSliders = this.$el.find('.js--slide');
      this.btnPrev = this.$el.find('.js--slider-handler[data-step="prev"]');
      this.btnNext = this.$el.find('.js--slider-handler[data-step="next"]');
      this.cropSelector = this.$el.find('#analysis_crop');
    },

    onClickChangeDiapo: function(e) {
      //Obiously, we need to improve all this part to make it automatique and more scalable.
      //But keep it for instance to think about add a library.

      var currentSlide = this.nextSlide;
      var errors = this.validateSlide(currentSlide);

      !errors && this.updateSlide(e, currentSlide);
    },

    validateSlide: function(slide) {
      var errors;
      var $currentSlide = $('#slide-'+slide);
      var $numeric = $currentSlide.find('.is-numeric');
      var $required = $currentSlide.find('.is-required');

      if ($required) {
        _.each($required, function(input) {
          errors = this.validator.requiredValidation($(input).val());

          if (errors) {
            this.showError(errors, input);
          }
        }.bind(this));
      }

      return errors && true;
    },

    updateSlide: function(e, currentSlide) {
      $(e.currentTarget).data('step') === 'next' ? this.nextSlide += 1 : this.nextSlide -= 1;

      if (currentSlide === 2) {
        var crop = this.cropSelector.val();
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
      this.btnPrev.toggleClass('is-hidden', this.firstSlide);
      this.btnNext.toggleClass('is-hidden', this.lastSlide);
    },

    showError: function(errors, input) {
      var errorMessage;

      if ($(input).hasClass('is-wrong')) {return}

      var $chosenInput = $(input).next('.chosen-container');
      var $currentInput = $chosenInput.length > 0 ? $chosenInput : $(input);


      $(input).addClass('is-wrong');
      $(input).next('.chosen-container').addClass('is-wrong');

      // _.each(errors, function(error) {
      //   errorMessage = '<div class="error">this field ' + error + '</div>';
      //   $currentInput.after(errorMessage);
      // });
    }
  });

})(this.App);

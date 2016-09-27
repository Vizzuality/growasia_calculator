(function(App) {

  'use strict';

  App.View.Slider = Backbone.View.extend({

    model: new (Backbone.Model.extend({
      defaults: {
        index: 0,
        length: 5,

        stepindex: null,
        stepslength: null,

        direction: null
      }
    })),

    events: {
      'click .js-slider-arrow' : 'onClickDirection',
      'change input,textarea,select' : 'onChangeInput',
    },

    initialize: function(settings) {
      this.options = _.extend({}, this.defaults, settings.options || {});
      this.cache();
      this.listeners();

      // Set the validators
      this.validator = new App.Helper.FormValidation();

      // Set the initial state
      this.changeIndex();
    },

    cache: function() {
      this.$window = $(window);
      this.$document = $(document);
      this.$sliderItems = this.$el.find('.js-slider-item');
      this.$sliderArrows = this.$el.find('.js-slider-arrow');
    },

    listeners: function() {
      // Model events
      this.model.on('change:index', this.changeIndex.bind(this));
      this.model.on('change:stepindex', this.changeStepIndex.bind(this));

      // Dom events
      this.$window.on('resize.slider', this.changeIndex.bind(this));
    },

    // UI EVENTS
    onChangeInput: function(e) {
      this.validateInput(e.currentTarget);
    },

    onClickDirection: function(e) {
      // Slider index
      var index = this.model.get('index'),
          length = this.model.get('length');

      // Step index
      var stepindex = this.model.get('stepindex'),
          stepslength = this.model.get('stepslength');

      // New index
      var newIndex = index,
          newStepIndex = stepindex;

      switch ($(e.currentTarget).data('direction')) {
        case 'prev':
          // If it's the first step,
          // we should move to the previous slider
          // Otherwise previous step
          this.model.set('direction', 'prev');
          if ((stepindex - 1) < 0) {
            newIndex = ((index - 1) < 0) ? 0 : index - 1;
            this.model.set('index', newIndex);
          } else {
            newStepIndex = stepindex - 1;
            this.model.set('stepindex', newStepIndex);
          }
        break;

        case 'next':
          // If it's the last step,
          // we should move to the next slider
          // Otherwise next step
          if (!this.validateStep()) {
            this.model.set('direction', 'next');
            if (stepindex + 1 > stepslength - 1) {
              newIndex = ((index + 1) > length - 1) ? length - 1 : index + 1;
              this.model.set('index', newIndex);
            } else {
              newStepIndex = stepindex + 1;
              this.model.set('stepindex', newStepIndex);
            }
          }
        break;
      }
    },




    // CHANGE EVENTS
    changeIndex: function(e) {
      var index = this.model.get('index');
      var newStepIndex = 0;
      var time = (e && e.type === 'resize') ? 0 : 500;

      _.each(this.$sliderItems, function(el, i) {
        var $el = $(el);

        if (i == index) {
          // Save the steps of the selected index
          this.$stepsItems = $el.find('.js-slider-step');

          // Set the stepIndex depending on the direction
          switch (this.model.get('direction')) {
            case 'prev':
              newStepIndex = this.$stepsItems.length - 1
            break;

            case 'next':
              newStepIndex = 0
            break;
          }

          // Set the model
          this.model.set('stepslength', this.$stepsItems.length, { silent: true });
          this.model.set('stepindex', newStepIndex, { silent: true });
          this.model.trigger('change:stepindex');
        }

        $el.transition(this.getStyle(i), time);

      }.bind(this));
    },


    changeStepIndex: function() {
      this.$stepsItems.toggleClass('-active', false);
      this.$stepsItems.eq(this.model.get('stepindex')).toggleClass('-active', true);
    },




    // HELPERS
    getStyle: function(i) {
      var constant = 10;
      var index = this.model.get('index');
      var length = this.model.get('length');
      var differenceFromIndex = Math.abs(i - index);
      var differenceFromLength = Math.abs(length - index);
      var constantOpened = (differenceFromIndex == 1) ? 80 : 0;

      if (i === index) {
        return {
          zIndex: 0,
          x: 0
        }
      }

      if (i > index) {
        return {
          zIndex: differenceFromIndex,
          x: this.$el.width() - ((differenceFromLength - differenceFromIndex) * constant) - constantOpened
        }
      }

      if (i < index) {
        return {
          zIndex: differenceFromIndex,
          x: -this.$el.width() + ((i * constant) + constant) + constantOpened
        }
      }
    },

    validateStep: function() {
      var errors;
      var $currentSlide = this.$stepsItems.eq(this.model.get('stepindex'));
      var $required = $currentSlide.find('.-js-required');
      var $numeric = $currentSlide.find('.-js-numeric');

      if ($required) {
        _.each($required, function(input) {
          errors = this.validator.requiredValidation($(input).val());
          this.toggleError(errors, input);
        }.bind(this));
      }

      if ($numeric) {
        _.each($numeric, function(input) {
          errors = this.validator.numericValidation($(input).val());
          this.toggleError(errors, input);
        }.bind(this));
      }

      return errors && true;
    },

    validateInput: function(input) {
      var errors;
      var is_required = $(input).hasClass('-js-required');
      var is_numeric = $(input).hasClass('-js-numeric');

      if (is_required) {
        errors = this.validator.requiredValidation($(input).val());
        this.toggleError(errors, input);
      }

      if (is_numeric) {
        errors = this.validator.numericValidation($(input).val());
        this.toggleError(errors, input);
      }
    },

    toggleError: function(errors, input) {
      $(input).toggleClass('-error', !!errors);
      $(input).parents('.c-field').toggleClass('-error', !!errors);
    }

  });

})(this.App);

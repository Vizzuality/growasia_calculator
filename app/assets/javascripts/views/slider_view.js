(function(App) {

  'use strict';

  App.View.Slider = Backbone.View.extend({

    model: new (Backbone.Model.extend({
      defaults: {
        index: 0,
        length: 5,

        stepindex: null,
        stepslength: null,

        direction: null,

        crop: 'cocoa'
      }
    })),

    events: {
      'click .js-slider-arrow' : 'onClickDirection',
      'change input,textarea,select' : 'onChangeInput',
      'change #analysis_crop' : 'onChangeCrop',
      'change #country' : 'onChangeCountry',
      'change #analysis_geo_location_id' : 'onChangeRegion',
      'change .js-required-checkbox' : 'onChangeRequiredCheckbox',
      'change .-js-next-step-switcher' : 'onChangeNextStepSwitcher',
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

      this.$form = $('#new_analysis');

      this.$sliderItems = this.$el.find('.js-slider-item');
      this.$sliderArrows = this.$el.find('.js-slider-arrow');

      // CROP
      this.$selectCrop = this.$el.find('#analysis_crop');

      // COUNTRY
      this.$countryLabel = this.$el.find('#country-label');
      this.$regionField = this.$el.find('#region-field')
      this.$regionLabel = this.$el.find('#region-label');
    },

    listeners: function() {
      // Model events
      this.model.on('change:index', this.changeIndex.bind(this));
      this.model.on('change:stepindex', this.changeStepIndex.bind(this));

      // Dom events
      this.$document.on('keydown.slider', this.onKeyDownHandler.bind(this));
      this.$document.on('keyup.slider', this.onKeyUpHandler.bind(this));
      this.$window.on('resize.slider', this.changeIndex.bind(this));
    },


    // CHANGE EVENTS
    changeIndex: function(e) {
      var index = this.model.get('index');
      var newStepIndex = 0;
      var time = (e && e.type === 'resize') ? 0 : 500;
      var crop = (this.model.get('crop') === 'rice') ? 'rice' : 'other';

      _.each(this.$sliderItems, function(el, i) {
        var $el = $(el);

        if (i == index) {
          // Save the steps of the selected index
          // Depending on the crop selected we will show different steps
          var stepsItems = _.reject($el.find('.js-slider-step'), function(step){
            var dataCrop = $(step).data('crop');
            if (dataCrop) {
              return dataCrop != crop
            }
          });

          this.$stepsItems = $(stepsItems);

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
        App.Events.trigger('Slider:index', this.model.get('index'));

      }.bind(this));
    },

    changeStepIndex: function() {
      this.$sliderItems
        .eq(this.model.get('index'))
          .find('.js-slider-step')
          .toggleClass('-active', false);

      this.$stepsItems
        .eq(this.model.get('stepindex'))
        .toggleClass('-active', true);
    },



    // UI EVENTS
    onChangeCountry: function(e) {
      var value = $(e.currentTarget).val();

      if (!!value) {
        $.get('/geo_locations/states_for/'+value);
        // It's not my best code...
        this.$countryLabel.addClass("-hidden");
        this.$regionField.removeClass("-hidden");
        this.$regionLabel.removeClass("-hidden");

        if ($(e.currentTarget).siblings('.select2-container').hasClass('-error')) {
          $(e.currentTarget).siblings('.select2-container').removeClass('-error');
          $(e.currentTarget).parents('.c-field').removeClass('-error');
          $(e.currentTarget).removeClass('-error');
          $('#region-field').siblings('.select2-container').removeClass('-error');
          $('#region-field').removeClass('-error');
        }

      } else {
        $("#state-selection").addClass("hidden");
      }
    },

    onChangeCrop: function(e) {
      this.model.set('crop', e.currentTarget.value);
    },

    onChangeInput: function(e) {
      this.validateInput(e.currentTarget);
    },

    onChangeRequiredCheckbox: function(e) {
      var is_checked = $(e.currentTarget).is(':checked');
      var $input = $('#analysis_'+ e.currentTarget.dataset.input);

      $input
        .prop('disabled', !is_checked)
        .toggleClass('-disabled', !is_checked)
        .toggleClass('-js-required', is_checked);
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
              newIndex = ((index + 1) > length - 1) ? this.submitForm() : index + 1;
              this.model.set('index', newIndex);
            } else {
              newStepIndex = stepindex + 1;
              this.model.set('stepindex', newStepIndex);
            }
          }
        break;
      }
    },

    onKeyDownHandler: function(e) {
      switch(e.keyCode){
        case 9:
          // Prevent tab functionallity
          // We should override this functionality
          e && e.preventDefault();
        break;
      }
    },

    onKeyUpHandler: function(e) {
      // Let's handle the different key events from here
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

    // TODO: I would like to change this...
    // It would be better if we validate using classes but without trigger the validations, I mean,
    // we need to add this kind of validations if (!!$(input).val()) {} for numerics...
    validateStep: function() {
      var errors = [];
      var $currentSlide = this.$stepsItems.eq(this.model.get('stepindex'));
      var $required = $currentSlide.find('.-js-required');
      var $numeric = $currentSlide.find('.-js-numeric');

      if ($required) {
        _.each($required, function(input) {
          var error = this.validator.requiredValidation($(input).val());
          !!error && errors.push(error);
          this.toggleError(error, input);
        }.bind(this));
      }

      if ($numeric) {
        _.each($numeric, function(input) {
          if (!!$(input).val()) {
            var error = this.validator.numericValidation($(input).val());
            !!error && errors.push(error);
            this.toggleError(error, input);
          }
        }.bind(this));
      }

      return !!errors.length && true;
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
        if (!!$(input).val()) {
          errors = this.validator.numericValidation($(input).val());
          this.toggleError(errors, input);
        }
      }
    },

    toggleError: function(error, input) {
      $(input).toggleClass('-error', !!error);
      $(input).parents('.c-field').toggleClass('-error', !!error);
    },

    submitForm: function() {
      this.$form.submit();
    },

    onChangeNextStepSwitcher: function(e) {
      var inputId = $(e.currentTarget).attr('id');
      var $hiddenInputToBeShown = $('#' + inputId + 'Amount');

      $hiddenInputToBeShown.removeClass('-disabled');
    }

  });

})(this.App);

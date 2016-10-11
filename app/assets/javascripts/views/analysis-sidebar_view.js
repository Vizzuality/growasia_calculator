(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisSidebar = Backbone.View.extend({

    events: {
      'change input,select' : 'onChangeInput',
      'click .-js-add-fields': 'onAddFields',
      'change input.-js-is-resetable': 'onEnableReset',
      'click .-js-reset-analysis': 'onResetFields',
      'mouseover .-js-reset-analysis': 'tooltipLastValue',
      'mouseout .-js-reset-analysis': 'tooltipLastValue'
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }
      this.model = settings.model;
      this.modelCompare = settings.modelCompare;

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend(this.defaults, opts);

      this.cache();
    },

    cache: function() {
      this.$form = this.$el.find('#analysis-sidebar-form');
    },

    addSelectLib: function() {
      $('select').select2({
        theme: "default",
        minimumResultsForSearch: -1
      });

      $.each($('select'), function() {
        var classList = this.className.split(/\s+/);
        for (var i = 0; i < classList.length; i++) {
          if (classList[i].includes('theme')) {
            $(this).next('.select2-container').addClass(classList[i]);
          }
        }
      });

      $('.select2-container').on('click', function(e) {
        var classList = e.currentTarget.className.split(/\s+/);
        for (var i = 0; i < classList.length; i++) {
          if (classList[i].includes('theme')) {
            $('.select2-dropdown').addClass(classList[i]);
          }
        }
      });
    },

    /*
    * UI EVENTS
    */
    onChangeInput: function(e) {
      e && e.preventDefault();

      $.ajax({
        url: '/api/v1/analyses/' + this.modelCompare.get('id'),
        method: 'POST',
        data: this.$form.serialize(),
        dataType: 'json',
        success: function(model) {
          this.modelCompare.set(model);
        }.bind(this),

        error: function() {
          console.log(arguments);
        }
      });
    },

    onAddFields: function(e) {
      e && e.preventDefault();
      var $target = $(e.currentTarget);
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($target.data('id'), 'g');

      var $newFields = $target.data('fields').replace(regexp, time)
      $target.parent('label').next('.fields-container').append($newFields);

      this.addSelectLib();
    },

    onEnableReset: function(e) {
      e && e.preventDefault();

      var $target = $(e.currentTarget);

      if($target.nextAll('.options-wrapper').find('.-js-reset-analysis').hasClass('is-hidden')) {
        $target.nextAll('.options-wrapper').find('.-js-reset-analysis').removeClass('is-hidden');
      }
    },

    onResetFields: function(e) {
      e && e.preventDefault();
      var $target = $(e.currentTarget);
      var $input = $target.parent().prevAll('.-js-is-resetable');
      $input.val($target.data('previous-value'));
      $input.trigger('change');
      $target.addClass('is-hidden');
    },

    tooltipLastValue: function(e) {
     $(e.currentTarget).find('.-js-reset-tooltip').toggleClass('is-hidden');
    }

  });

})(this.App);

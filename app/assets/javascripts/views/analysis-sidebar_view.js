(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisSidebar = Backbone.View.extend({

    events: {
      'change input,select' : 'onChangeInput'
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
    }


  });

})(this.App);

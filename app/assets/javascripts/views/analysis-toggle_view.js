(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisToggle = Backbone.View.extend({

    events: {
      'click .js-toggle-item' : 'onClickToggleItem'
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
      this.listeners();
    },

    cache: function() {
      this.$toggleItems = this.$el.find('.js-toggle-item');
      this.$slider = this.$el.find('.js-toggle-slider');
    },

    listeners: function() {
      this.model.on('change:type', this.changePosition.bind(this));
      this.modelCompare.on('change:type', this.changePosition.bind(this));
    },

    // MODEL EVENTS
    changePosition: function() {
      var type = this.model.get('type');
      var $current = this.$toggleItems.filter('[data-type="'+ type +'"]');
      var index = this.$toggleItems.index($current);

      this.$toggleItems.toggleClass('-active', false);
      $current.toggleClass('-active', true);

      this.$slider.transition({
        x: (index * 100) + '%'
      }, 200)
    },

    // UI EVENTS
    onClickToggleItem: function(e) {
      var type = $(e.currentTarget).data('type');
      this.model.set('type', type);
      this.modelCompare.set('type', type);
    },



  });

})(this.App);

(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Header = Backbone.View.extend({

    model: new (Backbone.Model.extend({
      defaults: {
        sliderIndex: 0
      }
    })),

    events: {
      'click .js-btn-action' : 'onClickAction'
    },

    defaults: {
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts);

      this.listeners();
      this.render();
    },

    listeners: function() {
      App.Events.on('Slider:index', function(index){
        this.model.set('sliderIndex', index);
      }.bind(this));

      this.model.on('change:sliderIndex', this.changeIndex.bind(this));
    },

    changeIndex: function() {
      var sliderIndex = this.model.get('sliderIndex'),
          constant = 10,
          index = (sliderIndex - 1 < 0) ? 0 : sliderIndex - 1,
          time = 500;

      this.$el.transition({
        x: constant * index
      })

    },

    /*
    * UI EVENTS
    */
    onClickAction: function(e) {
      e && e.preventDefault();
      var action = $(e.currentTarget).data('action');
      App.Events.trigger(action);
    }

  });

})(this.App);

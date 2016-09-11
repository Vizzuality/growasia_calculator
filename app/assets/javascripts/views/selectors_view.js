(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Selectors = Backbone.View.extend({

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts);

      this.listeners();
    },

    listeners: function() {
      Backbone.Events.on('country:selected', this.setSelectedValue.bind(this));
    },

    setSelectedValue: function(obj) {
      this.$el.val(obj.name);
      this.$el.trigger("chosen:updated");
    }

  });

})(this.App);

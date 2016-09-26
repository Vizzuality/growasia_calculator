(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Selectors = Backbone.View.extend({

    events: {
      'change' : 'onChangeTriggerValue'
    },

    model: new (Backbone.Model.extend({
      defaults: {

      }
    })),

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts);

      this.listeners();
    },

    listeners: function() {
      this.listenTo(this.model, 'change:country')
      Backbone.Events.on('map:country:selected', this.setSelectedValue.bind(this));
    },

    setSelectedValue: function(obj) {
      this.$el.val(obj.name);
      this.$el.trigger('change');
    },

    onChangeTriggerValue: function() {
      var selectedItem = this.$el.val();

      this.el.id === 'country' ? this.mode = 'regions' : this.mode = 'country';

      if (this.el.id === 'country') {
        Backbone.Events.trigger('selector:item:selected', {
          item: selectedItem,
          mode: this.mode,
          country: selectedItem
        });
      }
    }
  });

})(this.App);

(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Selectors = Backbone.View.extend({

    events: {
      'change' : 'onChangeTriggerValue'
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts);

      this.listeners();
    },

    listeners: function() {
      Backbone.Events.on('map:country:selected', this.setSelectedValue.bind(this));
    },

    setSelectedValue: function(obj) {
      var $selector = obj.mode === 'regions' ? $('#analysis_geo_location_id'):$('#country');

      obj.mode === 'regions' ? $selector.val(obj.region_id) : $selector.val(obj.name);

      $selector.trigger('change');
      $selector.trigger('chosen:updated');
    },

    onChangeTriggerValue: function(e) {
      var selectedItem = this.$el.val();

      this.el.id === 'country' ? this.mode = 'regions' : this.mode = 'country';

      if (this.mode !== 'country') {
        Backbone.Events.trigger('selector:item:selected', {
          item: selectedItem,
          mode: this.mode,
          country: selectedItem
        });
      }
    }
  });

})(this.App);

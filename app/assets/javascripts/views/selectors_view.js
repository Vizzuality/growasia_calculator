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
      this.$el.val(obj.name);
      this.$el.trigger('change');
      this.$el.trigger('chosen:updated');

      obj.mode === 'countries' && this.changeMap(obj.name);
    },

    onChangeTriggerValue: function() {
      var selectedItem = this.$el.val();
      Backbone.Events.trigger('selector:item:selected', {item: selectedItem});
    },

    changeMap: function(name) {
      $('#mapWrapper').addClass('-second-map');
      new App.View.Map({el: '#mapRegions', options:{mode: 'regions', country: name}});
    }

  });

})(this.App);

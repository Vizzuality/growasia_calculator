(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Selectors = Backbone.View.extend({

    model: new (Backbone.Model.extend()),

    events: {
      'change #country' : 'onChangeCountry',
      'change #analysis_geo_location_id' : 'onChangeRegion'
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
      this.model.on('change:country', this.changeMapMode.bind(this));
      this.model.on('change:region', this.changeMapRegion.bind(this));

      Backbone.Events.on('map:country:selected', this.setSelectedValue.bind(this));
    },

    setSelectedValue: function(obj) {
      var $selector = obj.mode === 'regions' ? $('#analysis_geo_location_id'):$('#country');

      obj.mode === 'regions' ? $selector.val(obj.region_id) : $selector.val(obj.name);

      $selector.trigger('change');
      $selector.trigger('chosen:updated');
    },


    onChangeCountry: function(e) {
      var value = $(e.currentTarget).val();

      this.model.set({
        country: value
      });
    },

    onChangeRegion: function(e) {
      var value = $(e.currentTarget).val();

      this.model.set({
        region: value
      });
    },


    changeMapMode: function() {
      Backbone.Events.trigger('selector:item:selected', {
        country: this.model.get('country')
      });
    },

    changeMapRegion: function() {
      Backbone.Events.trigger('selector:item:selected', {
        region: this.model.get('region')
      });
    }
  });

})(this.App);

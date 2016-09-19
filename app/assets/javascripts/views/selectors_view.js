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

      this.cacheVars();
      this.listeners();
    },

    listeners: function() {
      this.model.on('change:country', this.changeMapMode.bind(this));
      this.model.on('change:region', this.changeMapRegion.bind(this));

      Backbone.Events.on('map:selected', this.setSelectedItem.bind(this));
    },

    cacheVars: function() {
      this.$countriesSelector = this.$el.find('#country');
      this.$regionsSelector = this.$el.find('#analysis_geo_location_id');
    },

    setCountry: function() {
      this.$countriesSelector.val(this.model.get('country'));

      this.$countriesSelector.trigger('change');
      this.$countriesSelector.trigger('chosen:updated');
    },

    setRegion: function() {
      this.$regionsSelector.val(this.model.get('region'));

      this.$regionsSelector.trigger('change');
      this.$regionsSelector.trigger('chosen:updated');
    },

    setSelectedItem: function(obj) {
      this.model.set(obj);
    },

    onChangeCountry: function(e) {
      var value = $(e.currentTarget).val();
      var obj = {
        country: value
      };

      this.setSelectedItem(obj);
    },

    onChangeRegion: function(e) {
      var value = $(e.currentTarget).val();
      var obj = {
        region: value
      };

      this.setSelectedItem(obj);
    },


    changeMapMode: function() {
      this.setCountry();
      Backbone.Events.trigger('selector:item:selected', {
        country: this.model.get('country')
      });
    },

    changeMapRegion: function() {
      this.setRegion();
      Backbone.Events.trigger('selector:item:selected', {
        region: this.model.get('region')
      });
    }
  });

})(this.App);

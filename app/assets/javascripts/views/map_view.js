(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Map = Backbone.View.extend({

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts );

      this.model =  new App.Model.Map();

      this.model.fetch().done(function() {
        this.geom = this.model.toJSON().features;
        debugger
        this.createMap();
      }.bind(this));
    },

    createMap: function() {
      var mapOptions = {
        zoom:  1,
        center: [0, 0], //ASIA [12.24, 99.11]
        scrollWheelZoom: false,
        dragging: false,
        zoomControl: false,
        tileLayer: {
          continuousWorld: false,
          noWrap: true,
        }
      };

      this.map = new L.Map(this.el, mapOptions);

      L.geoJson(this.geom).addTo(this.map);
    }
  });

})(this.App);


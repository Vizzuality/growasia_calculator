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
        this.createMap();
      }.bind(this));
    },

    createMap: function() {
      var mapOptions = {
        zoom:  4,
        center: [37.8, -96], //ASIA [12.24, 99.11]
        scrollWheelZoom: false,
        dragging: false,
        zoomControl: false,
        tileLayer: {
          continuousWorld: false,
          noWrap: true,
        }
      };

      this.map = new L.Map(this.el, mapOptions);
      this.geoJson = L.geoJson(this.geom, {
        style: this.getStyles.bind(this),
        onEachFeature: this.onEachFeature.bind(this)
      }).addTo(this.map);
    },

    getStyles: function(feature) {
      return {
        fillColor: this.getColor(feature.properties.density),
        weight: 2,
        opacity: 1,
        color: '#fafb00',
        fillOpacity: 0.7
      };
    },

    getColor: function(d) {
      return d > 1000 ? '#800026' :
             d > 500  ? '#BD0026' :
             d > 200  ? '#E31A1C' :
             d > 100  ? '#FC4E2A' :
             d > 50   ? '#FD8D3C' :
             d > 20   ? '#FEB24C' :
             d > 10   ? '#FED976' :
                        '#FFEDA0';
    },

    highlightFeature: function(e) {
      var layer = e.target;

      layer.setStyle({
          weight: 1,
          fillColor: '#3f8c3f',
          fillOpacity: 0.7
      });

      if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
        layer.bringToFront();
      }
    },

    resetHighlight: function(e) {
      this.geoJson.resetStyle(e.target);
    },

    onEachFeature: function(feature, layer) {
      layer.on({
        mouseover: this.highlightFeature.bind(this),
        mouseout: this.resetHighlight.bind(this)
      });
    }
  });

})(this.App);


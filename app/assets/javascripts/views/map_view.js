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
        onEachFeature: this.setEvents.bind(this)
      }).addTo(this.map);
    },

    //STYLES
    getStyles: function(feature) {
      return {
        fillColor: this.getColor(feature.properties),
        weight: 2,
        opacity: this.getOpacity(feature.properties.selected),
        color: '#fafb00',
        fillOpacity: 0.7
      };
    },

    getColor: function(d) {
      return d.selected ? '#2a5a3a':
             d.density > 1000 ? '#800026' :
             d.density > 500  ? '#BD0026' :
             d.density > 200  ? '#E31A1C' :
             d.density > 100  ? '#FC4E2A' :
             d.density > 50   ? '#FD8D3C' :
             d.density > 20   ? '#FEB24C' :
             d.density > 10   ? '#FED976' :
             '#FED976';
    },

    getOpacity: function(d) {
      return d ?  1 : 0.7;
    },


    //EVENTS
    setEvents: function(feature, layer) {
      layer.on({
        mouseover: this.highlightFeature.bind(this),
        mouseout: this.resetHighlight.bind(this),
        click: this.selectCountry.bind(this)
      });
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
      var layer = e.target ? e.target : e;
      this.geoJson.resetStyle(layer);
    },

    selectCountry: function(e) {
      //Unselect previous layer
      this.selectedLayer && (this.selectedLayer.feature.properties.selected = false);
      this.selectedLayer && this.resetHighlight(this.selectedLayer);

      //Select new layer
      var layer = e.target;
      layer.feature.properties.selected = true;

      var name = layer.feature.properties.name;
      name = 'Cambodia';
      Backbone.Events.trigger('country:selected', {name: name});

      this.selectedLayer = layer;
    }
  });

})(this.App);


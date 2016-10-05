(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Map = Backbone.View.extend({

    model: new (Backbone.Model.extend({
          defaults: {
            country: 'all'
          }
        })),

    geometries: {
      all: {
        url: '../asia.geo.json',
        center: [12.24, 105],
        zoom: 4
      },
      Cambodia: {
        url: '../cambodia.geojson',
        center: [12.24, 105],
        zoom: 7
      },
      Vietnam: {
        url: '../vietnam.geojson',
        center: [12.24, 105],
        zoom: 5
      },
      Philippines: {
        url: '../philippines.geojson',
        center: [10, 125],
        zoom: 5
      },
      Myanmar: {
        url: '../myanmar.geojson',
        center: [18, 100],
        zoom: 5
      },
      Indonesia: {
        url: '../indonesia.geojson',
        center: [0, 108],
        zoom: 4
      }
    },

    countries: ['Cambodia', 'Indonesia', 'Myanmar', 'Philippines', 'Vietnam'],

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts );

      this.currentGeom = this.getCurrentGeom();

      this.model =  new App.Model.Map();

      this.createMap();
      this.getLayer();

      this.listeners();
    },

    listeners: function() {
      this.model.on('change:country', this.setSelectedCountry.bind(this));
      this.model.on('change:region', this.setSelectedRegion.bind(this));

      Backbone.Events.on('selector:item:selected', this.updateMapState.bind(this));
    },

    updateMapState: function(obj) {
      this.model.set(obj);
    },

    getCurrentGeom: function() {
      return this.geometries[this.model.get('country')];
    },

    createMap: function() {
      var mapOptions = {
        zoom: this.currentGeom.zoom || 4,
        center: this.currentGeom.center || [12.24, 105], //ASIA [12.24, 99.11]
        scrollWheelZoom: false,
        dragging: false,
        zoomControl: false,
        tileLayer: {
          continuousWorld: false,
          noWrap: true,
        }
      };

      this.map = new L.Map(this.el, mapOptions);
    },

    /*
     * LAYERS
     */
    //STYLES
    getStyles: function(feature) {
      // debugger
      var style = this.model.get('country') ? {
        fillColor: this.getColor(feature.properties),
        weight: 2,
        opacity: 0.7,
        color: '#fafb00',
        fillOpacity: this.getOpacity(feature.properties)
      } : {
        fillColor: this.getColor(feature.properties),
        weight: 2,
        opacity: this.getOpacity(feature.properties),
        color: '#fafb00',
        fillOpacity: this.getOpacity(feature.properties)
      }

      return style;
    },

    getColor: function(d) {
      return d.selected ? '#2a5a3a' : '#c1de11';
    },

    getOpacity: function(d) {
      if (this.model.get('country')) {
        return d.selected ?  1 :
               0.7;
      } else {
        return d.selected ?  1 :
               this.countries.includes(d.admin) ? 0.8 :
               0.3;
      }
    },

    //EVENTS
    setEvents: function(feature, layer) {
      layer.on({
        mouseover: this.highlightFeature.bind(this),
        mouseout: this.resetHighlight.bind(this),
        click: this.onClickSelectItem.bind(this)
      });
    },

    onClickSelectItem: function(e) {
      var layer = e.target;

      if (layer.feature.properties.admin) {
        this.model.set({country: layer.feature.properties.admin})
      } else {
        this.model.set({region: layer.feature.properties.slug})
      }
    },

    highlightFeature: function(e) {
      var layer = e.target;

      if ( this.model.get('country') || this.countries.includes(layer.feature.properties.admin) ) {
        layer.setStyle({
            weight: 1,
            fillColor: '#3f8c3f',
            fillOpacity: 0.7
        });
      }

      if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
        layer.bringToFront();
      }
    },

    resetHighlight: function(e) {
      var layer = e.target ? e.target : e;
      this.geoJson.resetStyle(layer);
    },


    unSelectPrevious: function() {
      this.selectedLayer && (this.selectedLayer.feature.properties.selected = false);
      this.selectedLayer && this.resetHighlight(this.selectedLayer);
    },

    setSelectedRegion: function() {
      var region_id = this.model.get('region');

      _.each(this.map._layers, function(layer){

        if (layer.feature && layer.feature.properties.slug === region_id) {
          layer.feature.properties.selected = true;

          layer.setStyle({fillColor: '#2a5a3a', fillOpacity: 1});
          this.unSelectPrevious();

          this.selectedLayer = layer;
        }
      }.bind(this));

      Backbone.Events.trigger('map:selected', { region: region_id });
    },

    setSelectedCountry: function() {

      this.removeLayer();
      this.currentGeom = this.getCurrentGeom(this.model.get('country'));
      this.map.setView(this.currentGeom.center, this.currentGeom.zoom);

      this.getLayer();

      Backbone.Events.trigger('map:selected', {
        country: this.model.get('country')});
    },

    removeLayer: function() {
      this.map.removeLayer(this.geoJson);
    },

    addLayer: function() {
      this.geoJson = L.geoJson(this.geom, {
        style: this.getStyles.bind(this),
        onEachFeature: this.setEvents.bind(this)
      }).addTo(this.map);
    },

    getLayer: function() {
      this.model.fetch({ url: this.currentGeom.url }).done(function() {
        this.geom = this.model.toJSON().features;
        this.addLayer();
      }.bind(this));
    }
  });

})(this.App);

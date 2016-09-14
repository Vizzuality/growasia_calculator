(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Map = Backbone.View.extend({

    geometries: {
      country: {
        url: '../asia.geo.json',
        center: [12.24, 105],
        zoom: 4
      },
      regions: {
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
          url: '../philipines.geojson',
          center: [10, 125],
          zoom: 5
        },
        Myanmar: {
          url: '../myanmar.geojson',
          center: [12, 100],
          zoom: 5
        },
        Indonesia: {
          url: '../indonesia.geojson',
          center: [0, 108],
          zoom: 4
        }
      }
    },

    countries: ['Cambodia', 'Indonesia', 'Myanmar', 'Philippines', 'Vietnam'],

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts );

      this.options.mode = this.getCurrentMode(this.options);
      this.currentGeom = this.getCurrentGeom(this.options);

      this.model =  new App.Model.Map();

      this.createMap();
      this.getLayer();

      this.listeners();
    },

    listeners: function() {
      // Backbone.Events.on('selector:item:selected', this.setSelectedItems.bind(this));
      Backbone.Events.on('selector:item:selected', this.updateMap.bind(this));
    },

    getCurrentMode: function(opt) {
      return opt.mode;
    },

    getCurrentGeom: function(opt) {
      return opt.country ? this.geometries[opt.mode][opt.country] : this.geometries[opt.mode];
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
      return {
        fillColor: this.getColor(feature.properties),
        weight: 2,
        opacity: this.getOpacity(feature.properties),
        color: '#fafb00',
        fillOpacity: this.getOpacity(feature.properties)
      };
    },

    getColor: function(d) {
      return d.selected ? '#2a5a3a' : '#c1de11';
    },

    getOpacity: function(d) {
      //As sources are different, names are different.
      //This will be fixed once we'will get the correct data
      return d.selected ?  1 :
             this.countries.includes(d.admin) ? 0.8 :
             this.countries.includes(d.ADMIN) ? 0.8 :
             0.3;
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

      if ( this.countries.includes(layer.feature.properties.admin) ) {
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

    selectCountry: function(e) {
      //Unselect previous layer
      this.unSelectPrevious();

      //Select new layer
      var layer = e.target;

      if ( this.countries.includes(layer.feature.properties.admin) ) {

        layer.feature.properties.selected = true;

        var name = layer.feature.properties.admin;
        Backbone.Events.trigger('map:country:selected', {name: name, mode: this.mode});

        this.selectedLayer = layer;
      }
    },

    unSelectPrevious: function() {
      this.selectedLayer && (this.selectedLayer.feature.properties.selected = false);
      this.selectedLayer && this.resetHighlight(this.selectedLayer);
    },

    setSelectedItems: function(obj) {
      var item = obj.item;
      var layer = _.findWhere(this.map._layers, { name : item });

      _.each(this.map._layers, function(layer){
        if (layer.feature && layer.feature.properties.admin === item) {
          layer.feature.properties.selected = true;

          layer.setStyle({fillColor: '#2a5a3a'});
          this.unSelectPrevious();

          this.selectedLayer = layer;
        }
      }.bind(this))
    },

    /*
     * MAP METHODS
     */
    updateMap: function(obj) {
      this.removeLayer();
      this.mode = this.getCurrentMode(obj);
      this.currentGeom = this.getCurrentGeom(obj);

      this.map.setView( this.currentGeom.center, this.currentGeom.zoom);

      this.getLayer();
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


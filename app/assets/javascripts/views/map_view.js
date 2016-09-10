(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Map = Backbone.View.extend({

    defaults: {
      cartoAccount: 'goal16',
      tolerance: .5,
      query: {
        all: 'SELECT * FROM countries',
        region: ''
      },
      css: {
        all: '#countries{ polygon-fill: #c1de11; polygon-opacity: 0.4; line-color: #fafb00; line-width: 2; line-opacity: 1; }',
        region: ''
      },
      zoom: 4,
      lat: 7.92,
      lng: 112.8
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts );

      this.createMap();

      this.render();
    },

    listeners: function() {},

    render: function() {

    },


    createMap: function() {
      // var southWest = L.latLng(-80, 124),
      //     northEast = L.latLng(80, -124),
      //     bounds = L.latLngBounds(southWest, northEast);

      var mapOptions = {
        zoom: this.options.zoom,
        center: [this.options.lat, this.options.lng],
        scrollWheelZoom: false,
        zoomControl: false,
        tileLayer: {
          continuousWorld: false,
          noWrap: true,
        }
      };

      this.map = new L.Map(this.el, mapOptions);

      /* Needed for the initialization of the SVG layer */
      this.bounds = this.map.getBounds();

      this.initLayer().done(function() {
        this.map.addLayer(this.layer)
      }.bind(this))
    },


    /**
     * Init the layer and return a deferred Object
     * @return {Object} jQuery deferred object
     */
    initLayer: function() {
      var deferred = $.Deferred();
      var query = this.options.query.all;

      var request = {
        layers: [{
          'user_name': this.options.cartoAccount,
          'type': 'cartodb',
          'options': {
            'sql': query,
            'cartocss': this.options.css.all,
            'cartocss_version': '2.3.0'
          }
        }]
      };

      $.ajax({
        type: 'POST',
        dataType: 'json',
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
        url: 'https://'+ this.options.cartoAccount +'.cartodb.com/api/v1/map/',
        data: JSON.stringify(request),
      }).done(_.bind(function(data) {
        var tileUrl = 'https://'+ this.options.cartoAccount +'.cartodb.com/api/v1/map/'+ data.layergroupid + '/{z}/{x}/{y}.png32';
        this.layer = L.tileLayer(tileUrl, { noWrap: true, https: true });
        return deferred.resolve();
      }, this));

      return deferred;
    },


  });

})(this.App);


(function(App) {

  'use strict';

  App.Model = App.Model || {};

  App.Model.Map = Backbone.Model.extend({

    url: '../usa.geojson',

    parse: function(data) {
      return data;
    },
});

})(this.App);

(function(App) {

  'use strict';

  App.Model = App.Model || {};

  App.Model.Map = Backbone.Model.extend({

    url: '../custom.geo.json',

    parse: function(data) {
      return data;
    },
});

})(this.App);

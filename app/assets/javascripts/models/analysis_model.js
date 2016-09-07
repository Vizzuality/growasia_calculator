(function(App) {

  'use strict';

  App.Model = App.Model || {};

  App.Model.Analysis = Backbone.Model.extend({

    urlRoot: '/api/v1/analyses',

    parse: function(data) {
      return data;
    },
});

})(this.App);

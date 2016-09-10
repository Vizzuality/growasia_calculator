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

      console.log(this.options)
      debugger

      this.render();
    },

    listeners: function() {},

    render: function() {
      console.log('render');
    },

  });

})(this.App);

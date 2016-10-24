(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Chart = Backbone.View.extend({

    model: new (Backbone.Model.extend()),

    defaults: {
      color: {
        pattern: ['#c1de11', '#8ac230']
      }
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({
        bindto: this.$el.find('.chart')[0]
      }, this.defaults, opts);

      this.listeners();
      this.render();
    },

    listeners: function() {
      // App.Events.on('params:update', function(params){
      //   this.params = params;
      //   var newParams = this.setParams(params.type);
      //   this.model.set(newParams);
      // }.bind(this));

      // this.model.on('change', this.render.bind(this));
    },

    render: function() {
      this.chart = c3.generate(this.options);
    },


  });

})(this.App);

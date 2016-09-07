(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Chart = Backbone.View.extend({

    model: new (Backbone.Model.extend()),

    defaults: {
      color: {
        pattern: ['#c1de11', '#8ac230', '#3f8c3f', '#2a5a3a', '#194b32', '#d62728', '#ff9896', '#9467bd', '#c5b0d5', '#8c564b', '#c49c94', '#e377c2', '#f7b6d2', '#7f7f7f', '#c7c7c7', '#bcbd22', '#dbdb8d', '#17becf', '#9edae5']
      }
    },

    colors: {
      'projects': '-color-1',
      'events': '-color-2',
      'default': '-color-1'
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
      var chart = c3.generate(this.options);
    },


  });

})(this.App);

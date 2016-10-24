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
        bindto: this.$el.find('.graph')[0]
      }, this.defaults, opts);

      this.render();
    },

    render: function() {
      this.chart = c3.generate(this.options);
    }

  });

})(this.App);

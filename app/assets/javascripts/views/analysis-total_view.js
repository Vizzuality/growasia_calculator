(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisTotal = Backbone.View.extend({

    template: HandlebarsTemplates['analysis-total'],
    templateCompare: HandlebarsTemplates['analysis-total-compare'],

    initialize: function(settings) {
      if (!this.el) {
        return;
      }
      this.model = settings.model;
      this.modelCompare = settings.modelCompare;

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend(this.defaults, opts);

      this.cache();
      this.listeners();
    },

    cache: function() {

    },

    listeners: function() {
      this.model.on('change', this.render.bind(this));
      this.modelCompare.on('change', this.update.bind(this));
    },

    render: function() {
      var analysis = this.model.get('analysis');
      this.$el.html(this.template({
        total: d3.format('.2s')(analysis.total)
      }));
      console.log('render');
    },

    update: function() {
      var analysis = this.model.get('analysis');
      var analysisCompare = this.modelCompare.get('analysis');
      var difference = analysis.total - analysisCompare.total;
      this.$el.html(this.templateCompare({
        total: d3.format('.2s')(difference)
      }));
      console.log('update');
    }

  });

})(this.App);

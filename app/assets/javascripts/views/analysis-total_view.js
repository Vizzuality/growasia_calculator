(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisTotal = Backbone.View.extend({

    template: HandlebarsTemplates['analysis-total'],

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
      this.modelCompare.on('change', this.render.bind(this));
    },

    render: function() {
      var analysis = this.model.get('analysis');
      var analysisCompare = this.modelCompare.get('analysis');

      var total = (!!analysis) ? d3.format('.3s')(analysis[this.model.get('type')]) : null;
      var totalCompare = (!!analysisCompare) ? d3.format('.3s')(analysisCompare[this.modelCompare.get('type')]) : null;

      this.$el.html(this.template({
        total: total,
        totalCompare: totalCompare
      }));
    },

  });

})(this.App);

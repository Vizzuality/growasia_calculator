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

      var total = (!!analysis) ? this.formatNumbers(analysis[this.model.get('type')]) : null;

      var totalCompare = (!!analysisCompare) ? this.formatNumbers(analysisCompare[this.modelCompare.get('type')]) : null;

      var substraction = (totalCompare - total).toFixed(2);

      this.$el.html(this.template({
        total: total,
        totalCompare: totalCompare,
        substraction: substraction
      }));
    },

    formatNumbers: function (v) {
      if (v > 1000 || v < -1000) {
        return d3.format('.3s')(v);
      } else {
        return d3.round(v, 3);
      }
    }
  });

})(this.App);

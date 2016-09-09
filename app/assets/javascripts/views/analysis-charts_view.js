(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisCharts = Backbone.View.extend({
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
      var emissions_by_source = this.model.get('analysis').emissions_by_source;

      this.chart1 = new App.View.Chart({
        el: '#chart-1',
        options: {
          data: {
            json: {
              'Current practices': _.pluck(emissions_by_source, 'total')
            },
            type: 'bar',
            order: null
          },
          bar: {
            width: {
              ratio: 0.5 // this makes bar width 50% of length between ticks
            }
          },
          axis: {
            x: {
              type: 'category',
              categories: _.pluck(emissions_by_source, 'name')
            },
            y: {
              tick: {
                format: d3.format('.2s')
              }
            }
          },
          legend: {
            show: false
          }
        }
      });

    },

    update: function() {
      var emissions_by_source = this.modelCompare.get('analysis').emissions_by_source;

      this.chart1.chart.load({
        json: {
          'Potential future': _.pluck(emissions_by_source, 'total')
        },
        categories: _.pluck(emissions_by_source, 'name')
      })
    }

  });

})(this.App);

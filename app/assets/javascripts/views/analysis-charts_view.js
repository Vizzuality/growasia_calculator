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

    cache: function() {},

    listeners: function() {
      this.model.on('change', this.render.bind(this));
      this.modelCompare.on('change', this.update.bind(this));
    },

    render: function() {
      var emissions_by_source = this.model.get('analysis').emissions_by_source;
      var chartDiv = this.$el.find('.c-graph').attr('id');

      this.chart1 = new App.View.Chart({
        el: '#' + chartDiv,
        options: {
          data: {
            json: {
              'Current practices': _.pluck(emissions_by_source, this.model.get('type'))
            },
            labels: {
              format: function (v, id, i, j) {
                if (v > 1000 || v < -1000) {
                  return d3.format('.3s')(v);
                } else {
                  return d3.round(v, 3);
                }
              }
            },
            type: 'bar',
            order: null
          },
          size: {
            width: this.$el.find('.graph').width()
          },
          bar: {
            width: {
              ratio: 0.75 // this makes bar width 50% of length between ticks
            }
          },
          axis: {
            x: {
              type: 'category',
              categories: _.pluck(emissions_by_source, 'name'),
              tick: {
                rotate: chartDiv === 'chart-print' && 30
              }
            },
            y: {
              label: {
                text: 't of CO2e',
                position: 'outer-middle'
              },
              tick: {
                format: function (v, id, i, j) {
                  if (v > 1000 || v < -1000) {
                    return d3.format('.3s')(v);
                  } else {
                    return d3.round(v, 3);
                  }
                }
              }
            }
          },
          grid: {
            y: {
              lines: [
                {value: 0}
              ]
            }
          }
        }
      });
    },

    update: function() {
      if (this.modelCompare.get('analysis')) {
        var emissions_by_source = this.modelCompare.get('analysis').emissions_by_source;

        this.chart1.chart.load({
          json: {
            'Potential future': _.pluck(emissions_by_source, this.modelCompare.get('type'))
          },
          categories: _.pluck(emissions_by_source, 'name')
        })
      }
    }

  });

})(this.App);

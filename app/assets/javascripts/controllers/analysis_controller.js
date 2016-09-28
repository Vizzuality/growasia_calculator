(function(App) {

  'use strict';

  App.Controller = App.Controller || {};

  App.Controller.Analysis = App.Controller.Page.extend({

    index: function(params) {
      new App.View.Header({
        el: '#headerView'
      });

      new App.View.Slider({
        params: params,
        el: '#sliderView'
      });

      new App.View.Map({el: '#mapCountries', options:{mode: 'country'}});

      new App.View.Selectors({el: '#mapSelectors'});

      this.addSelectLib();
      this.addFields();
      this.removeFields();
    },

    show: function(params) {

      var analysisModel = new App.Model.Analysis({
        id: params.id
      });
      var analysisCompareModel = new App.Model.Analysis({
        id: params.id
      });

      var analysisActionsView = new App.View.AnalysisActions({
        el: '#analysisActions'
      });

      var analysisSidebarView = new App.View.AnalysisSidebar({
        el: '#analysisSidebarView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      });

      var analysisTotalView = new App.View.AnalysisTotal({
        el: '#analysisTotalView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      });

      var analysisChartsView = new App.View.AnalysisCharts({
        el: '#analysisChartsView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      });

      var shareModalView = new App.View.Share({});
      var saveModalView = new App.View.Save({});

      // Fetch the analysis before render the graphs
      analysisModel.fetch();

      this.addSelectLib();
    },

    addSelectLib: function() {
      $('select').select2({
        theme: "default",
        minimumResultsForSearch: -1
      });
    },

    addFields: function() {
      $(document).on('click', '.add_fields', function(event) {
        var regexp, time;
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
        return event.preventDefault();
      });
    },

    removeFields: function() {
      $(document).on('click', '.remove_fields', function(event) {
        $(this).prev('input[type=hidden]').val('1');
        $(this).closest('div').hide();
        return event.preventDefault();
      });
    }

  });


})(this.App);

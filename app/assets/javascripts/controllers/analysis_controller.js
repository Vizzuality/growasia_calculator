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

      var infoModalView = new App.View.ModalInfo({});

      this.addSelectLib();
      this.selectFields();
    },

    show: function(params) {
      new App.View.Header({
        el: '#headerView'
      });

      var analysisModel = new App.Model.Analysis({
        id: params.id,
        type: 'total'
      });
      var analysisCompareModel = new App.Model.Analysis({
        id: params.id,
        type: 'total'
      });

      var analysisActionsView = new App.View.AnalysisActions({
        el: '#analysisActions',
        model: analysisModel
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

      var analysisToggleView = new App.View.AnalysisToggle({
        el: '#analysisToggleView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      })

      var shareModalView = new App.View.Share({});
      var saveModalView = new App.View.Save({});
      var infoModalView = new App.View.ModalInfo({});
      infoModalView.setGuidance({guidanceType: 'analysis-results'});

      // Fetch the analysis before render the graphs
      analysisModel.fetch();

      this.addSelectLib();
    },

    addSelectLib: function() {
      var $selectors = $('select');

      $selectors.select2({
        theme: "default",
        minimumResultsForSearch: -1,
      });

      $.each($selectors, function() {
        var classList = this.className.split(/\s+/);
        for (var i = 0; i < classList.length; i++) {
          if (classList[i].includes('theme')) {
            $(this).next('.select2-container').addClass(classList[i]);
          }
        }
      });

      //Only for select in sidebar
      $('.analyses_show .select2-container').on('click', function(e) {
        var classList = e.currentTarget.className.split(/\s+/);
        for (var i = 0; i < classList.length; i++) {
          if (classList[i].includes('theme')) {
            $('.select2-dropdown').addClass(classList[i]);
          }
        }
      });
    }

  });


})(this.App);

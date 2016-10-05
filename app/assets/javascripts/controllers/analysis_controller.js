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
      this.removeFields();
      this.selectFields();
    },

    show: function(params) {

      var analysisModel = new App.Model.Analysis({
        id: params.id,
        type: 'total'
      });
      var analysisCompareModel = new App.Model.Analysis({
        id: params.id,
        type: 'total'
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

      var analysisToggleView = new App.View.AnalysisToggle({
        el: '#analysisToggleView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      })

      var shareModalView = new App.View.Share({});
      var saveModalView = new App.View.Save({});

      // Fetch the analysis before render the graphs
      analysisModel.fetch();

      this.removeFields();

      this.addSelectLib();
    },

    addSelectLib: function() {

      var $selectors = $('select');

      $selectors.select2({
        theme: "default",
        minimumResultsForSearch: -1
      });

      $.each($selectors, function(i, input) {
        if ($(input).hasClass('-js-required')) {
          $(input).siblings('.select2-container').addClass('-js-required');
        }
      }.bind(this))
    },

    selectFields: function() {
      var that = this;
      $(document).on('change', '.-js-select-fields', function(event) {
        event.preventDefault();
        var selectedVal = $(this).val();

        if(!!selectedVal) {
          var regexp, time;
          time = new Date().getTime();
          regexp = new RegExp($(this).data('id'), 'g');

          var $newFields = $(this).data('fields').replace(regexp, time)
          var selectId = $($newFields).find('select').attr('id');

          $('#options-container').append($newFields);
          $('#'+selectId).val(selectedVal);
          that.addSelectLib();
          $(this).val('');
          $(this).trigger('change');
        }
      });
    },

    removeFields: function() {
      $(document).on('click', '.-js-remove-fields', function(event) {
        event && event.preventDefault();
        $(this).prev('input[type=hidden]').val('1');
        $(this).parents('.-js-input-wrapper').hide();
        return event.preventDefault();
      });
    }

  });


})(this.App);

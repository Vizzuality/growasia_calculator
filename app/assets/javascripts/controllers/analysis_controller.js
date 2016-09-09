(function(App) {

  'use strict';

  App.Controller = App.Controller || {};

  App.Controller.Analysis = App.Controller.Page.extend({

    index: function() {

      new App.View.Steps({el: '#slider'})

      $('select').chosen();
      $('select.-input-big').chosen({'width':'360px' });
      $('select.-input-small').chosen({'width':'208px' });

      $('#country').change(function() {
        if($(this).val() !== '') {
          var timeOut;

          $.get('/geo_locations/states_for/'+$(this).val());

          //This is the most awful thing I have one in a while...
          clearTimeout(timeOut);
          timeOut = setTimeout(function() {
            $("#analysis_geo_location_id").trigger("chosen:updated");
          }, 400);

        } else {
          $("#state-selection").addClass("hidden");
        }
      });

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

      var analysisChartsView = new App.View.AnalysisCharts({
        el: '#analysisChartsView',
        model: analysisModel,
        modelCompare: analysisCompareModel
      });


      // Fetch the analysis before render the graphs
      analysisModel.fetch();
    },

  });


})(this.App);

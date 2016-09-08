(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.AnalysisActions = Backbone.View.extend({

    model: new (Backbone.Model.extend()),

    events: {
      'click .js-btn-action' : 'onClickAction'
    },

    initialize: function(settings) {
      if (!this.el) {
        return;
      }

      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend(this.defaults, opts);

      this.listeners();
      this.render();
    },

    listeners: function() {
      // This is just an example of how it will work
      App.Events.on('Save:toggle', function(){
        console.log('// This is just an example of how it will work: Save:toggle');
      }.bind(this));
    },

    render: function() {
      // var chart = c3.generate(this.options);
    },

    /*
    * UI EVENTS
    */
    onClickAction: function(e) {
      e && e.preventDefault();
      var action = $(e.currentTarget).data('action');
      console.log(action);
      App.Events.trigger(action);
    }


  });

})(this.App);

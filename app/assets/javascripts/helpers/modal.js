(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  App.Helper.Modal = Backbone.View.extend({

    el: 'body',

    template: HandlebarsTemplates['modal-window'],

    events: function() {
      if (window.ontouchstart) {
        return  {
          'touchstart .btn-close-modal': 'close',
          'touchstart .modal-background': 'close'
        };
      }
      return {
        'click .btn-close-modal': 'close',
        'click .modal-background': 'close'
      };
    },

    initialize: function() {
      this.render();
      $(document).keyup(_.bind(this.onKeyUp, this));
    },

    render: function() {
      this.$el.append(this.template());
      this.toogleState();
    },

    onKeyUp: function(e) {
      e.stopPropagation();
      // press esc
      if (e.keyCode === 27) {
        this.close();
      }
    },

    close: function() {
      $('.c-modal-window').remove();
      this.toogleState();
    },

    toogleState: function() {
      this.$el.toggleClass('has-no-scroll');
      $('html').toggleClass('has-no-scroll');
    }

  });

})(this.App);

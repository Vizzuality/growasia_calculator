(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  App.Helper.Modal = Backbone.View.extend({

    model: new (Backbone.Model.extend({
      defaults: {
        hidden: true
      }
    })),

    events: {
      'click .js-btn-modal-close' : 'onClickClose',
    },

    initialize: function() {
      // All the methods that has _ is because they belong to the Parent View
      this._cache();
      this._listeners();
    },

    _listeners: function() {
      this.model.on('change:hidden', this.changeHidden, this);
    },

    _cache: function() {
      this.$window = $(window);
      this.$document = $(document);
      this.$body = $('body');
      this.$htmlbody = $('html, body');

      this.$content =        this.$el.find('.modal-content');
      this.$contentWrapper = this.$el.find('.modal-wrapper');
      this.$backdrop =       this.$el.find('.modal-backdrop');
      this.$close =          this.$el.find('.modal-close');
    },


    /**
     * MODEL CHANGES
     * -changeHidden
     */
    changeHidden: function() {
      var hidden = !!this.model.get('hidden');

      // Set bindings
      (hidden) ? this.unsetBindings() : this.setBindings();
      // Toggle states
      this.$el.toggleClass('-active', !hidden);
    },


    /**
     * UI EVENTS
     * - show
     * - hide
    */
    onClickClose: function(e) {
      e && e.preventDefault();
      this.hide();
    },

    /**
     * SETTERS
     * - show
     * - hide
     * - toggle
     */
    show: function() {
      this.model.set('hidden', false);
    },

    hide: function() {
      this.model.set('hidden', true);
    },

    toggle: function() {
      var hidden = this.model.get('hidden');
      this.model.set('hidden', !hidden);
    },


    /**
     * BINDINGS
     * - setBindings
     * - unsetBindings
     */
    setBindings: function() {
      // document keyup
      this.$document.on('keyup.modal', _.bind(function(e) {
        if (e.keyCode === 27) {
          this.hide();
        }
      },this));
    },

    unsetBindings: function() {
      this.$document.off('keyup.modal');
    },

  });

})(this.App);

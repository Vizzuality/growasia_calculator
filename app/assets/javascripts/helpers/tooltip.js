(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  App.Helper.Tooltip = Backbone.View.extend({

    initialize: function() {
      // The model must be initialized here in a parent view, if we don't do that all the child views will share the same model.
      // Yes I know, a little bit crazy

      this.model = new (Backbone.Model.extend({
        defaults: {
          hidden: true
        }
      })),

      // All the methods that has _ is because they belong to the Parent View
      this._cache();
      this._listeners();
    },

    _listeners: function() {
      this.model.on('change:hidden', this.changeHidden, this);
    },

    _cache: function() {
      this.$document = $(document);
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
      this.$el.toggleClass('-opened', !hidden);
    },


    /**
     * UI EVENTS
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
      this.$document.on('click.tooltip'+this.cid, function(e) {
        if(!this.el.contains(e.target) && e.target !== this.model.get('currentTarget')) {
          this.hide();
        }
      }.bind(this));
    },

    unsetBindings: function() {
      this.$document.off('click.tooltip'+this.cid);
    }

  });

})(this.App);

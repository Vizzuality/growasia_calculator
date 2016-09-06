(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  /**
   * Helper function to correctly set up the prototype chain for subclasses.
   * Similar to `goog.inherits`, but uses a hash of prototype properties and
   * class properties to be extended.
   * @param {Object} attributes
   */
  App.Helper.Class = function(attributes) {
    this.initialize.apply(this, arguments);
  };

  _.extend(App.Helper.Class.prototype, {});

  /**
   * Using Backbone Helper
   * https://github.com/jashkenas/backbone/blob/master/backbone.js#L1821
   * @type {Object}
   */
  App.Helper.Class.extend = Backbone.View.extend;

})(this.App);
(function(App) {

  'use strict';

  App.Helper = App.Helper || {};

  /**
   * Helper function to correctly set up the prototype chain for subclasses.
   * Similar to `goog.inherits`, but uses a hash of prototype properties and
   * class properties to be extended.
   * @param {Object} attributes
   */
  App.Helper.Utils = {

    getParams: function(paramString) {
      var params = {};
      paramString.split('&').forEach(function(pair) {
        pair = pair.split('=');
        var key = decodeURIComponent(pair[0]),
            val = decodeURIComponent(pair[1]),
            val = val ? val.replace(/\++/g,' ').trim() : '';

        if (key.length === 0) {
          return;
        }
        if (params[key] === undefined) {
          params[key] = (!!val && !isNaN(val)) ? Number(val) : val || null;
        }
        else {
          if ("function" !== typeof params[key].push) {
            params[key] = [params[key]];
          }

          params[key].push((!isNaN(val)) ? Number(val) : val || null);
        }

      });

      return params;
    },

    getTimelinePercentage: function(startDate, endDate) {
      var current = new Date().getTime();
      var start = new Date(startDate).getTime();
      var end = new Date(endDate).getTime();
      var percentage = 0;

      if ( current > end ) {
        percentage = 100;
      } else if (current < start ) {
        percentage = 0;
      } else {
        percentage = ((current - start) * 100 ) / ( end - start );
      }

      return percentage;
    }

  }

})(this.App);

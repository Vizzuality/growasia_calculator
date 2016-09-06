(function(App) {

  'use strict';

  App.Controller = App.Controller || {};

  App.Controller.Home = App.Controller.Page.extend({

    index: function() {
      console.log('home#index');
    }

  });


})(this.App);

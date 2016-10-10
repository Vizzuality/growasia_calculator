(function(App) {

  'use strict';

  App.Controller = App.Controller || {};

  App.Controller.Home = App.Controller.Page.extend({

    index: function() {
      new App.View.Header({
        el: '#headerView'
      });
      console.log('home#index');
      var infoModalView = new App.View.ModalInfo({});
      infoModalView.setGuidance({guidanceType: 'home-page'});
    }

  });


})(this.App);

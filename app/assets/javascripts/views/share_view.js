(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.Share = App.Helper.Modal.extend({

    id: 'share-modal',

    className: 'c-modal',

    template: HandlebarsTemplates['share'],

    events: function(){
      return _.extend({}, App.Helper.Modal.prototype.events,{
        'click .js-input-copy' : 'onClickInputCopy',
        'click .js-btn-copy'   : 'onClickCopy',
        'click .js-btn-popup'  : 'onClickPopup',
      });
    },

    initialize: function(settings) {
      // Initialize parent
      this.constructor.__super__.initialize.apply(this);

      // Options
      var opts = settings && settings.options ? settings.options : {};
      this.options = _.extend({}, this.defaults, opts);

      // Render and add it to body
      this.render();
      this.$body.append(this.el);

      // Set listeners and cache
      this.cache();
      this.listeners();
    },

    cache: function() {
      this.$copyInput = this.$el.find('.js-input-copy');
      this.$copyBtn = this.$el.find('.js-btn-copy');
    },

    listeners: function() {
      App.Events.on('Share:toggle', this.toggle.bind(this));
    },

    render: function() {
      this.$el.html(this.template({
        url: window.location.href,
        urlEncoded: encodeURIComponent(window.location.href)
      }));
    },

    // UI EVENTS
    onClickPopup: function(e) {
      e && e.preventDefault();
      var width  = 575,
          height = 400,
          left   = ($(window).width()  - width)  / 2,
          top    = ($(window).height() - height) / 2,
          url    = $(e.currentTarget).attr('href'),
          opts   = 'status=1' +
                   ',width='  + width  +
                   ',height=' + height +
                   ',top='    + top    +
                   ',left='   + left;

      window.open(url, 'Share this analysis', opts);
    },

    onClickCopy: function(e) {
      e && e.preventDefault();
      this.$copyInput.select();

      try {
        var successful = document.execCommand('copy');
        this.$copyBtn.html('copied')
      } catch(err) {
        alert('Your browser doesn\'t support this feature. You need to copy manually the input.');
      }
    },

    onClickInputCopy: function(e) {
      e && e.preventDefault();
      this.$copyInput.select();
    }

  });

})(this.App);

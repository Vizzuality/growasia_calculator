(function(App) {

  'use strict';

  App.View = App.View || {};

  App.View.ModalInfo = App.Helper.Modal.extend({

    id: 'info-modal',

    className: 'c-modal',

    template: HandlebarsTemplates['modal-window'],

    events: function(){
      return _.extend({}, App.Helper.Modal.prototype.events,{
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
    },

    listeners: function() {
      App.Events.on('Info:toggle', this.toggle.bind(this));
      App.Events.on('Slider:changeStep', this.setStep.bind(this));

      this.model.on('change:guidanceTemplateName', this.setModalContent.bind(this));
    },

    render: function() {
      this.$el.html(this.template());
    },

    setStep: function(sliderModel) {
      this.model.set({
        guidanceTemplateName: sliderModel.stepContentType
      });
    },

    setModalContent: function() {
      this.$('.c-info').html(HandlebarsTemplates['guidance/'+this.model.get('guidanceTemplateName')]());
   }

  });

})(this.App);

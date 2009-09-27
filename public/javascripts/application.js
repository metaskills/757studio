
// TheSite class for simple global behavior.

var StudioApp = {
  
  messagesToAlert: function(request) {
    var messages = request.responseJSON;
    var alertText = messages.join(".\n");
    if (alertText.endsWith('.')) { alert(alertText); } else { alert(alertText+'.'); };
  }
  
};


// RSVP Form

var RsvpForm = Class.create({
  
  initialize: function() {
    this.button = $('rsvp_button');
    this.text = $('rsvp_text');
    this.formDiv = $('rsvp_form');
    this.form = this.formDiv.down('form');
    this.flashGood = $('rsvp_flash_good');
    this.flashBad = $('rsvp_flash_bad');
    this.nameField = $('rsvp_name');
    this.emailField = $('rsvp_email');
    this.submit = $('rsvp_submit');
    this.cancel = $('rsvp_cancel');
    this.loading = $('rsvp_loading');
    this._initEvents();
  },
  
  flash: function(mood,message) {
    if (mood == 'good') {
      this.flashBad.hide();
      this.flashGood.update(message);
      this.flashGood.show();
    }
    else {
      this.flashGood.hide();
      this.flashBad.update(message);
      this.flashBad.show();
    };
  },
  
  showForm: function() {
    this.button.blindUp({duration:0.5});
    this.formDiv.blindDown({duration:0.5});
  },
  
  hideForm: function() {
    this.button.blindDown({duration:0.5});
    this.formDiv.blindUp({duration:0.5});
  },
  
  submitForm: function(event) {
    event.stop();
    if ($F(this.nameField).blank() || $F(this.emailField).blank()) {
      this.flash('bad','Name and email are required.');
      return false;
    }
    else {
      this.loading.show();
      new Ajax.Request(this.form.action,{
        onComplete: this.completeRequest.bind(this),
        parameters: this.form.serialize(),
        method: 'post'
      });
      this.form.disable();
      return true;
    };
  },
  
  completeRequest: function(response) {
    var email = $F(this.emailField);
    this.loading.hide();
    this.form.enable();
    if (response.request.success()) {
      this.form.reset();
      this.formDiv.blindUp({duration:0.5});
      this.flash('good','Please verify your reservation by clicking the link contained in the email we just sent to you at ' + email + '.');
    }
    else {
      this.flash('bad','Any unknown error occured when sending your RSVP.');
    };
  },
  
  _initEvents: function() {
    this.button.observe('click',this.showForm.bindAsEventListener(this));
    this.cancel.observe('click',this.hideForm.bindAsEventListener(this));
    this.form.observe('submit',this.submitForm.bindAsEventListener(this));
  }
  
});

document.observe('dom:loaded', function(){
  window.rsvpForm = new RsvpForm();
});






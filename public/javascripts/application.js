
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
    this.flashIndif = $('rsvp_flash_indif');
    this.yourEmail = $('your_rsvp_email');
    this.flashBad = $('rsvp_flash_bad');
    this.nameField = $('rsvp_name');
    this.emailField = $('rsvp_email');
    this.submit = $('rsvp_submit');
    this.cancel = $('rsvp_cancel');
    this.loading = $('rsvp_loading');
    this._initEvents();
  },
  
  flash: function(mood,message) {
    if (mood == 'indif') {
      this.flashBad.hide();
      this.yourEmail.update(message);
      this.flashIndif.show();
    }
    else {
      this.flashIndif.hide();
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
      this.flash('indif',email);
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



var ReservationForm = Class.create({
  
  initialize: function() {
    this.form = $('edit_rsvp_form');
    this.attendeeNamesTd = $('attendee_names');
    this._initEvents();
  },
  
  nameDivs: function() {
    return this.attendeeNamesTd.select('div.attendee_name');
  },
  
  addImage: function() {
    return this.attendeeNamesTd.down('img.addImg');
  },
  
  deleteImages: function() {
    return this.attendeeNamesTd.select('img.delImg');
  },
  
  addDelImages: function() {
    return this.attendeeNamesTd.select('img.addDelImg');
  },
  
  addAttendee: function(event) {
    var newFieldDiv = DIV({className:'attendee_name vmiddle_all pb10'},[INPUT({name:'rsvp[attendee_names][]',type:'text',value:''}),SPAN(' ')]);
    this.attendeeNamesTd.insert({bottom:newFieldDiv});
    this._buildAttendeeImages();
  },
  
  deleteAttendee: function(event) {
    var fieldDiv = event.element().up('div.attendee_name');
    var field = fieldDiv.down('input');
    var lastOne = this.nameDivs().size() == 1;
    if (lastOne) {
      field.clear();
    } else {
      fieldDiv.remove();
      this._buildAttendeeImages();
    };
  },
  
  _buildAttendeeImages: function() {
    this._destroyAttendeeImages();
    var nameDivs = this.nameDivs();
    var lastIndex = nameDivs.size()-1;
    var addImg = IMG({src:'/images/layout/add.png',className:'p5 pointer addDelImg addImg'});
    nameDivs.each(function(field,index){
      var delImg = IMG({src:'/images/layout/delete.png',className:'p5 pointer addDelImg delImg'});
      field.insert({bottom:delImg});
      if (index == lastIndex) { field.insert({bottom:addImg}); };
    });
    this._initAttendeeImages();
  },
  
  _destroyAttendeeImages: function() {
    this.addDelImages().invoke('remove');
  },
  
  _initAttendeeImages: function() {
    this.addImage().observe('click',this.addAttendee.bindAsEventListener(this));
    this.deleteImages().each(function(delImg){
      delImg.observe('click',this.deleteAttendee.bindAsEventListener(this));
    }.bind(this));
  },
  
  _initEvents: function() {
    this._buildAttendeeImages();
  }

});





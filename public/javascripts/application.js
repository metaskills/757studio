
// Window Utility

var ThePage = {
  
  pageSize: function() { 
    var xScroll, yScroll;
    if (window.innerHeight && window.scrollMaxY) {	
  		xScroll = window.innerWidth + window.scrollMaxX;
  		yScroll = window.innerHeight + window.scrollMaxY;
  	} else if (document.body.scrollHeight > document.body.offsetHeight){
  		xScroll = document.body.scrollWidth;
  		yScroll = document.body.scrollHeight;
  	} else {
  		xScroll = document.body.offsetWidth;
  		yScroll = document.body.offsetHeight;
  	}
	  var windowWidth, windowHeight;
  	if (self.innerHeight) {
  		if(document.documentElement.clientWidth){
  			windowWidth = document.documentElement.clientWidth; 
  		} else {
  			windowWidth = self.innerWidth;
  		}
  		windowHeight = self.innerHeight;
  	} else if (document.documentElement && document.documentElement.clientHeight) {
  		windowWidth = document.documentElement.clientWidth;
  		windowHeight = document.documentElement.clientHeight;
  	} else if (document.body) { 
  		windowWidth = document.body.clientWidth;
  		windowHeight = document.body.clientHeight;
  	}	
  	if(yScroll < windowHeight){
  		pageHeight = windowHeight;
  	} else { 
  		pageHeight = yScroll;
  	}
  	if(xScroll < windowWidth){	
  		pageWidth = xScroll;		
  	} else {
  		pageWidth = windowWidth;
  	}
  	return { width: pageWidth, height: pageHeight };
  }
  
};


// TheSite class for simple global behavior.

var TheSite = Class.create({
  
  initialize: function() {
    this.masthead = $('masthead');
    this.brickTile = $('brick_tile');
    this.navTile = $('nav_tile');
    this.content = $('content');
    this._initEvents();
  },
  
  adjustContentHeight: function() {
    var pageHeight = ThePage.pageSize().height;
    var mastheadHeight = this.masthead.getHeight();
    var contentHeight = pageHeight - mastheadHeight;
    this.content.setStyle({height:contentHeight+'px'});
  },
  
  _initEvents: function() {
    this.adjustContentHeight();
    Event.observe(window,'resize', this.adjustContentHeight.bindAsEventListener(this));
  }
  
});

document.observe('dom:loaded', function(){
  // window.theSite = new TheSite();
});


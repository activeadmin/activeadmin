describe("aaPopover", function() {

	var $wrapper;
	var $button;
	var $popover;
	var popover;

  beforeEach(function() {
				
    $wrapper = $(inject({
    	  					id: 'wrapper',
    						}));
	
    $button = $(inject({
    	  				el: 'a',
    	  				id: 'my_popover_button',
    	  				attrs: {href: '#my_popover'}
    					}));
    
    $popover = $(inject({
    	  					id: 'my_popover'
    						}));

    $button.aaPopover({
    	  							fadeInDuration: 0,
    	  							fadeOutDuration: 0,
    								});

    popover = $button.data("aaPopover");
  });
  
  describe("opening button / link is pressed", function() {
    it("should open the popover", function() {
      $button.trigger("click");
      expect($("#my_popover")).toBeVisible();
    });  
  });
  
  describe("when initiated", function() {
    it("should be hidden", function() {
      expect($popover).toBeHidden();
    });
    
    it("should be have class popover", function() {
      expect($popover).toHaveClass("popover");
    });
    
    describe("nipple", function() {
      it("should exist", function() {
        expect($popover).toContain(".popover_nipple");
      });
    });
  });
  
  describe("when open is called", function() {
    beforeEach(function() {
      expect($popover).toBeHidden();
      $button.aaPopover('open');
    });
    
    it("should be open", function() {
      expect($popover).toBeVisible();
    });
    
    // @ToDo Can't figure out how to test this yet
    //describe("positioning", function() {
    //  beforeEach(function() {
    //    
    //  });
    //  
    //  it("should be centered horizontally to the button / link", function() {
    //    expect($popover.css('left')).toEqual("20px");
    //  });
    //  
    //  it("should be under the button / link", function() {
    //    expect($popover.css('top')).toEqual("40px");
    //  });
    //});
    
  });
  
  describe("when destroy is called", function() {
    beforeEach(function() {
      $button.aaPopover('destroy');
    });
    
    it("should not have aaPopover stored as a data attr", function() {
      expect($button.data("aaPopover")).toEqual(undefined);
    });
    
    it("should not be bound to any event listeners", function() {
      expect($button.data("events")).toEqual(undefined);
    });
  });
  
  describe("when it's already open", function() {
    beforeEach(function() {
      $button.aaPopover('open');
    });
    
    describe("when close is called", function() {
      beforeEach(function() {
        $button.aaPopover('close');
      });
      
      it("should close", function() {
        expect($popover).toBeHidden();
      });
    });
    
    describe("when user clicks outside", function() {
      beforeEach(function() {
				$button.aaPopover('open');
        $('#wrapper').trigger("click");
      });
      
      it("should close", function() {
        expect($popover).toBeHidden();
      });
    });
  });

  describe("options", function() {
    describe("autoOpen set to false", function() {
      beforeEach(function() {
        $button.aaPopover("destroy");
        $button.aaPopover({
          autoOpen: false
        });
      });
      it("should not open when the link is clicked", function() {
        $button.trigger("click");
        expect($("#my_popover")).toBeHidden();
      });
    });
  });
  
});

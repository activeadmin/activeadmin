describe("AAPopover", function() {

  beforeEach(function() {
    this.$button = $(inject({
      el: 'a',
      id: 'my_popover_button',
      attrs: {href: '#my_popover_content'}
    }));
    
    this.$popoverContent = $(inject({
      id: 'my_popover_content'
    }));
    
    this.$button.AAPopover({
      fadeInDuration: 0,
      fadeOutDuration: 0,
    });
        
    this.popover = this.$button.data("AAPopover");
  });
  
  describe("opening button / link is pressed", function() {
    it("should open the popover", function() {
      this.$button.trigger("click");
      expect($("#my_popover_content")).toBeVisible();
    });  
  });
  
  describe("by default", function() {
    it("should be hidden", function() {
      expect(this.$popoverContent).toBeHidden();
    });
  });
  
  describe("when open is called", function() {
    beforeEach(function() {
      expect(this.$popoverContent).toBeHidden();
      this.$button.AAPopover('open');
    });
    
    it("should be open", function() {
      expect(this.$popoverContent).toBeVisible();
    });
  });
  
  describe("when destroy is called", function() {
    beforeEach(function() {
      this.$button.AAPopover('destroy');
    });
    
    it("should not have AAPopover stored as a data attr", function() {
      expect(this.$button.data("AAPopover")).toEqual(undefined);
    });
    
    it("should not be bound to any event listeners", function() {
      expect(this.$button.data("events")).toEqual(undefined);
    });
  });
  
  describe("when it's already open", function() {
    beforeEach(function() {
      this.$button.AAPopover('open');
    });
    
    describe("when close is called", function() {
      beforeEach(function() {
        this.$button.AAPopover('close');
      });
      
      it("should close", function() {
        expect(this.$popoverContent).toBeHidden();
      });
    });
    
    describe("when user clicks outside", function() {
      beforeEach(function() {
        $(document).trigger("click");
      });
      
      it("should close", function() {
        expect(this.$popoverContent).toBeHidden();
      });
    });
  });

  describe("options", function() {
    describe("autoOpen set to false", function() {
      beforeEach(function() {
        this.$button.AAPopover("destroy");
        this.$button.AAPopover({
          autoOpen: false
        });
      });
      it("should not open when the link is clicked", function() {
        this.$button.trigger("click");
        expect($("#my_popover_content")).toBeHidden();
      });
    });
  });
  
});
(function() {

  describe("AA.Popover", function() {
    var $button, $popover, $wrapper, popover;
    $wrapper = void 0;
    $button = void 0;
    $popover = void 0;
    popover = void 0;
    beforeEach(function() {
      $wrapper = $(inject({
        id: "wrapper"
      }));
      $button = $(inject({
        el: "a",
        id: "my_popover_button",
        attrs: {
          href: "#my_popover"
        }
      }));
      $popover = $(inject({
        id: "my_popover"
      }));
      $button.popover({
        fadeInDuration: 0,
        fadeOutDuration: 0
      });
      return popover = $button.data("popover");
    });
    describe("opening button / link is pressed", function() {
      return it("should open the popover", function() {
        $button.trigger("click");
        return expect($("#my_popover")).toBeVisible();
      });
    });
    describe("when initiated", function() {
      it("should be hidden", function() {
        return expect($popover).toBeHidden();
      });
      it("should be have class popover", function() {
        return expect($popover).toHaveClass("popover");
      });
      return describe("nipple", function() {
        return it("should exist", function() {
          return expect($popover).toContain(".popover_nipple");
        });
      });
    });
    describe("when open is called", function() {
      beforeEach(function() {
        expect($popover).toBeHidden();
        return $button.popover("open");
      });
      return it("should be open", function() {
        return expect($popover).toBeVisible();
      });
    });
    describe("when destroy is called", function() {
      beforeEach(function() {
        return $button.popover("destroy");
      });
      it("should not have popover stored as a data attr", function() {
        return expect($button.data("popover")).toEqual(undefined);
      });
      return it("should not be bound to any event listeners", function() {
        return expect($button.data("events")).toEqual(undefined);
      });
    });
    describe("when it's already open", function() {
      beforeEach(function() {
        return $button.popover("open");
      });
      describe("when close is called", function() {
        beforeEach(function() {
          return $button.popover("close");
        });
        return it("should close", function() {
          return expect($popover).toBeHidden();
        });
      });
      return describe("when user clicks outside", function() {
        beforeEach(function() {
          $button.popover("open");
          return $("#wrapper").trigger("click");
        });
        return it("should close", function() {
          return expect($popover).toBeHidden();
        });
      });
    });
    return describe("options", function() {
      return describe("autoOpen set to false", function() {
        beforeEach(function() {
          $button.popover("destroy");
          return $button.popover({
            autoOpen: false
          });
        });
        return it("should not open when the link is clicked", function() {
          $button.trigger("click");
          return expect($("#my_popover")).toBeHidden();
        });
      });
    });
  });

}).call(this);

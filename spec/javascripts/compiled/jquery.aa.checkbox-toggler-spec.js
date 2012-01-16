(function() {

  describe("AA.CheckboxToggler", function() {
    beforeEach(function() {
      loadFixtures('checkboxes.html');
      this.collection = $("#collection");
      this.toggle_all = this.collection.find(".toggle_all");
      this.checkboxes = this.collection.find(":checkbox").not(this.toggle_all);
      return new AA.CheckboxToggler({}, this.collection);
    });
    describe("on init", function() {
      it("should raise an error if container not found", function() {
        var _this = this;
        return expect(function() {
          return new AA.CheckboxToggler({});
        }).toThrow("Container element not found");
      });
      return it("should raise an error if 'toggle all' checkbox not found", function() {
        var _this = this;
        this.toggle_all.remove();
        return expect(function() {
          return new AA.CheckboxToggler({}, _this.collection);
        }).toThrow("'toggle all' checkbox not found");
      });
    });
    describe("'toggle all' checkbox", function() {
      it("should check all checkboxes when checked", function() {
        this.toggle_all.trigger("click");
        return expect(this.checkboxes).toHaveAttr("checked");
      });
      return it("should uncheck all checkboxes when unchecked", function() {
        this.toggle_all.trigger("click");
        this.toggle_all.trigger("click");
        return expect(this.checkboxes).not.toHaveAttr("checked");
      });
    });
    return describe("individual checkboxes", function() {
      describe("when all checkboxes are selected and one is unchecked", function() {
        beforeEach(function() {
          this.collection.find(":checkbox").attr("checked", "checked");
          return this.collection.find("#item_1").trigger("click");
        });
        return it("should uncheck the 'toggle all' checkbox", function() {
          return expect(this.toggle_all).not.toHaveAttr("checked");
        });
      });
      return describe("when the last checkbox is checked", function() {
        beforeEach(function() {
          this.checkboxes.attr("checked", "checked");
          this.collection.find("#item_1").removeAttr("checked");
          return this.collection.find("#item_1").trigger("click");
        });
        return it("should check the 'toggle all' checkbox", function() {
          return expect(this.toggle_all).toHaveAttr("checked");
        });
      });
    });
  });

}).call(this);

(function() {

  describe("AA.TableCheckboxToggler", function() {
    beforeEach(function() {
      loadFixtures('table_checkboxes.html');
      this.collection = $("#collection");
      this.toggle_all = this.collection.find(".toggle_all");
      this.checkboxes = this.collection.find(":checkbox").not(this.toggle_all);
      return new AA.TableCheckboxToggler({}, this.collection);
    });
    describe("'selected' class for table row", function() {
      it("should add the class 'selected' to rows when their checkbox is checked ", function() {
        var checkbox;
        checkbox = $("#item_1");
        checkbox.attr("checked", "checked");
        checkbox.trigger("change");
        return expect(checkbox.parents("tr")).toHaveAttr("class", "selected");
      });
      return it("should remove the class 'selected' from rows when their checkbox is unchecked ", function() {
        var checkbox;
        checkbox = $("#item_1");
        checkbox.trigger("change");
        return expect(checkbox.parents("tr")).not.toHaveAttr("class", "selected");
      });
    });
    return describe("clicking a cell", function() {
      return it("should toggle the checkbox when a cell is clicked", function() {
        var checkbox, row;
        checkbox = $("#item_1");
        row = checkbox.parents("td");
        $(row).trigger("click");
        return expect(checkbox).toHaveAttr("checked", "checked");
      });
    });
  });

}).call(this);

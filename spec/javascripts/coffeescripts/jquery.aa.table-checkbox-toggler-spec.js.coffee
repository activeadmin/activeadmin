describe "AA.TableCheckboxToggler", ->
  
  beforeEach ->
    loadFixtures('table_checkboxes.html');

    @collection = $("#collection")
    @toggle_all = @collection.find(".toggle_all")

    @checkboxes = @collection.find(":checkbox").not(@toggle_all)
    
    new AA.TableCheckboxToggler({}, @collection)

  describe "'selected' class for table row", ->
    it "should add the class 'selected' to rows when their checkbox is checked ", ->
      checkbox = $("#item_1")
      checkbox.attr("checked", "checked")      
      checkbox.trigger("change")

      expect(checkbox.parents("tr")).toHaveAttr("class", "selected")

    it "should remove the class 'selected' from rows when their checkbox is unchecked ", ->
      checkbox = $("#item_1")
      checkbox.trigger("change")

      expect(checkbox.parents("tr")).not.toHaveAttr("class", "selected")

  describe "clicking a cell", ->
    it "should toggle the checkbox when a cell is clicked", ->
      checkbox = $("#item_1")
      row = checkbox.parents("td")
      $(row).trigger("click")

      expect(checkbox).toHaveAttr("checked", "checked")


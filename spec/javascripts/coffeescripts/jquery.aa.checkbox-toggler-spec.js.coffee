describe "CheckboxToggler", ->
  
  beforeEach ->
    loadFixtures('checkboxes.html');

    @collection = $("#collection")
    @toggle_all = @collection.find(".toggle_all")

    @checkboxes = @collection.find(":checkbox").not(@toggle_all)
    
    
    new CheckboxToggler(@collection)

  describe "on init", ->
    it "should raise an error if container not found", ->
      expect( => new CheckboxToggler() ).toThrow("Container element not found")

    it "should raise an error if 'toggle all' checkbox not found", ->
      @toggle_all.remove()
      expect( => new CheckboxToggler(@collection); ).toThrow("'toggle all' checkbox not found")

  describe "'toggle all' checkbox", ->
    describe "when checking", ->
      
      it "should check all unchecked checkboxes", ->
        @toggle_all.trigger("click")
        expect(@checkboxes).toHaveAttr("checked")

      it "should leave the 'toggle all' checkbox alone", ->
        @toggle_all.trigger("click")
        expect(@toggle_all).toHaveAttr("checked")

    describe "when unchecking", ->
      it "should uncheck all checkboxes", ->
        @toggle_all.trigger("click")
        @toggle_all.trigger("click")
        expect(@checkboxes).not.toHaveAttr("checked")

  describe "individual checkboxes", ->

    describe "when all checkboxes are selected and one is unchecked", ->
      beforeEach ->
        @collection.find(":checkbox").attr("checked", "checked")
        @collection.find("#item_1").trigger("click")

      it "should uncheck the 'toggle all' checkbox", ->
        expect(@toggle_all).not.toHaveAttr("checked")

    describe "when the last checkbox is checked", ->
      beforeEach ->
        @checkboxes.attr("checked", "checked")
        @collection.find("#item_1").removeAttr("checked")
        @collection.find("#item_1").trigger("click")

      it "should check the 'toggle all' checkbox", ->
        expect(@toggle_all).toHaveAttr("checked")


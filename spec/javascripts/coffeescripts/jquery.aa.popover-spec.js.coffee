describe "ActiveAdmin.Popover", ->
  $wrapper = undefined
  $button = undefined
  $popover = undefined
  popover = undefined
  beforeEach ->
    $wrapper = $(inject(id: "wrapper"))
    $button = $(inject(
      el: "a"
      id: "my_popover_button"
      attrs:
        href: "#my_popover"
    ))
    $popover = $(inject(id: "my_popover"))
    $button.popover
      fadeInDuration: 0
      fadeOutDuration: 0

    popover = $button.data("popover")

  describe "opening button / link is pressed", ->
    it "should open the popover", ->
      $button.trigger "click"
      expect($("#my_popover")).toBeVisible()

  describe "when initiated", ->
    it "should be hidden", ->
      expect($popover).toBeHidden()

    it "should be have class popover", ->
      expect($popover).toHaveClass "popover"

    describe "nipple", ->
      it "should exist", ->
        expect($popover).toContain ".popover_nipple"

  describe "when open is called", ->
    beforeEach ->
      expect($popover).toBeHidden()
      $button.popover "open"

    it "should be open", ->
      expect($popover).toBeVisible()

  describe "when destroy is called", ->
    beforeEach ->
      $button.popover "destroy"

    it "should not have popover stored as a data attr", ->
      expect($button.data("popover")).toEqual `undefined`

    it "should not be bound to any event listeners", ->
      expect($button.data("events")).toEqual `undefined`

  describe "when it's already open", ->
    beforeEach ->
      $button.popover "open"

    describe "when close is called", ->
      beforeEach ->
        $button.popover "close"

      it "should close", ->
        expect($popover).toBeHidden()

    describe "when user clicks outside", ->
      beforeEach ->
        $button.popover "open"
        $("#wrapper").trigger "click"

      it "should close", ->
        expect($popover).toBeHidden()

  describe "options", ->
    describe "autoOpen set to false", ->
      beforeEach ->
        $button.popover "destroy"
        $button.popover autoOpen: false

      it "should not open when the link is clicked", ->
        $button.trigger "click"
        expect($("#my_popover")).toBeHidden()

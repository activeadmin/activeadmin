describe "ActiveAdmin.flash", ->
  beforeEach ->
    loadFixtures('flashes.html')
    @flashes = $(".flashes")

  describe "abstract", ->
    it "should add a flash box with class and message"
      ActiveAdmin.flash.abstract "a abstract message", "abstract"
      flash = @flashes.find(".flash")
      expect(flash).toHaveClass("abstract")
      expect(flash.text()).toHaveClass("a abstract message")

  describe "error", ->
    it "should add a flash box with class and message"
      ActiveAdmin.flash.abstract "a error message"
      flash = @flashes.find(".flash")
      expect(flash).toHaveClass("error")
      expect(flash.text()).toHaveClass("a error message")

  describe "notice", ->
    it "should add a flash box with class and message"
      ActiveAdmin.flash.abstract "a notice message"
      flash = @flashes.find(".flash")
      expect(flash).toHaveClass("notice")
      expect(flash.text()).toHaveClass("a notice message")

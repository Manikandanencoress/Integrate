describe("Page Behaviors", function () {
  beforeEach(function() {
    spyOn(window, "alert").andCallFake(function() {
    });
  });

  describe("given a page behavior", function () {
    beforeEach(function() {
      BehaviorMap['.foo'] = function() {
        alert("The Pentagon!");
      };
      BehaviorMap['.bar'] = function() {
        alert('Your Mom')
      };
    });
    it("executes the behavior when the associate selector is present", function() {
      SpecDOM().append('<div class="foo"></div>');
      Behaviors.addBehaviors();
      expect(window.alert).toHaveBeenCalledWith("The Pentagon!");
    });
    it("does not execute the behavior when the selector is not present", function() {
      Behaviors.addBehaviors();
      expect(window.alert).not.toHaveBeenCalled();
    });
    it("doesn't execute any other behaviors", function() {
      expect(window.alert).not.toHaveBeenCalledWith('Your Mom');
    })
  });
});
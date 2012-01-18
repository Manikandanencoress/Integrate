describe("facebook initializer", function () {
    describe("with a facebook app id defined", function () {
        var fbInitOptions;
        
        beforeEach(function() {
            window.FB = {
                init: jasmine.createSpy("FB.init"),
                Canvas: {
                    setSize: jasmine.createSpy("FB.Canvas.setSize"),
                    setAutoResize: jasmine.createSpy("FB.Canvas.setAutoResize")
                },
                Event: {
                    subscribe: jasmine.createSpy("FB.Event.subscribe"),
                    unsubscribe: jasmine.createSpy("FB.Event.unsubscribe")
                }
            };
            window.facebook_app_id = 'foo';
            window.fbAsyncInit();
            fbInitOptions = FB.init.mostRecentCall.args[0];
            expect(FB.init).toHaveBeenCalled();
        });
        it("initializes the facebook api", function() {
            expect(fbInitOptions.appId).toEqual('foo');
        });

        it("sets facebook option cookie to true", function() {
            // This is super important, it enables the Facebook JS SDK to access the user's session
            // A lot of of the FB.ui dialogs (and probably other things) will act weird if they can't validate the user
            // http://developers.facebook.com/docs/authentication/
            expect(fbInitOptions.cookie).toEqual(true);
        });

        it("sets the canvas size", function () {
            expect(FB.Canvas.setSize).
                    toHaveBeenCalledWith({width:740, height: 1355});
        });
    });

    it("should throw an error if the facebook app id is undefined", function () {
        window.facebook_app_id = undefined;
        expect(
                function() {
                    window.fbAsyncInit();
                }).
                toThrow("Facebook App ID was undefined");
    });
});
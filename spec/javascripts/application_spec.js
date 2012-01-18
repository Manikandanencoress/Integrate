describe("Application Behaviors", function () {
    var realBrightcove = window.brightcove;
    beforeEach(function () {
        window.brightcove = realBrightcove;
    });
    afterEach(function () {
        window.brightcove = realBrightcove;
    });
    describe("on .orders.show", function () {
        beforeEach(function () {
            window.APIModules = { VIDEO_PLAYER: "foo" };
            window.BCMediaEvent = { BEGIN: "begin", PLAY: "play", STOP: "stop" };
            window.BCCuePointEvent = { BEGIN: "begin", PLAY: "play", STOP: "stop" };
            window.BCExperienceEvent = {};
            var getExperience = function() {
                return {
                    getModule: function(arg) {
                        return {
                            addEventListener: jasmine.createSpy(),
                            getVideoPosition: function (returnTimeCode) {
                                if (returnTimeCode) {
                                    return "1:05";
                                } else {
                                    return 64.6;
                                }
                            }
                        };
                    }
                };
            };
            window.brightcove = {
                getExperience: getExperience
            };
            window.movie = {id : 4};
            SpecDOM().html('<div id="brightcovePlayer" />' +
                    '<div id="commentStream"></div>' +
                    '<div class="streamCreator">' +
                    '   <input class="commentText" />' +
                    '   <button class="insertCommentButton"></button>' +
                    '<button class="likeButton"></button>' +
                    '</div>');
            spyOn(milyoni, "createBrightcoveExperience");
        });
        describe("if there's a brightcove player", function () {
            var commentStreamElements, commentStreamSelector;
            beforeEach(function () {
                spyOn(jQuery.fn, 'commentStream').andCallFake(function () {
                    commentStreamElements = this;
                    commentStreamSelector = this.selector;
                });
                window.brightcovePlayerID = '123';
                window.brightcovePlayerKey = 'abc';
                window.brightcoveVideoID = '456';
                BehaviorMap[".orders.show"]();
            });
            it("creates the brightcove experiences ", function () {
                expect(milyoni.createBrightcoveExperience).toHaveBeenCalledWith('123', 'abc', '456');
            });
            it("creates a CommentStream for the given movie", function () {
                expect($.fn.commentStream).toHaveBeenCalled();
                expect(commentStreamElements[0]).toEqual(SpecDOM("#commentStream")[0]);
            });
        });
        describe("if there isn't the markup for a brightcove player", function () {
            beforeEach(function () {
                SpecDOM().html("");
            });
            it("does not create the brightcove player ", function () {
                BehaviorMap[".orders.show"]();
                expect(milyoni.createBrightcoveExperience).not.toHaveBeenCalled();
            });
        });

        describe("creating a comment for the comment stream", function () {
            var streamObject;
            beforeEach(function () {
                window.FB = jasmine.createSpyObj("FB", ['ui', 'api'])
                BehaviorMap[".orders.show"]();
                window.onTemplateLoaded();
                window.most_recent_signed_request = "foo";
                window.movie = {
                    "id":1,
                    "studio_id":1,
                    "feed_dialog_link":"http://linky.link",
                    "feed_dialog_name":"Duh Matrix",
                    "feed_dialog_caption":"The Caption",
                    "title":"Seed The Matrix",
                    "studio":"Warner Bros",
                    "price":30,
                    "link":"http://linky.foo",
                    "facebook_fan_page_url":"http://www.facebook.com/TheMatrixMovie",
                    "feed_dialog_desc":"The Description",
                    "poster":"123",
                    "thumb_popup_image":"456",
                    "logo_popup_image":"789",
                    "feed_dialog_image":"012"
                };

                streamObject = $("#commentStream").commentStream();
                streamObject.addComment = jasmine.createSpy("addComment");
                SpecDOM(".commentText").val("our text");
                SpecDOM(".insertCommentButton").click();
            });

            it("adds a comment from the comment box at the right time when the 'Go' button is clicked", function () {
                SpecDOM(".insertCommentButton").click();
                expect(streamObject.addComment).toHaveBeenCalledWith(
                        "our text", 65, "foo");
            });

             it("sends a message to facebook to post the watcher's comment to the wall", function() {
                expect(FB.api).toHaveBeenCalledWith('/me/feed', 'post', jasmine.any(Object));
                var feedPostParams = FB.api.mostRecentCall.args[2];
                expect(feedPostParams.message).toEqual("our text");
                expect(feedPostParams.link).toEqual("http://linky.link");
                expect(feedPostParams.picture).toEqual("http://012");
                expect(feedPostParams.caption).toEqual("The Caption");
                expect(feedPostParams.name).toEqual("I am watching Duh Matrix");
                expect(feedPostParams.description).toEqual("The Description");
            });


            describe("when the like button is clicked", function () {
                beforeEach(function () {
                    SpecDOM(".likeButton").click();
                });

                it("adds a 'like' at the right time ", function () {
                    expect(streamObject.addComment).toHaveBeenCalledWith(
                            "our text", 65, "foo");
                });
                it("sends a message to facebook to post a like-ish comment", function () {
                    expect(FB.api).toHaveBeenCalledWith('/me/feed', 'post', jasmine.any(Object));
                    var feedPostParams = FB.api.mostRecentCall.args[2];
                    expect(feedPostParams.message).toEqual("our text");
                    expect(feedPostParams.link).toEqual("http://linky.link");
                    expect(feedPostParams.picture).toEqual("http://012");
                    expect(feedPostParams.caption).toEqual("The Caption");
                    expect(feedPostParams.name).toEqual("I am watching Duh Matrix");
                    expect(feedPostParams.description).toEqual("The Description");

                });
            });
        });
    });
});
describe("The Comment Stream", function () {


    describe("commentStream jQuery plugin", function() {
        var movieId = 4;
        beforeEach(function () {
            spyOn(window.milyoni, "CommentStream").andCallThrough();
            spyOn(milyoni, "createBrightcoveExperience");
        });
        describe("when called the first time", function () {
            it("creates a CommentStream object for each of the selected elements", function () {
                SpecDOM().html(
                    '<div class="foo"></div>' +
                        '<div class="bar"></div>' +
                        '<div class="foo"></div>');

                $(".foo").commentStream({movieId: movieId});
                expect(milyoni.CommentStream).toHaveBeenCalledWith(SpecDOM(".foo")[0], movieId);
                expect(milyoni.CommentStream).toHaveBeenCalledWith(SpecDOM(".foo")[1], movieId);
                expect(milyoni.CommentStream).not.toHaveBeenCalledWith(SpecDOM(".bar")[0], movieId);
            });
            it("returns the CommentStream object", function () {
                SpecDOM().html('<div class="foo"></div>');
                var returnValue = $(".foo").commentStream({movieId: 4});
                expect(returnValue.constructor).toEqual(milyoni.CommentStream);
            });
        });

        describe("when called the second time", function () {
            var firstReturnValue;
            beforeEach(function () {
                SpecDOM().html('<div class="foo"></div>');
                $(".foo").commentStream({movieId: movieId});
                firstReturnValue = $(".foo").commentStream();
            })
            it("does not create a new CommentStream", function () {
                expect(milyoni.CommentStream.callCount).toEqual(1);
            });
            it("returns the comment stream object for an element if it already exists", function () {
                var secondReturn = $(".foo").commentStream();
                expect(secondReturn).toEqual(firstReturnValue);
            });

        });
    });

    describe("CommentStream", function () {
        var stream;
        describe("intialization", function () {
            it("creates the comment container", function () {
                SpecDOM().html('<div class="foo"></div>');
                expect(SpecDOM(".foo .commentContainer").length).toEqual(0);
                new milyoni.CommentStream(SpecDOM('.foo')[0], 10);
                expect(SpecDOM(".foo .commentContainer").length).toEqual(1);
            });


        });

        describe(".endPosition", function () {
            it("returns the end position of the stream assuming 30sec in the window", function () {
                SpecDOM().html('<div id="foo" style="width: 90px"/>');
                stream = new milyoni.CommentStream(SpecDOM('#foo')[0], 10);
                stream.videoDuration = 100;
                expect(stream.endPosition()).toEqual(-300);
            })
        });

        describe(".setCommentContainerSizeBasedOnLength", function() {
            it("should set the comment stream's width based on time and pixels per second", function() {
                SpecDOM().html('<div id="foo" style="width: 90px"/>');
                stream = new milyoni.CommentStream(SpecDOM('#foo')[0], 10);
                stream.setCommentContainerSizeBasedOnLength(100);

                var commentContainer = SpecDOM('#foo .commentContainer');

                // (90 pixels per 30 seconds = 3 pixels per second) * 100 + (90 for padding) = 390px
                expect(commentContainer.css("width")).toEqual('390px');
            });
        });

        describe(".updateAndPlayFrom", function () {
            beforeEach(function () {
                spyOn($.fn, "animate");
                SpecDOM().html('<div id="foo" style="width: 100px"/>');
                stream = new milyoni.CommentStream(SpecDOM('#foo')[0], 10);
            });
            it("does not animate when the duration hasn't been set", function () {
                stream.videoDuration = undefined;
                stream.updateAndPlayFrom(4);
                expect($.fn.animate).not.toHaveBeenCalled();
            });
            it("animates the stream if the duration has been set", function () {
                stream.videoDuration = 40;
                stream.updateAndPlayFrom(4);
                expect($.fn.animate).toHaveBeenCalledWith(
                    { left: stream.endPosition()},
                    36000, "linear");
            });
        });

        describe(".jumpTo", function() {
            it("moves the container to the position in seconds", function() {
                SpecDOM().html('<div id="foo" style="width: 90px"/>');
                stream = new milyoni.CommentStream(SpecDOM('#foo')[0], 10);
                var container = SpecDOM('#foo .commentContainer');
                container.css("position", "absolute");
                stream.jumpTo(10);
                // (90 pixels per 30 seconds = 3 pixels per second) * 10 = -30px
                expect(container.css("left")).toEqual('-30px');
            });
        });

        describe(".addComment", function() {
            it("adds a like as a comment", function() {
                SpecDOM().html('<div id="foo" style="width: 90px"/>');
                stream = new milyoni.CommentStream(SpecDOM('#foo')[0], 10);
                stream.comments = jasmine.createSpyObj('commentsStub', ['create']);

                stream.addComment("Foo", 100, "jdafljdflkaj");
                expect(stream.comments.create).toHaveBeenCalled();

                var args = stream.comments.create.mostRecentCall.args[0];
                expect(args).toBeDefined();
                expect(args.comment.text).toEqual("Foo");
                expect(args.comment.commented_at).toEqual(100);
                expect(args.signed_request).toEqual("jdafljdflkaj");
            });
        });

        describe("Friends Filter", function () {
            beforeEach(function () {
                user = { facebook_id : "foo",
                         name : "The Dude",
                         friends : ['1234', 4567, 7890] };

                user_comments = ['foo', '1234', '4567', '0123', '2345'];

                SpecDOM().html('<div id="commentContainer"/>');

                stream = $("#commentContainer").commentStream({movieId: '1234'});
                
                for (var i in user_comments) {
                 $("#commentContainer").append('<div class="like"><div class="bubble" title="' + user_comments[i] + '" id="' + i + '"></div></div>')   
                }

                stream.updateCommentsWithFriends();

            });

            describe("#insertFriends", function () {
                it("should add a class to comments that are mine. ", function () {
                  expect($($('.bubble')[0]).attr('class')).toEqual('bubble mine');
                  expect($($('.bubble')[1]).attr('class')).toEqual('bubble friend');
                  expect($($('.bubble')[2]).attr('class')).toEqual('bubble');
                  expect($($('.bubble')[3]).attr('class')).toEqual('bubble');
                });

            });
        });
    });


//    beforeEach(function () {
//        SpecDOM().html('' +
//                '<div id="moments_comments">' +
//                '<div class="likeContainer">' +
//                '<div class="like" data-commented-at="5">Foo</div>' +
//                '<div class="like" data-commented-at="11">Foo</div>' +
//                '</div>' +
//                '</div>');
//    });
//
//
//    describe("initializeCommentStream", function() {
//        beforeEach(function () {
//            milyoni.initializeCommentStream();
//        });
//        it("positions Likes in the comment stream given a 23px / second assumption", function() {
//            var $commentAt5 = $('.like[data-commented-at="5"]');
//            expect($commentAt5.css("position")).toEqual("absolute");
//            expect($commentAt5.css('left')).toEqual(5 * 23 + "px");
//            expect($('.like[data-commented-at="11"]').css('left')).toEqual(11 * 23 + "px");
//        });
//        it("stacks the comments vertically", function () {
//            var $likes = SpecDOM(".like");
//            var $firstLike = $($likes[0]);
//            expect($firstLike.css("top")).toEqual("0px");
//            expect($($likes[1]).css("top")).toEqual($firstLike.height() + 5 + "px");
//        })
//    });
//
//    describe("playCommentStream", function() {
//        var lengthOfVideoInSeconds;
//        beforeEach(function () {
//            lengthOfVideoInSeconds = 2000;
//        });
//        it("moves the comment stream", function () {
//            spyOn($.fn, "animate");
//            milyoni.playCommentStream();
//            expect(jQuery.fn.animate).
//                    toHaveBeenCalledWith(
//                    {left: 0 - 23 * lengthOfVideoInSeconds}, lengthOfVideoInSeconds);
//        });
//    });

});
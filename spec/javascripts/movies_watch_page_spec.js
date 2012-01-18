describe("Order#show Watch Page Specs", function () {
    describe("milyoni", function () {
        describe("#addWatchNowPopUp", function () {
            var clickListener;
            beforeEach(function () {
                window.movie = { id: 123, studio_id: 234, price: 54 };
                clickListener = jasmine.createSpy("another click listener");
                SpecDOM().html("<a href='#' id='payButton'>Foo</a>");
                $("#payButton").bind('click', clickListener);
            });

            describe("when the studio is Warner", function () {
                beforeEach(function() {
                    window.movie.studio = "Warner Bros";
                    window.milyoni.addWatchNowPopUp();
                    $("#payButton").click();
                });
                it("a zipcode popup appears when the Watch Now link is clicked", function() {
                    expect($(":contains(Enter Your Zip Code)").length).toBeGreaterThan(0);
                });
                it("clicking prevents the default action", function () {
                    var click_event = clickListener.mostRecentCall.args[0];
                    expect(click_event.isDefaultPrevented()).toBe(true);
                });
                it("creates a form pointing to the right target", function () {
                    expect($("#new_order_form").attr('action')).toMatch('/studios/234/movies/123/orders/new')
                });

                describe("after submitting the zipcode form", function () {
                    beforeEach(function() {
                        $("#new_order_form input[name=zip]").val('12345');
                        $("#new_order_form").submit();
                    });

                    describe("When the response is 200", function() {
                        it("replaces the form with the HTML", function () {
                            mostRecentAjaxRequest().response({
                                contentType: 'text/plain',
                                status : 200,
                                responseText : 'some html'
                            });
                            var container = $("#facebox #dialogueBox");
                            var newHtml = container.html();
                            expect(newHtml).toEqual("some html");
                        });
                    });

                    describe("When the response is 202", function() {
                        it("replaces the form with the HTML", function () {
                            spyOn(milyoni, 'renderPurchaseDialog');
                            mostRecentAjaxRequest().response({
                                status : 202,
                                responseText : '{"movie_id":56,"price":30,"tax":0, "zip_code":"98111"}'
                            });
                            expect(milyoni.renderPurchaseDialog).toHaveBeenCalledWith(56, 30, 0, "98111", false);
                        });
                    });

                    describe("when there is an error submitting the form", function () {
                        it("displays the error message from the response in the header", function () {
                            mostRecentAjaxRequest().response({
                                status : 400,
                                responseText : 'There was an error, bro'
                            });
                            expect($("#facebox #dialogueBox").find("h2").text()).toEqual('There was an error, bro');
                        });
                    });
                });
            });

            describe("when the studio is not Warner", function () {
                beforeEach(function() {
                    window.movie.studio = "Funimation";
                    window.milyoni.addWatchNowPopUp();
                });

                describe("when group buy is enabled", function () {
                    it("a group discount popup appears when the Watch Now link is clicked", function() {
                        window.group_buy_enable = true;
                        $("#payButton").click();
                        expect($(":contains(Please disable pop-up blockers to ensure the delivery of your Share With Friends coupon after purchase.)").length).toBeGreaterThan(0);
                    });

                    describe("when the discount key is expired", function () {
                        it("an expired dialog pops up when the the Watch Now link is clicked", function () {
                            window.movie.expired = true;
                            window.movie.discount_key = false;
                            $("#payButton").click();
                            expect($(":contains(Sorry this discount has expired or rent the movie now)").length).toBeGreaterThan(0);
                        });
                    });

                    describe("when the viewing party is complete", function () {
                        it("a viewing party complete dialog pops up when the Watch now link is clicked", function () {
                            window.movie.expired = false;
                            window.movie.discount_key = false;
                            window.movie.viewing_party_complete = true;
                            $("#payButton").click();
                            expect($(":contains(Sorry the viewing party is complete.)").length).toBeGreaterThan(0);
                        });
                    });
                });

                describe("when group buy is not enabled", function () {
                    it("a group discount popup does not appear when the Watch Now is clicked", function () {
                        window.group_buy_enable = false;
                        window.FB = {
                            ui: function() {
                            }
                        };
                        spyOn(FB, 'ui');
                        $("#payButton").click();
                        expect(FB.ui).toHaveBeenCalled();
                    });
                });

            });
        });


        describe("#renderPurchaseDialog", function() {
            var listener;
            beforeEach(function () {
                window.FB = {
                    ui: function() {
                    }
                };
                spyOn(FB, 'ui');
                listener = jasmine.createSpy("facebox listener");
                $(document).bind('close.facebox', listener);
                window.milyoni.renderPurchaseDialog('123', 30, 3, '12345', false);
            });
            it("shows a Facebook 'pay' pop-up", function() {
                var ui_options = {
                    method: 'pay',
                    order_info: {
                        'movie_id':'123',
                        'cost':30,
                        'tax':3,
                        'zip_code': '12345'
                    },
                    purchase_type:'item'
                };
                expect(FB.ui.mostRecentCall.args[0]).toEqual(ui_options)
            });
        });

        describe("#insertMoviePlayer", function() {
            beforeEach(function() {
                window.swfobject = {
                    embedSWF: jasmine.createSpy("swfobject.embedSWF"),
                    createCSS: jasmine.createSpy("swfobject.createCSS")

                };
            });

            it("inserts a movie player based on the values set by the server", function() {
                SpecDOM().html('<div id="mediaspace"></div>');
                window.user = {facebook_id: "my.user.id"};
                window.movie = {id: "MOVIE-ID", poster: 'indiana-jones.jpg'};
                milyoni.insertMoviePlayer();
                expect(swfobject.embedSWF).toHaveBeenCalled();
                var swfObjectArgs = swfobject.embedSWF.mostRecentCall.args;
                expect(swfObjectArgs[1]).toEqual('mediaspace');
                var flashvars = swfObjectArgs[6];
                expect(flashvars.api).toEqual("/api/wb_player_authorizations?movie_id=MOVIE-ID%26facebook_user_id=my.user.id");
                expect(flashvars.poster).toEqual("indiana-jones.jpg");
            });

            it("does not insert a movie player if there is no #mediaspace element", function() {
                milyoni.insertMoviePlayer();
                expect(swfobject.embedSWF).not.toHaveBeenCalled();
            });

        });


        describe("#insertMilyoniPlayer", function() {
          beforeEach(function() {
              spyOn(milyoni, 'subDubPlayer');
          });

          it("inserts the milyoni movie player based on the player set by the server", function() {
            SpecDOM().html('<div id="milyoniPlayer"></div></div>');
              window.user = {facebook_id: "my.user.id"};
              window.movie = {id: "MOVIE-ID", poster: 'indiana-jones.jpg', player: 'milyoni'};
              milyoni.insertMilyoniPlayer();
              expect(milyoni.subDubPlayer).toHaveBeenCalled();
          })
        });



        describe("#currentPathWithSignedRequest", function () {
            beforeEach(function () {
                spyOn(window, "Date").
                    andReturn({getTime: function() {
                        return 123456
                    }});
                window.most_recent_signed_request = 'foo.bar-blah';
            });

            it("adds the signed request if it doesn't exist", function () {
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/");
                expect(milyoni.currentPathWithSignedRequest()).
                    toMatch('signed_request=foo.bar-blah');
            });

            it("removes hashes", function () {
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/#");
                expect(milyoni.currentPathWithSignedRequest()).
                    not.toMatch(/#/);
            });

            it("replaces the signed request if it already exists", function () {
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/?signed_request=foobar");
                expect(milyoni.currentPathWithSignedRequest()).
                    not.toMatch(/signed_request=foobar/);
                expect(milyoni.currentPathWithSignedRequest()).
                    toMatch(/signed_request=foo.bar-blah/);
            });

            it("adds a time stamp", function () {
                window.most_recent_signed_request = 'foo.bar-blah';
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/?signed_request=foobar");
                var path = milyoni.currentPathWithSignedRequest();
                expect(path).toMatch(/.*&timestamp=123456/)
            });

            it("preserves other querystring params", function () {
                window.most_recent_signed_request = 'foo.bar';
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/?code=12345678");
                var path = milyoni.currentPathWithSignedRequest();
                expect(path).toMatch(/\?code=12345678/)
                expect(path).toMatch(/&signed_request=foo\.bar/);
                expect(path).toMatch(/&timestamp=123456/);
            });

            it("adds show_facebook_feed_dialog", function() {
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/");
                var path = milyoni.currentPathWithSignedRequest();
                expect(path).toMatch(/.*&show_facebook_feed_dialog=true/)
            });

            it("just to test the exact match", function () {
                spyOn(milyoni, "currentLocation").
                    andReturn("http://google.com/#");
                expect(milyoni.currentPathWithSignedRequest()).
                    toEqual("http://google.com/?signed_request=foo.bar-blah&timestamp=123456&show_facebook_feed_dialog=true&show_facebook_feed_dialog_with_group_discount=undefined&discount_key_link=undefined&discount_key=undefined&expired=undefined&viewing_party_complete=undefined");
            })
        });

        describe("#renderFacebookFeedDialog", function() {
            beforeEach(function() {
                spyOn(FB, 'ui');
            });

            it("should render the facebook feed dialog with no text", function() {
                milyoni.renderFacebookFeedDialog();
                expect(FB.ui).toHaveBeenCalled();
                var args = FB.ui.mostRecentCall.args[0];
                expect(args.method).toEqual('feed');
                expect(args.message).toEqual('');
            });

            it("should pass our movie details into the feed dialog", function() {
                window.movie = {
                    feed_dialog_link: 'http://example.com/movies/1',
                    feed_dialog_image: 'http://example.com/images/topgun.gif',
                    feed_dialog_name: 'Watch Topgun',
                    feed_dialog_caption: 'Lots of planes fighting',
                    feed_dialog_desc: 'Tom Cruise in super awesome debut role'
                };

                window.show_facebook_feed_dialog = true;
                milyoni.renderFacebookFeedDialog();
                var args = FB.ui.mostRecentCall.args[0];
                expect(args.name).toEqual(movie.feed_dialog_name);
                expect(args.link).toEqual(movie.feed_dialog_link);
                expect(args.picture).toEqual(movie.feed_dialog_image);
                expect(args.caption).toEqual(movie.feed_dialog_caption);
                expect(args.description).toEqual(movie.feed_dialog_desc);
            });

            describe("protocol relativity in links", function () {
                describe("going from http values on an https page", function () {
                    it('should use the same protocol as the page for all images', function () {
                        window.movie = {
                            feed_dialog_link: 'http://example.com/1.jpg',
                            feed_dialog_image: 'http://example.com/2.jpg'
                        };
                        spyOn(milyoni, "currentProtocol").andReturn('https:')
                        window.show_facebook_feed_dialog = true;
                        milyoni.renderFacebookFeedDialog();
                        var args = FB.ui.mostRecentCall.args[0];
                        expect(args.link).toEqual('https://example.com/1.jpg');
                        expect(args.picture).toEqual('https://example.com/2.jpg');
                    });
                });

                describe("going from https values on an http page", function () {
                    it('should use the same protocol as the page for all images', function () {
                        window.movie = {
                            feed_dialog_link: 'https://example.com/1.jpg',
                        };
                        spyOn(milyoni, "currentProtocol").andReturn('http:')
                        window.show_facebook_feed_dialog = true;
                        milyoni.renderFacebookFeedDialog();
                        var args = FB.ui.mostRecentCall.args[0];
                        expect(args.link).toEqual('http://example.com/1.jpg');
                    });
                });

                describe("going from protocol-relative (or missing protocol) url to http", function () {
                    it("should use http", function () {
                        window.movie = {
                            feed_dialog_link: '//example.com/1.jpg',
                            feed_dialog_image: 'example.com/2.jpg'
                        };
                        spyOn(milyoni, "currentProtocol").andReturn("http:");
                        window.show_facebook_feed_dialog = true;
                        milyoni.renderFacebookFeedDialog();
                        var args = FB.ui.mostRecentCall.args[0];
                        expect(args.link).toEqual('http://example.com/1.jpg');
                        expect(args.picture).toEqual('http://example.com/2.jpg');
                    });
                })
            });

        });

        describe("#renderFacebookFeedDialogOnPageLoad", function() {
            it("should should call renderFacebookFeedDialog if show_facebook_feed_dialog is defined and checkFlashPlayerUpgrade is false", function() {
                spyOn(milyoni, "renderFacebookFeedDialog");
                window.show_facebook_feed_dialog = true;
                spyOn(milyoni, "checkFlashPlayerUpgrade").andReturn(false);
                milyoni.renderFacebookFeedDialogOnPageLoad();
                expect(milyoni.renderFacebookFeedDialog).toHaveBeenCalled();
            });

            it("should should not call renderFacebookFeedDialog if show_facebook_feed_dialog is not defined and checkFlashPlayerUpgrade is true", function() {
                spyOn(milyoni, "renderFacebookFeedDialog");
                window.show_facebook_feed_dialog = undefined;
                spyOn(milyoni, "checkFlashPlayerUpgrade").andReturn(true);
                milyoni.renderFacebookFeedDialogOnPageLoad();
                expect(milyoni.renderFacebookFeedDialog).not.toHaveBeenCalled();
            });
        });

        describe("#addFacebookSharePopUp", function() {
            it("should add a click event that calls renderFacebookFeedDialog", function() {
                SpecDOM().html("<a href='#' id='facebookShareButton'>Foo</a>");
                clickListener = jasmine.createSpy("share button listener");
                spyOn(milyoni, "renderFacebookFeedDialog");
                $("#facebookShareButton").bind('click', clickListener);
                window.milyoni.addFacebookSharePopup();
                $("#facebookShareButton").click();
                expect(milyoni.renderFacebookFeedDialog).toHaveBeenCalled();
            });
        });
    });
});
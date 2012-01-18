if (window.milyoni === undefined) {
    window.milyoni = {};
}
$(function () {
    (function ($) {
        // Our application widget
        milyoni.CommentStream = function (element, movieId) {
            var self = this;
            var secondsContainedInWindow = 30;
            var $element = $(element);
            var $commentContainer = $('<div></div>').addClass("commentContainer").appendTo($element);
            var pixelsPerSecond = $element.width() / secondsContainedInWindow;

            self.movie_id = movieId;
            self.comments = new CommentCollection([], {movieId: movieId});
            self.view = new CommentCollectionView(
                {parentElement: element,
                    comments: this.comments
                });
            self.view.pixelsPerSecond = pixelsPerSecond;
            self.view.centerPadding = $element.width() / 2;

            self.comments.fetch();

            self.endPosition = function() {
//               // goes to the left, and how fast it goes
                return 0 - this.videoDuration * pixelsPerSecond;
            };

            self.setCommentContainerSizeBasedOnLength = function(length) {
                $commentContainer.css("width", length * pixelsPerSecond + $element.width());
            };

            self.updateAndPlayFrom = function(positionInSeconds) {
                // if the videoDuration, set from app.js addEventListener,
                // (commentStream.videoDuration = event.duration)
                if (self.videoDuration) {
                    //how much is left in the movie
                    var secondsLeftInMovieFromCurrentLocation = self.videoDuration - positionInSeconds;

                    $commentContainer.animate({left: self.endPosition()}, secondsLeftInMovieFromCurrentLocation * 1000, "linear");
                }
            };

            self.filterFriendsThroughDropDownSelect = function() {
                $('select#filter_comments').show('slow');
                $('select#filter_comments').change(function() {
                    switch ($(this).val()) {
                        case 'all' :
                            $('.bubble').show('fast');
                            break;
                        case 'mine' :
                            $('div.bubble').hide('fast');
                            $('div.mine').show('slow');
                            break;
                        case 'mine_and_friends' :
                            $('div.bubble').hide('fast');
                            $('div.friend').show('slow');
                            $('div.mine').show('slow');
                            break;
                        case 'none' :
                            $('.bubble').hide('fast');
                            break;
                    }
                });
            }


            self.jumpTo = function(positionInSeconds) {
                $(element).find('.commentContainer').css("left", 0 - positionInSeconds * pixelsPerSecond);
            };

            self.stop = function() {
                $commentContainer.stop();
            };

            self.addComment = function(text, commented_at, signed_request) {
                self.comments.create({
                    signed_request: signed_request,
                    fb_user : 'foo',
                    comment : {
                        commented_at : commented_at,
                        text : text
                    }
                });
            };

            self.updateCommentsWithFriends = function () {
                var bubble_comments = $('.bubble');
                $.each(bubble_comments, function(index, value) {
                    if (window.user.friends != "[]" && $.inArray(value.title, window.user.friends) >= 0) {
                        $(value).addClass('friend');
                    }
                    else if (value.title == window.user.facebook_id) {
                        $(value).addClass('mine');
                    }
                });
            }
            self.updateCommentsWithMine = function () {
                var bubble_comments = $('.bubble');
                $.each(bubble_comments, function(index, value) {
                    if (value.title == window.user.facebook_id) {
                        $(value).addClass('mine');
                    }
                });

            }
        };


        var routes = {
            movieCommentsPath : function (movieId) {
                if (movieId == undefined)
                    throw "Comment's movie id is undefined";
                return '/movies/' + movieId + '/comments.json';
            }
        };

        // Backbone Stuff
        var Comment = Backbone.Model.extend({});

        var CommentCollection = Backbone.Collection.extend({
            model: Comment,
            initialize: function (collection, options) {
                this.url = routes.movieCommentsPath(options.movieId);
            }
        });

        var CommentView = Backbone.View.extend({
            className: "like",
            render: function() {
                var comment = this.model.toJSON();
                $(this.el).html(ich.comment_template(comment));
                return this;
            }
        });

        var CommentCollectionView = Backbone.View.extend(
            {
                initialize: function (options) {
                    "use strict";
                    this.el = $(options.parentElement).find(".commentContainer");
                    this.comments = options.comments;
                    _.bindAll(this, "render");
                    this.comments.bind('reset', this.render);
                    this.comments.bind('add', this.render);
                },

                render : function() {
                    "use strict";
                    var self = this;
                    var $likeContainer = $(self.el);
                    var createCommentView = function (comment, index) {
                        var view = new CommentView({model: comment});
                        var el = view.render().el;
                        // Display on 6 different 2em sized lines
                        $(el).css("top", 4 * (index % 3) + 'em');
                        $(el).css("left", self.pixelsPerSecond * comment.attributes.commented_at + self.centerPadding);

                        if (comment.attributes.text.length > 45) {
                            $(el).css("width", '16em');
                        }

                        $likeContainer.append(el);
                        $('.commentText').clearInputs();
                    };
                    var createHeatMap = function() {

                    };
                    this.comments.each(createCommentView);
                    createHeatMap();
                }


            });

        // jQuery plugin
        $.fn.commentStream = function(opts) {
            var options = opts || {};
            var movieId = options.movieId;
            var streams = [];
            this.each(function(index, element) {
                var streamForElement = $(element).data("commentStreamObject");
                var stream = streamForElement || new milyoni.CommentStream(element, movieId);
                $(element).data("commentStreamObject", stream);
                streams.push(stream);
            });
            return streams[0];
        };
    })(jQuery);

    $('div#commentStream').click(function () {
        resetComments();
    });

});


var stackComments = function(comment_id) {
    $(".bubble").show('fast');
    $("#" + comment_id).hide('slow');
};

var resetComments = function() {
    $(".bubble").toggle('fast');
};

if ($('#commentStream').length != 0) {
    $(window).load(function() {
        $('.stream_element').jTruncate({length:45});
        milyoni.commentStream.updateCommentsWithFriends();
        milyoni.commentStream.filterFriendsThroughDropDownSelect();
    });
}




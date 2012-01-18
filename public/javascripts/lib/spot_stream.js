if (window.milyoni === undefined) {
    window.milyoni = {};
}

$(function () {
    (function ($) {
        // Our application widget
        milyoni.SpotStream = function (element, movieId) {
            var self = this;
            var secondsContainedInWindow = 60;
            var $element = $(element);
            var $spotContainer = $('<div></div>').addClass("spotContainer").appendTo($element);
            var pixelsPerSecond = $element.width() / secondsContainedInWindow;

            self.movie_id = movieId;
            self.spots = new SpotCollection([], {movieId: movieId});
            self.view = new SpotCollectionView(
                    {parentElement: element,
                        spots: this.spots
                    });
            self.view.pixelsPerSecond = pixelsPerSecond;
            self.view.centerPadding = $element.width() / 2;

            self.spots.fetch();

            self.endPosition = function() {
//               // goes to the left, and how fast it goes
                return 0 - this.videoDuration * pixelsPerSecond;
            };

            self.setSpotContainerSizeBasedOnLength = function(length) {
                $spotContainer.css("width", length * pixelsPerSecond + $element.width());
            };

            self.updateAndPlayFrom = function(positionInSeconds) {
                // if the videoDuration, set from app.js addEventListener,
                // (spotStream.videoDuration = event.duration)
                if(self.videoDuration) {
                    //how much is left in the movie
                    var secondsLeftInMovieFromCurrentLocation = self.videoDuration - positionInSeconds;

                    $spotContainer.animate({left: self.endPosition()}, secondsLeftInMovieFromCurrentLocation * 1000, "linear");
                }
            };

            self.jumpTo = function(positionInSeconds) {
                $(element).find('.spotContainer').css("left", 0 - positionInSeconds * pixelsPerSecond);
            };

            self.stop = function() {
                $spotContainer.stop();
            };

            self.addSpot = function(marked_at, signed_request) {
                self.spots.create({
                    signed_request: signed_request,
                    fb_user : 'foo',
                    hot_spot : {
                        marked_at : marked_at
                    }
                });
                $("#spotted").text("Hot Spotted!");
                setTimeout("$('#spotted').empty()", 1000);
            };
        };

        var routes = {
            movieSpotsPath : function (movieId) {
                if (movieId == undefined)
                    throw "Spot's movie id is undefined";
                return '/movies/' + movieId + '/hotspots.json';
            }
        };

        // Backbone Stuff
        var Spot = Backbone.Model.extend({});

        var SpotCollection = Backbone.Collection.extend({
            model: Spot,
            initialize: function (collection, options) {
                this.url = routes.movieSpotsPath(options.movieId);
            }
        });

        var SpotView = Backbone.View.extend({
            className: "like",
            render: function() {
                var spot = this.model.toJSON();
                $(this.el).html(ich.spot_template(spot));
                return this;
            }
        });

        var SpotCollectionView = Backbone.View.extend({
            initialize: function(options) {
                this.el = $(options.parentElement).find(".spotContainer");
                this.spots = options.spots;
                _.bindAll(this, "render");
                this.spots.bind('reset', this.render);
                this.spots.bind('add', this.render);
            },

            render : function() {
                var self = this;
                var $likeContainer = $(self.el);
                var createSpotView = function(spot, index) {
                    var view = new SpotView({model: spot});
                    var el = view.render().el;
                    // Display on 6 different 2em sized lines
                    $(el).css("top", spot.get('top') + 'px');
                    $(el).css("left", self.pixelsPerSecond * spot.attributes.marked_at + self.centerPadding);
                    $likeContainer.append(el);
                };
                this.spots.each(createSpotView);
            }
        });

        // jQuery plugin
        $.fn.spotStream = function(opts) {
            var options = opts || {};
            var movieId = options.movieId;
            var streams = [];
            this.each(function(index, element) {
                var streamForElement = $(element).data("spotStreamObject");
                var stream = streamForElement || new milyoni.SpotStream(element, movieId);
                $(element).data("spotStreamObject", stream);
                streams.push(stream);
            });
            return streams[0];
        };
    })(jQuery);
});
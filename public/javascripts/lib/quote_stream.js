if (window.milyoni === undefined) {
    window.milyoni = {};
}

$(function () {
    (function ($) {
        // Our application widget
        milyoni.QuoteStream = function (element, movieId) {
            var self = this;
            var secondsContainedInWindow = 30;
            var $element = $(element);
            var $quoteContainer = $('<div></div>').addClass("quoteContainer").appendTo($element);
            var pixelsPerSecond = $element.width() / secondsContainedInWindow;

            self.movie_id = movieId;
            self.quotes = new QuoteCollection([], {movieId: movieId});
            self.view = new QuoteCollectionView(
                    {parentElement: element,
                        quotes: this.quotes
                    });
            self.view.pixelsPerSecond = pixelsPerSecond;
            self.view.centerPadding = $element.width() / 2;

            self.quotes.fetch();

            self.endPosition = function() {
                return 0 - this.videoDuration * pixelsPerSecond;
            };

            self.setQuoteContainerSizeBasedOnLength = function(length) {
                $quoteContainer.css("width", length * pixelsPerSecond + $element.width());
            };

            self.updateAndPlayFrom = function(positionInSeconds) {
                if(self.videoDuration) {
                    var secondsLeftInMovieFromCurrentLocation = self.videoDuration - positionInSeconds;
                    $quoteContainer.animate({left: self.endPosition()}, secondsLeftInMovieFromCurrentLocation * 1000, "linear");
                }
            };

            self.jumpTo = function(positionInSeconds) {
                $(element).find('.quoteContainer').css("left", 0 - positionInSeconds * pixelsPerSecond);
            };

            self.stop = function() {
                $quoteContainer.stop();
            };

            self.addQuote = function(text, quoted_at, signed_request) {
                self.quotes.create({
                    signed_request: signed_request,
                    fb_user : 'foo',
                    quote : {
                        quoted_at : quoted_at,
                        text : text
                    }
                });
            };
        };

        var routes = {
            movieQuotesPath : function (movieId) {
                if (movieId == undefined)
                    throw "Quote's movie id is undefined";
                return '/movies/' + movieId + '/quotes.json';
            }
        };

        // Backbone Stuff
        var Quote = Backbone.Model.extend({});

        var QuoteCollection = Backbone.Collection.extend({
            model: Quote,
            initialize: function (collection, options) {
                this.url = routes.movieQuotesPath(options.movieId);
            }
        });

        var QuoteView = Backbone.View.extend({
            className: "like",
            render: function() {
                var quote = this.model.toJSON();
                $(this.el).html(ich.quote_template(quote));
                return this;
            }
        });

        var QuoteCollectionView = Backbone.View.extend({
            initialize: function(options) {
                this.el = $(options.parentElement).find(".quoteContainer");
                this.quotes = options.quotes;
                _.bindAll(this, "render");
                this.quotes.bind('reset', this.render);
                this.quotes.bind('add', this.render);
            },

            render : function() {
                var self = this;
                var $likeContainer = $(self.el);
                var createQuoteView = function(quote, index) {
                    var view = new QuoteView({model: quote});
                    var el = view.render().el;
                    // Display on 6 different 2em sized lines
                    $(el).css("top", 2 * (index % 6) + 'em');
                    $(el).css("left", self.pixelsPerSecond * quote.attributes.quoted_at + self.centerPadding);
                    $likeContainer.append(el);
                };
                this.quotes.each(createQuoteView);
            }
        });

        // jQuery plugin
        $.fn.quoteStream = function(opts) {
            var options = opts || {};
            var movieId = options.movieId;
            var streams = [];
            this.each(function(index, element) {
                var streamForElement = $(element).data("quoteStreamObject");
                var stream = streamForElement || new milyoni.QuoteStream(element, movieId);
                $(element).data("quoteStreamObject", stream);
                streams.push(stream);
            });
            return streams[0];
        };
    })(jQuery);
});
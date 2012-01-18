$.facebox.settings.closeImage = '/images/facebox/closelabel.png';
$.facebox.settings.loadingImage = '/images/facebox/loading.gif';


if (window.milyoni === undefined) {
    window.milyoni = {};
}

$(function() {
    $('#coupon_button').click(function() {
        var the_movie_id = window.movie.id;
        if (the_movie_id == undefined) {
            the_movie_id = movie.id;
        }
        $.ajax({ url: the_movie_id + "/check_coupon.js",
            type: "GET",
            data: {
                code: $('#coupon_value').attr('value'),
                studio_id: window.movie.studio_id,
                fb_user: 'foo',
                signed_request: window.most_recent_signed_request
            },
            error: function(data) {
                $('#coupon_text').html('<font color="red">Invalid code. Try again</font>');
            },
            success: function(data) {
                console.info("********returned price data ******");
                console.info(data);
                var new_value = "<script>movie.price = " + data.price + ";</script>";
                $('#submitBtn').attr('href', data.paypal_incontext_url);
                $('#coupon_final').html(new_value);
                $('#coupon_text').html('Your ' + data.percent + '% discount was accepted. Please continue with the rental for your discount.');
                $('#coupon_value').hide();
                $('#coupon_button').hide();
            }
        });
    });
});


milyoni.addWatchNowPopUp = function() {

    //open group discount
    var openGroupDiscountInFacebox = function openGroupDiscountInFacebox() {
        var groupDiscountForm = '<div id="dialogueBox" class="module-modal"  >' +
            '<a class="close"></a>' +
            '<h2>Rent Now or Share with Friends</h2>' +
            '<p>Click the "Rent and Share" button and the first 5 friends that rent the movie will save (10 Credits) off the price of their rental.</p>' +
            '<h5>Please disable pop-up blockers to ensure the delivery of your Share With Friends coupon after purchase.</h5>' +
            '<img alt="" class="fleft gfxModal" src= ' + window.movie.thumb_popup_image + ' >' +
            '<img alt="" class="fleft logoModal" src=' + window.movie.logo_popup_image + '>' +
            '<form id="new_order_form" action="/studios/' + window.movie.studio_id + '/movies/' + window.movie.id + '/orders/new">' +
            '<div id="two_button_row">' +
            '<input type="button" id="buy" value="Rent" class="btn-submit">' +
            '<span id="spacer"></span>' +
            '<input type="button" id="groupDiscount" value="Rent and Share" class="btn-submit">' +
            '</div> ' +
            '</form>' +
            '</div>';

        $.facebox(groupDiscountForm);
        $('#buy').click(function(event) {
            event.preventDefault();
            milyoni.renderPurchaseDialog(movie.id, movie.price, 0, 'N/A', false);
        });

        $('#groupDiscount').click(function(event) {
            event.preventDefault();
            milyoni.renderPurchaseDialog(movie.id, movie.price, 0, 'N/A', 'true');
        });

    };

    //expired dialog box
    var openExpiredDialogInFacebox = function() {
        var expiredDialog = '<div id="dialogueBox" class="module-modal"  >' +
            '<a class="close"></a>' +
            '<h2>Sorry this discount has expired or rent the movie now</h2>' +
            '<p></p>' +
            '<img alt="" class="fleft gfxModal" src= ' + window.movie.thumb_popup_image + ' >' +
            '<img alt="" class="fleft logoModal" src=' + window.movie.logo_popup_image + '>' +
            '<form id="new_order_form" action="/studios/' + window.movie.studio_id + '/movies/' + window.movie.id + '/orders/new">' +
            '<div id="two_button_row">' +
            '<input type="button" id="buy" value="Buy" class="btn-submit">' +
            '<span id="spacer"></span>' +
            '</div> ' +
            '</form>' +
            '</div>';

        $.facebox(expiredDialog);

        $('#buy').click(function(event) {
            event.preventDefault();
            milyoni.renderPurchaseDialog(movie.id, movie.price, 0, 'N/A', false);
        });

    };

    //Viewing party complete dialog
    var openPartyCompleteInFacebox = function() {
        var partyDialog = '<div id="dialogueBox" class="module-modal"  >' +
            '<a class="close"></a>' +
            '<h2>Sorry the viewing party is complete.</h2>' +
            '<p></p>' +
            '<img alt="" class="fleft gfxModal" src= ' + window.movie.thumb_popup_image + ' >' +
            '<img alt="" class="fleft logoModal" src=' + window.movie.logo_popup_image + '>' +
            '</div>';

        $.facebox(partyDialog);
    };


    //open dialog box
    var openTaxDialogInFacebox = function openTaxDialogInFacebox() {
        if ($('#coupon_value')) {
            var couponCode = $('#coupon_value').attr('value');
        }
        var zipCodeForm = '<div id="dialogueBox" class="module-modal"  >' +
            '<a class="close"></a>' +
            '<h2>Please Enter Your Zip Code Below:</h2>' +
            '<img alt="" class="fleft gfxModal" src= ' + window.movie.thumb_popup_image + ' >' +
            '<img alt="" class="fleft logoModal" src=' + window.movie.logo_popup_image + '>' +
            '<form id="new_order_form" action="/studios/' + window.movie.studio_id + '/movies/' + window.movie.id + '/orders/new?coupon_code=' + couponCode + '">' +
            '<div id="zip_row" class="fleft">' +
            '<label for="zip">Zip Code: </label>' +
            '<input type="text" id="zip" name="zip">' +
            '<input type="submit" value ="Go" class="btn-submit">' +
            '</div> ' +
            '</form>' +
            '</div>';

        $.facebox(zipCodeForm);
        $('#new_order_form').ajaxForm({
            success: function(responseBody, status, xhr, form) {
                if (xhr.status == 202) {
                    milyoni.renderPurchaseDialog(responseBody.movie_id, responseBody.price, 0, responseBody.zip_code, false);
                }
            },

            target : "#dialogueBox",
            error: function (xhr) {
                $("#dialogueBox").html($("<h2 class='error'/>").html(xhr.responseText));
            }
        });
    };

    $('a#zeroPayButton').click(function(event) {
        event.preventDefault();
        window.location = milyoni.currentPathWithSignedRequest(false);
    });

    var decisionTree = function() {
        if (movie.studio.match(/warner/i)) {
            openTaxDialogInFacebox();
        }
        else {
            if (window.group_buy_enable) {

                if (window.movie.discount_key) {
                    milyoni.renderPurchaseDialog(movie.id, movie.price - 10, 0, 'N/A', false);
                }
                else if (window.movie.viewing_party_complete) {
                    openPartyCompleteInFacebox();
                }
                else if (window.movie.expired) {
                    openExpiredDialogInFacebox();
                }
                else {
                    openGroupDiscountInFacebox();
                }
            }
            else {
                milyoni.renderPurchaseDialog(movie.id, movie.price, 0, 'N/A', false);
            }
        }
    };

    $('a#zeroPayButton').click(function(event) {
        event.preventDefault();
        window.location = milyoni.currentPathWithSignedRequest(false);
    });

    $('a#payButton').click(function(event) {
        event.preventDefault();
        decisionTree();
    });

    $('a#seriesPassButton').click(function(event) {
        event.preventDefault();
        milyoni.renderPurchaseDialog(movie.id, window.series.price, 0, 'N/A', false);
    });

    $('#payNormalButton').click(function(event) {
        event.preventDefault();

        if (window.group_buy_enable) {

            if (window.movie.discount_key) {
                milyoni.renderPurchaseDialog(movie.id, movie.price - 10, 0, 'N/A', false);
            }
            else if (window.movie.viewing_party_complete) {
                openPartyCompleteInFacebox();
            }
            else if (window.movie.expired) {
                openExpiredDialogInFacebox();
            }
            else {
                openGroupDiscountInFacebox();
            }
        }
        else {
            milyoni.payWithFbCredits(movie.id, movie.price, 0, 'N/A', false);
        }

    });

};


milyoni.paypalOptionPopup = function(movie_id, cost, tax, zip_code, group_discount) {
    var optionForm = '<div id="dialogueBox" class="module-modal"  >' +
        '<a class="close"></a>' +
        '<h2>Pay with Paypal or Facebook Credits?</h2>' +
        '<form id="new_order_form" action="/studios/' + window.movie.studio_id + '/movies/' + window.movie.id + '/orders/new">' +
        '<div id="two_button_row">' +
        '<input type="button" id="credits" value="Facebook Credits" class="btn-submit">' +
        '<span id="spacer"></span>' +
        '<span id="paypal_button"><a href="/studios/' +
        window.movie.studio_id + '/movies/' +
        window.movie.id + '/paypal/new?signed_request=' +
        window.most_recent_signed_request + '&tax=' +
        tax + '&zip_code=' + zip_code + '&gd=' + group_discount + '&dl=' + window.movie.discount_key_link +
        '"><img src="https://www.paypal.com/en_US/i/btn/btn_xpressCheckout.gif"></a> </span>' +
        '</div> ' +
        '</form>' +
        '</div>';

    $.facebox(optionForm);

    $('#credits').click(function(event) {
        event.preventDefault();
        jQuery(document).trigger('close.facebox');
        milyoni.payWithFbCredits(movie_id, cost, tax, zip_code, group_discount);
    });
};


milyoni.renderPurchaseDialog = function(movie_id, cost, tax, zip_code, group_discount) {
    jQuery(document).trigger('close.facebox');
    milyoni.payWithFbCredits(movie_id, cost, tax, zip_code, group_discount)
};

milyoni.currentPathWithSignedRequest = function(g_discount) {
    var newPath = milyoni.currentLocation().
        replace(/#/, '').
        replace(/\?signed_request=.+/, '');


    function addQueryStringParam(originalUrl, name, value) {
        var newUrl = originalUrl;
        var parameterDelimiter = originalUrl.match(/\?/) ? "&" : "?";
        newUrl += parameterDelimiter + name + "=" + value;
        return newUrl;
    }

    newPath = addQueryStringParam(newPath, "signed_request", window.most_recent_signed_request);
    newPath = addQueryStringParam(newPath, "timestamp", new Date().getTime());
    newPath = addQueryStringParam(newPath, "show_facebook_feed_dialog", true);
    newPath = addQueryStringParam(newPath, "show_facebook_feed_dialog_with_group_discount", g_discount);
    newPath = addQueryStringParam(newPath, "discount_key_link", window.movie.discount_key_link);
    newPath = addQueryStringParam(newPath, "discount_key", window.movie.discount_key);
    newPath = addQueryStringParam(newPath, "expired", window.movie.expired);
    newPath = addQueryStringParam(newPath, "viewing_party_complete", window.movie.viewing_party_complete);

    if (window.movie.price == '0') {
        newPath = addQueryStringParam(newPath, "zero_price", true);
    }

    return newPath;
};

milyoni.currentLocation = function () {
    return document.location.href;
};

milyoni.currentProtocol = function() {
    return document.location.protocol;
};

milyoni.renderFlashUpgradeDialog = function() {
    var dialog = '<div id="dialogueBox" class="module-modal"  >' +
        '<a class="close"></a>' +
        '<h2>Upgrade your flash player!</h2>' +
        '<p style="color:#fff;margin-top:80px;"> Follow this link to upgrade to the latest flash player <a href="http://get.adobe.com/flashplayer/" target="_blank">Adobe Flash Player</a></p>'
    '</div>';
    $.facebox(dialog);
};

milyoni.checkFlashPlayerUpgrade = function() {
    if (window.swfobject.getFlashPlayerVersion().major == 9) {
        return window.flash_player_upgrade_dialog;
    }
    else {
        return false;
    }
};

milyoni.renderFacebookFeedDialogOnPageLoad = function() {
    if (!milyoni.checkFlashPlayerUpgrade()) {
        if (window.show_facebook_feed_dialog_with_group_discount) {
            milyoni.renderFacebookFeedDialogForDiscount();
        }
        else if (window.show_facebook_feed_dialog) {
            milyoni.renderFacebookFeedDialog();
        }
    }
};



milyoni.addFacebookSharePopup = function() {
    $('#facebookShareButton').click(function() {
        milyoni.renderFacebookFeedDialog();
    });
};


milyoni.makeProtocolRelative = function (link) {
    if (link === undefined) return;
    var newLink = link.replace(/(https?:)?\/\//, '');
    return milyoni.currentProtocol() + "//" + newLink;
};

milyoni.insertPlayer = function() {
    if ($("#mediaspace").length > 0) {
        milyoni.insertMoviePlayer();
    } else if ($("#milyoniPlayer").length > 0) {
        milyoni.insertMilyoniPlayer();
    }
};


$(function () {
    if (!milyoni.checkFlashPlayerUpgrade()) {
        milyoni.addWatchNowPopUp();

        milyoni.insertPlayer();

        milyoni.addFacebookSharePopup();
    }
    else {
        milyoni.renderFlashUpgradeDialog();
    }
});

BehaviorMap[".orders.show"] = function () {


    if ($("#brightcovePlayer").length > 0) {
        var commentStream = $("#commentStream").commentStream({movieId: window.movie.id});
        milyoni.commentStream = commentStream;

        window.onTemplateLoaded = function onTemplateLoaded(experienceID) {
            var bcExp = brightcove.getExperience(experienceID);
            var videoPlayer = bcExp.getModule(APIModules.VIDEO_PLAYER);

            // get references to the modules we'll need
            console.info("modCued");

            var modCue = bcExp.getModule(APIModules.CUE_POINTS);

            console.info("mod Exped");

            var modExp = bcExp.getModule(APIModules.EXPERIENCE);


            var getPlayerTime = function getPlayerTime() {
                return videoPlayer.getVideoPosition(true);
            };

            var sendCommentToCommentStream = function(text, time) {
                var fulltext = text;
                commentStream.addComment(fulltext,
                    Math.round(videoPlayer.getVideoPosition()),
                    window.most_recent_signed_request);
            };


            var publishLikeToFacebook = function (time) {
                var message = 'likes ' + time + ' in ' + window.movie.feed_dialog_name;
                FB.api('/me/feed', 'post',
                    {
                        message: message,
                        link: milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
                        picture: milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
                        caption: window.movie.feed_dialog_caption,
                        name: "I am watching " + window.movie.feed_dialog_name,
                        description: window.movie.feed_dialog_desc
                    });
            };
            var publishCommentToFacebook = function (comment, time) {
                var message = comment;

                FB.api('/me/feed', 'post',
                    {
                        message: message,
                        link: milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
                        picture: milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
                        caption: window.movie.feed_dialog_caption,
                        name: "I am watching " + window.movie.feed_dialog_name,
                        description: window.movie.feed_dialog_desc
                    });
            };


            // beginning play where you left it at.
            $('#videoPlayerBox').bind("beforeunload", function (event) {
                $.jsonp("/studios/" + window.movie.studio_id + "/movies/" + window.movie.id + "/orders/cookie?" + "order_id=" + window.order.id + "&left_at=" + parseInt(videoPlayer.getVideoPosition()));
            });

            modExp.addEventListener(BCExperienceEvent.TEMPLATE_READY, function(event) {
                videoPlayer.play();
            });

            videoPlayer.addEventListener(BCMediaEvent.BEGIN, function (event) {
                commentStream.videoDuration = event.duration;
                commentStream.setCommentContainerSizeBasedOnLength(event.duration);
                commentStream.updateAndPlayFrom(event.position);
                queBar.build(event.media.cuePoints, commentStream.videoDuration);
            });


            videoPlayer.addEventListener(BCMediaEvent.PLAY, function (event) {
                commentStream.updateAndPlayFrom(event.position);
            });

            modCue.addEventListener(BCCuePointEvent.CUE, queBar.load);


            videoPlayer.addEventListener(BCMediaEvent.STOP, function(event) {
                commentStream.stop();
                queBar.stop();
            });

            videoPlayer.addEventListener(BCMediaEvent.SEEK, function(event) {
                commentStream.jumpTo(event.position);
            });

            videoPlayer.addEventListener(BCMediaEvent.PROGRESS, function(event) {
                queBar.mark(event.position, event.duration);
            });


            milyoni.seek = function (time) {
                videoPlayer.seek(time - 1);
                commentStream.stop();
                commentStream.updateAndPlayFrom(time);
            };

            $('.insertCommentButton').click(function() {
                var time = getPlayerTime();
                var _comment = $(".commentText").val();
                sendCommentToCommentStream(_comment, time);
                publishCommentToFacebook(_comment, time);
            });
        };
        milyoni.createBrightcoveExperience(brightcovePlayerID, brightcovePlayerKey, brightcoveVideoID);

    }

};



function showCarouselControls() {
    if (window.gallery_size && window.gallery_size.active <= 5) {
        $('#rentals.gallerySection a.prev').css('opacity', '0.0');
        $('#rentals.gallerySection a.next').css('opacity', '0.0');
    }
    if (window.gallery_size && window.gallery_size.all <= 15) {
        $('div#galleryCarousel.carousel a.prev').css('opacity', '0.0');
        $('div#galleryCarousel.carousel a.next').css('opacity', '0.0');
    }
}


$('div#galleryCarousel').ready(function() {
    showCarouselControls();
});





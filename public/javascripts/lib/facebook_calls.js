function fbCallQuote() {
    $.ajax({ url:"/api/cues/share_counter",
        type:"GET",
        data:{ kind:"quote", id:milyoni.quote.id,
            studio_id:window.movie.studio_id,
            signed_request:window.most_recent_signed_request
        }
    });


    $('div#quoteFrame').hide();
    var ui_options = {
        method:'feed',
        name:'"' + milyoni.quote.text + '"',
        link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
        picture:milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
        caption:window.movie.feed_dialog_caption,
        description:window.movie.feed_dialog_desc,
        message:''
    };
    FB.ui(ui_options);
}

function fbCallQuoteTop(quoteId, text) {
    $.ajax({ url:"/api/cues/share_counter",
        type:"GET",
        data:{ kind:"quote", id:quoteId,
            studio_id:window.movie.studio_id,
            signed_request:window.most_recent_signed_request
        }
    });


    $('div#quoteFrame').hide();
    var ui_options = {
        method:'feed',
        name:'"' + text.replace('`', '"') + '"',
        link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
        picture:milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
        caption:window.movie.feed_dialog_caption,
        description:window.movie.feed_dialog_desc,
        message:''
    };
    FB.ui(ui_options);
}


function fbCallClip() {
    $.ajax({ url:"/api/cues/share_counter",
        type:"GET",
        data:{ kind:"clip", id:milyoni.clip.id,
            studio_id:window.movie.studio_id,
            signed_request:window.most_recent_signed_request
        }
    });

    $('div#clipFrame').hide();
    var ui_options = {
        method:'feed',
        type:'video',
        source:"http://c.brightcove.com/services/viewer/federated_f9?isVid=1&isUI=1&publisherID=938558697001&playerID=1101654023001&domain=embed&videoId=" + milyoni.clip.video_id,
        name:milyoni.clip.name,
        link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
        picture:milyoni.clip.thumbnail_url,
        caption:window.movie.feed_dialog_caption,
        description:window.movie.feed_dialog_desc,
        message:''
    };

    FB.ui(ui_options);
}


function fbCallClipTop(clipId, name, VideoId, thumbnailUrl) {

    $.ajax({ url:"/api/cues/share_counter",
        type:"GET",
        data:{ kind:"clip", id:clipId,
            studio_id:window.movie.studio_id,
            signed_request:window.most_recent_signed_request
        }
    });

    $('div#clipFrame').hide();
    var ui_options = {
        method:'feed',
        type:'video',
        source:"http://c.brightcove.com/services/viewer/federated_f9?isVid=1&isUI=1&publisherID=938558697001&playerID=1101654023001&domain=embed&videoId=" + VideoId,
        name:name,
        link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
        picture:thumbnailUrl,
        caption:window.movie.feed_dialog_caption,
        description:window.movie.feed_dialog_desc,
        message:''
    };

    FB.ui(ui_options);
}


milyoni.renderFacebookFeedDialogForDiscount = function () {
    var des = window.user.name + " is watching " + window.movie.feed_dialog_name +
        ", Click this link and the first 5 friends that buy the movie will get 10 Credits off the rental price.";
    var ui_options = {
        method:'feed',
        name:window.movie.feed_dialog_name,
        link:window.movie.discount_key_link,
        picture:milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
        caption:"Save 10 Credits on the rental of" + window.movie.feed_dialog_name,
        description:des,
        message:''
    };
    FB.ui(ui_options);
};


milyoni.renderFacebookFeedDialog = function () {
    if (window.movie.actions == 'nil') {
        var ui_options = {
            method:'feed',
            name:window.movie.feed_dialog_name,
            link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
            picture:milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
            caption:window.movie.feed_dialog_caption,
            description:window.movie.feed_dialog_desc,
            message:''
        };

    } else {
        var ui_options = {
            method:'feed',
            name:window.movie.feed_dialog_name,
            link:milyoni.makeProtocolRelative(window.movie.feed_dialog_link),
            picture:milyoni.makeProtocolRelative(window.movie.feed_dialog_image),
            caption:window.movie.feed_dialog_caption,
            description:window.movie.feed_dialog_desc,
            message:'',
            actions:window.movie.actions
        };
    }
    FB.ui(ui_options);

};

milyoni.payWithFbCredits = function (movie_id, cost, tax, zip_code, group_discount) {
    var ui_options = {
        method:'pay',
        order_info:{
            'movie_id':movie_id,
            'cost':cost,
            'tax':tax,
            'zip_code':zip_code,
            'discount_key':window.movie.discount_key
        },
        purchase_type:'item'
    };
    FB.ui(ui_options, function (facebookData) {
        document.location.href = milyoni.currentPathWithSignedRequest(group_discount);
    });
};


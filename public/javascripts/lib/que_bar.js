
queBar = {

    mark : function(position, duration) {
        var factorial_equivalent = 704 / duration;
        var quePosition = factorial_equivalent * position + 18.0;

        $('div#bar_marker').css({left: quePosition});

        return quePosition;
    },

    build : function(cues, duration) {

        var base = duration / 704;

        for (var key in cues) {
            if (cues[key].metadata) {
                var the_kind = queBar.findKindFromMetadata(cues[key].metadata);
                $('#icon_bar').append("<img onclick='milyoni.seek(" + cues[key].time + ");' id='icon_" + key + "' class='icon_bar " + the_kind + "' src='/images/" + the_kind + "_icon.png' >");
                $('#icon_' + key).css("left", (cues[key].time / base) - 6);
            }
        }
        $('#icon_bar').fadeIn();
    },

    load : function(event) {
        $.ajax({

            url: "/api/cues/callback?meta=" + event.cuePoint.metadata + "&movie_id=" + window.movie.id + "&name=" + event.cuePoint.name,
            success: function(stuff) {
                queBar.popupScreen(stuff);
            }
        });
    },

    stop : function() {
        $('div#bar_marker').stop();
    },

    popupScreen : function(stuff) {
        if (stuff.link) {
            $('div#likeFrame').html('<b>' + stuff.name + '</b><br/><img src="' + stuff.picture_url + '"> <iframe src="https://www.facebook.com/plugins/like.php?href=' + stuff.link + '&amp;send=false&amp;layout=standard&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=45" scrolling="no" frameborder="0" style="border:none; overflow:hidden; height:35px;" allowTransparency="true"></iframe>').fadeIn().delay(20000).fadeOut();
        }
        else if (stuff.thumbnail_url == undefined) {
            milyoni.quote = stuff;
            $('div#quoteFrame').html('"' + milyoni.quote.text + '" <img src="/images/share.png" width="60" height="18" class="shareButton" onclick="fbCallQuote();"/>').fadeIn().delay(20000).fadeOut();
        }
        else if (stuff.is_commentary) {
            milyoni.clip = stuff;
            var view_url = "http://c.brightcove.com/services/viewer/federated_f9?isVid=1&isUI=1&publisherID=938558697001&playerID=1101169001001&domain=embed&videoId=" + milyoni.clip.video_id;
            $('div#quoteFrame').html(
                '<object id="flashObj" width="250" height="200" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,47,0"><param name="movie" value="http://c.brightcove.com/services/viewer/federated_f9?isVid=1" /><param name="bgcolor" value="#FFFFFF" /><param name="flashVars" value="playerID=1101169001001&playerKey=AQ~~,AAAA2jbW_lE~,iqhqlbZiY1VRCEo2F_EWDg-BrvXB3QPv&domain=embed&dynamicStreaming=true" /><param name="base" value="http://admin.brightcove.com" /><param name="seamlesstabbing" value="false" /><param name="allowFullScreen" value="true" /><param name="swLiveConnect" value="true" /><param name="allowScriptAccess" value="always" /><embed src="' + view_url +
                    '" bgcolor="#FFFFFF" flashVars="playerID=1101654023001&playerKey=AQ~~,AAAA2jbW_lE~,iqhqlbZiY1VRCEo2F_EWDg-BrvXB3QPv&domain=embed&dynamicStreaming=true" base="http://admin.brightcove.com" name="flashObj" width="250" height="200" seamlesstabbing="false" type="application/x-shockwave-flash" allowFullScreen="true" swLiveConnect="true" allowScriptAccess="always" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash"></embed></object>' +
                    '<br> <img src="/images/share.png" width="60" height="18" class="shareButton" onclick="fbCallQuote();"/>'
            ).fadeIn().delay(20000).fadeOut();
        }
        else {
            milyoni.clip = stuff;
            $('div#clipFrame').html('<img src="' + milyoni.clip.thumbnail_url + '" width="158" height="85" class="clipImage" /> <img src="/images/share.png" width="60" height="18" class="shareButton" onclick="fbCallClip();" />').fadeIn().delay(20000).fadeOut();
        }
    },


    findKindFromMetadata : function(metadata) {
        var kind;

        if (metadata.match(/facebook\.com/)) {
            kind = 'like';
        }
        else if (metadata.match(/\[/)) {
            kind = 'clip';
        }
        else if (metadata.match(/\~/)) {
            kind = 'commentary';
        }
        else {
            kind = 'quote';
        }
        return kind;
    },

    shareCount: function() {

        var iframe = document.getElementsByTagName('iframe')[0],
            iDoc = iframe.contentWindow     // sometimes glamorous naming of variable
                || iframe.contentDocument;  // makes your code working :)
        if (iDoc.document) {
            iDoc = iDoc.document;
            iDoc.body.addEventListener('afterLayout', function() {
                console.info('******* works');
            });
        }


    }

};
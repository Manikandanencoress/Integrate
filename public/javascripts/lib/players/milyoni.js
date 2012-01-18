if (window.milyoni === undefined) {
    window.milyoni = {};
}


milyoni.subDubPlayer = function(link) {
    var flashvars = {};
    flashvars.api = "/api/wb_player_authorizations?movie_id=";

    flashvars.src = window.location.protocol + "//" +  window.location.hostname + window.location.pathname + "/flash_config" + window.order_hash.key + ".f4m";

    flashvars.urlIncludesFMSApplicationInstance = "true";

    var params = {};

    var attributes = {};

    params.quality = "high";
    params.bgcolor = "#FFFFFF";
    params.allowfullscreen = "true";
    params.wmode = "transparent";

    attributes.id = "mediaspace";
    attributes.name = "player";
    attributes.align = "middle";
    attributes.width = "100%";
    attributes.height = "100%";

    swfobject.embedSWF("/MilyoniMediaPlayer.swf", "milyoniPlayer", "703", "375", "9.0.0", "expressInstall.swf", flashvars, params, attributes);
};

milyoni.subDub = function() {
    var chooseVersionForm = '<div id="dialogueBox" class="module-modal"  >' +
        '<a class="close"></a>' +
        '<h2>Choose a version</h2>' +
        '<img alt="" class="fleft gfxModal" src= ' + window.movie.thumb_popup_image + ' >' +
        '<img alt="" class="fleft logoModal" src=' + window.movie.logo_popup_image + '>' +
        '<form id="new_order_form" action="/studios/' + window.movie.studio_id + '/movies/' + window.movie.id + '/orders/new">' +
        '<div id="two_button_row">' +
        '<input type="button" id="original-title" value="Original" class="btn-submit">' +
        '<input type="button" id="subtitled-title" value="Subtitled" class="btn-submit">' +
        '<input type="button" id="dubbed-title" value="Dubbed" class="btn-submit">' +
        '</div> ' +
        '</form>' +
        '</div>';

    $.facebox(chooseVersionForm);
    console.log(window.movie.dubbed_video_link);

    if (window.movie.subtitled_video_link == null || window.movie.subtitled_video_link == '') {
     $('#subtitled-title').hide();
    }

    if (window.movie.dubbed_video_link == null || window.movie.dubbed_video_link == '') {
     $('#dubbed-title').hide();
    }

    $('#original-title').click(function(event) {
//        event.preventDefault();
        jQuery(document).trigger('close.facebox');
        milyoni.subDubPlayer(window.movie.original_video_link);
    });


    $('#subtitled-title').click(function(event) {
//        event.preventDefault();
        jQuery(document).trigger('close.facebox');
        milyoni.subDubPlayer(window.movie.subtitled_video_link);
    });

    $('#dubbed-title').click(function(event) {
//        event.preventDefault();
        jQuery(document).trigger('close.facebox');
        milyoni.subDubPlayer(window.movie.dubbed_video_link);
    });
};

milyoni.insertMilyoniPlayer = function() {
    if ((window.movie.subtitled_video_link == null || window.movie.subtitled_video_link == '') || (window.movie.dubbed_video_link == null || window.movie.dubbed_video_link == '')) {
        milyoni.subDubPlayer(window.movie.original_video_link);
    } else {
        milyoni.subDub();
    }
};




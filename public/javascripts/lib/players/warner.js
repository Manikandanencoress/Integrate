if (window.milyoni === undefined) {
    window.milyoni = {};
}

milyoni.insertMoviePlayer = function() {
    var elementId = "mediaspace";
    if ($("#" + elementId).length == 0) return;

    var swfVersionStr = "10.1.0";
    var xiSwfUrlStr = "/expressInstall.swf";
    var flashvars = {};
    flashvars.poster = window.movie.poster;
    flashvars.api = "/api/wb_player_authorizations?movie_id=" + window.movie.id + "%26facebook_user_id=" + window.user.facebook_id;  // we get to define this API - it's going to hit our app

    var params = {};
    params.quality = "high";
    params.bgcolor = "#FFFFFF";
    params.allowscriptaccess = "sameDomain";
    params.allowfullscreen = "true";
    params.wmode = "transparent";
    var attributes = {};
    attributes.id = "mediaspace";
    attributes.name = "player";
    attributes.align = "middle";
    attributes.width = "100%";
    attributes.height = "100%";

    swfobject.embedSWF("/FBCommerceMediaPlayer_110415.swf", elementId, "703", "375", swfVersionStr, xiSwfUrlStr, flashvars, params, attributes);
};
if (window.milyoni === undefined) {
    window.milyoni = {};
}

milyoni.createBrightcoveExperience = function(playerID, playerKey, videoID) {

    var params = {};
    params.playerID = playerID;
    params.playerKey = playerKey;
    params['@videoPlayer'] = videoID;
    params.bgcolor = "#000000";
    params.width = "703";
    params.height = "375";
    params.isVid = "true";
    params.isUI = "true";
    params.secureConnections = "true";
    params.wmode = "transparent";

    var player = brightcove.createElement("object");
    player.id = 'milyoniPlayer';

    var parameter;
    for (var i in params) {
        parameter = brightcove.createElement("param");
        parameter.name = i;
        parameter.value = params[i];
        player.appendChild(parameter);
    }

    var playerContainer = document.getElementById("brightcovePlayer");
    brightcove.createExperience(player, playerContainer, true);
};
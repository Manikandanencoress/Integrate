describe("milyoni.createBrightcoveExperience", function () {
    it("uses the brightcove JS API to create a player", function () {

        SpecDOM().html('<div id="brightcovePlayer" />');
        spyOn(brightcove, "createExperience");
        milyoni.createBrightcoveExperience('123', '456', '789')

        expect(brightcove.createExperience).toHaveBeenCalled();
        var args = brightcove.createExperience.mostRecentCall.args;
   
        expect(args[1]).toEqual(SpecDOM("#brightcovePlayer")[0]);

        var player = args[0];
        expect(player.id).toEqual('milyoniPlayer');
        expect($(player).find("param[name='playerID']")[0].value).toEqual('123');
        expect($(player).find("param[name='playerKey']")[0].value).toEqual('456');
        expect($(player).find("param[name='@videoPlayer']")[0].value).toEqual('789');
    });
});
describe("Que Bar Specs", function () {

    describe("The Que Marker", function () {
        it("offsets the position of the marker greater than the actual position because of the que bar's position ", function () {
            expect(queBar.mark(105, 7055)).toBeCloseTo('28.48');
            expect(queBar.mark(20, 7055)).toBeCloseTo('20');
        });

        it("moves the que bar toward the right of the que bar", function () {
            SpecDOM().html('<div id="bar_marker" style="left: 18px"/>');
            var container = SpecDOM('#bar_marker');
            container.css("position", "absolute");

            queBar.mark(105, 7055);

            expect(container.css("left")).toBeGreaterThan('20px');
            expect(container.css("left")).toBeLessThan('29px');
        });
    });

    describe("The Que Bar", function () {

        beforeEach(function () {
            cues = [
                { metadata: 'http://www.facebook.com/milyoni',
                    time: 246},
                { metadata: '[1079164031001]',
                    time: 567},
                { metadata: 'are we in napa now?!',
                    time: 1563},
                { metadata: '~1234567~',
                    time: 270}
            ];
        });

        it("returns the right kind of cue object", function () {
            expect(queBar.findKindFromMetadata(cues[0].metadata)).toEqual('like');
            expect(queBar.findKindFromMetadata(cues[1].metadata)).toEqual('clip');
            expect(queBar.findKindFromMetadata(cues[2].metadata)).toEqual('quote');
            expect(queBar.findKindFromMetadata(cues[3].metadata)).toEqual('commentary');
        });

        it("has placed an icon on the que bar", function () {
            SpecDOM().html('<div id="icon_bar"/></div>');
            var container = SpecDOM('div#icon_bar');

            container.css('position', 'relative');
            container.css('width', '704');

            queBar.build(cues, 305);

            expect($(container[0].children[0]).attr('onclick')).toMatch('milyoni.seek');
            expect($(container[0].children[0]).attr('src')).toMatch('_icon.png');

        });

        it("shows the right popup partial"),function () {
            var clip_commentary = { created_at:"2011-10-07T17:40:28Z",
                id: 76,
                is_commentary: true,
                movie_id: 44,
                name: "Steven Bauer: Scarface on Facebook",
                thumbnail_url: "http://brightcove.vo.ll....jpg?pubId=937222930001",
                updated_at: "2011-10-07T17:40:28Z",
                video_id: "1161803744001"
            };
            var quote = { created_at:"2011-08-08T20:59:44Z",
                id: 15,
                movie_id: 44,
                quoted_at: null,
                text: "are we in napa now?!",
                updated_at: "2011-08-08T20:59:44Z"
            };
            var clip_normal = { created_at:"2011-10-07T17:33:25Z",
                id:75,
                is_commentary:null,
                movie_id:44,
                name:"I'm the Dude (R)",
                thumbnail_url:"http://brightcove.vo.ll....jpg?pubId=937222930001",
                updated_at:"2011-10-07T17:33:25Z",
                video_id: "1079164021001"
            };
            var like = { created_at: "2011-10-05T18:13:27Z",
                id: 38, link: "http://www.facebook.com/BigLebowskiMovie",
                movie_id: 44,
                name: "Like",
                picture_url: "http://www.facebook.com/BigLebowskiMovie",
                updated_at: "2011-10-05T18:13:27Z"
            };

//            expect(queBar.popupScreen(clip_commentary)).toEqual("mull");
        }
    });


});
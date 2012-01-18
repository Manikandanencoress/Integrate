beforeEach(function() {
  this.addMatchers({
    toBePlaying: function(expectedSong) {
      var player = this.actual;
      return player.currentlyPlayingSong === expectedSong
          && player.isPlaying;
    }
  })
});

beforeEach(function(){
    SpecDOM().html("");
});

afterEach(function (){
    SpecDOM().html("");
    jQuery(document).trigger('close.facebox');
});

function SpecDOM(selector) {
    var $specDom = $("#jasmine_content");
    if(selector) {
        return $specDom.find(selector);
    } else {
        return $specDom;
    }
}
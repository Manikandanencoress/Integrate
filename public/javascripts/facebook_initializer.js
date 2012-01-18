window.fbAsyncInit = function() {
    if (!window.facebook_app_id) throw "Facebook App ID was undefined";
    FB.init({
        appId: window.facebook_app_id,
        cookie: true,
        xfbml: true
    });

    FB.Canvas.setAutoResize(false);
    FB.Canvas.setSize({ width: 740, height: 1355 });
    milyoni.renderFacebookFeedDialogOnPageLoad();

};

(function() {
    var e = document.createElement('script');
    e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
    e.async = true;
    if (document.getElementById('fb-root'))
        document.getElementById('fb-root').appendChild(e);
}());

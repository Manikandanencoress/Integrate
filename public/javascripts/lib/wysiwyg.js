function changeButtonColor() {
    var c1 = $('#movie_button_color_gradient_1').attr('value');
    var c2 = $('#movie_button_color_gradient_2').attr('value');

    $('#payButton').css({background: "-moz-linear-gradient(top, " + c1 + ", " + c2 + ")"});
    $('#payButton').css({background: "-webkit-linear-gradient(top, " + c1 + ", " + c2 + ")"});
    $('#payButton').css({background: "-ms-linear-gradient(top, " + c1 + ", " + c2 + ")"});
    $('#payButton').css({background: "-o-linear-gradient(top, " + c1 + ", " + c2 + ")"});
    $('#payButton').css({background: "linear-gradient(top, " + c1 + ", " + c2 + ")"});
}


$(function() {
    var movables = ['watch_now',
        'rental_length',
        'share_buttons',
        'fan_page_likers',
        'coupon_code'];

    $.each(movables, function(index, value) {
        $("#w_" + value).draggable({
            cursorAt: {cursor: 'pointer' },
            cursor: 'pointer',
            containment: '.mainContainer',
            stop: function (event, ui) {
                wysiwyg.updatePosition(value, ui.position)
            }
        });
    })

    $('#movie_button_color_gradient_1').blur(function() {
        changeButtonColor();
    });
    $('#movie_button_color_gradient_2').blur(function() {
        changeButtonColor();
    });

});

wysiwyg = {
    updatePosition : function(kind, position) {
        $.ajax({url: "wysiwyg_update",
            type: "PUT",
            data: {kind: kind,
                x: position.left,
                y: position.top}
        })
    }
};
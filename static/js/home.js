/*---------------------------------------------------
Javascript Function FOR PARALLAX EFFECT
---------------------------------------------------*/

$(function(){
    "use strict";

    // Define Some Elements
    var allWindow = $(window),
    body = $('body'),
    top = allWindow.scrollTop();
    // create variables
    var backgrounds = $('.parallax');

    function parallax() {

        // for each of background parallax element
        $.each( backgrounds, function( i, val ) {

            var backgroundObj = $(this),
            backgroundObjTop = backgroundObj.offset().top,
            backgroundHeight = backgroundObj.height();

            // update positions
            top = allWindow.scrollTop();

            var yPos = ((top - backgroundObjTop))/2;

            if ( yPos <= backgroundHeight + backgroundObjTop ) {
                backgroundObj.css({
                backgroundPosition: '50% ' + yPos + 'px'
                });
            }

        });
    };
});
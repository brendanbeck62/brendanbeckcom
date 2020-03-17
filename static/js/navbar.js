/*---------------------------------------------------------------------
Javascript Function For Sticky Navigation Bar AND SMOOTH SCROLLING
----------------------------------------------------------------------*/

$(function(){
    "use strict";

    // Define Some Elements
    var allWindow = $(window),
    body = $('body'),
    top = allWindow.scrollTop(),
    navBar = $(".nav-wrapper");


// Define stikyNav Function
    function stikyNav() {

        top = allWindow.scrollTop();

        if ( top >= 100 ) {
            navBar.addClass("nav-sticky");

        } else {
            navBar.removeClass("nav-sticky");
        }

        // SHow Also Scroll up Button
        if ( top >= 1000 ) {
            $('.scroll-up').addClass("show-up-btn");
        } else {
            $('.scroll-up').removeClass("show-up-btn");
        }
    }

    // Select all links with hashes
    $('a.scroll').on('click', function(event) {
        // On-page links
        if ( location.pathname.replace(/^\//, '') === this.pathname.replace(/^\//, '') && location.hostname === this.hostname ) {
            // Figure out element to scroll to
            var target = $(this.hash),
                speed= $(this).data("speed") || 800;
                target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');

            // Does a scroll target exist?
            if (target.length) {
                // Only prevent default if animation is actually gonna happen
                event.preventDefault();
                $('html, body').animate({
                scrollTop: target.offset().top
                }, speed);
            }
        }
    });

    $(".scroll-up").on('click', function (e) {
        e.preventDefault();
        $('html, body').animate({
            scrollTop: 0
        }, 900);
    });


/*---------------------------------------------------------------------
Javascript Function for Hide Navbar Dropdown After Click On Links
-------------------------------------------------------------------*/

    var navLinks = navBar.find(".navbar-collapse ul li a");
    $.each( navLinks, function( i, val ) {
        var navLink = $(this);

        navLink.on('click', function (e) {
        navBar.find(".navbar-collapse").collapse('hide');
        });
    });


/*----------------------------------------------------------------
Javascript Function For Change active Class on navigation bar
-----------------------------------------------------------------*/

    var sections = $('.one-page-section'),
        navList = navBar.find("ul.navbar-nav");

    // Define ChangeClass Function
    function ChangeClass() {

        top = allWindow.scrollTop();

        $.each(sections, function(i,val) {

        var section = $(this),
            section_top = section.offset().top,
            bottom = section_top + section.height();

            if (top >= section_top && top <= bottom) {

                var naItems = navList.find('li');

                $.each(naItems ,function(i,val) {
                    var item = $(this);
                    item.find("a").removeClass("active");
                });

                navList.find('li [href="#' + section.attr('id') + '"]').addClass('active');
            }

        });

    } // End of ChangeClass Function
});
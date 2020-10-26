

jQuery(function ($) {
    'use strict';
    siteIstotope();
    loader();
    animateReveal();
});


// isotope anumations
var siteIstotope = function () {
    var $container = $('#posts').isotope({
        itemSelector: '.item',
        isFitWidth: true
    });

    $(window).resize(function () {
        $container.isotope({
            columnWidth: '.col-sm-3'
        });
    });

    $container.isotope({ filter: '*' });

    $('#filters').on('click', 'a', function (e) {
        e.preventDefault();
        var filterValue = $(this).attr('data-filter');
        $container.isotope({ filter: filterValue });
        $('#filters a').removeClass('active');
        $(this).addClass('active');
    });

    $container.imagesLoaded()
        .progress(function () {
            $container.isotope('layout');
        })
        .done(function () {
            $('.gsap-reveal-img').each(function () {
                var html = $(this).html();
                $(this).html('<div class="reveal-wrap"><span class="cover"></span><div class="reveal-content">' + html + '</div></div>');
            });

            var controller = new ScrollMagic.Controller();
            var revealImg = $('.gsap-reveal-img');
            if (revealImg.length) {
                var i = 0;
                revealImg.each(function () {
                    var cover = $(this).find('.cover'),
                        revealContent = $(this).find('.reveal-content'),
                        img = $(this).find('.reveal-content img');

                    var tl2 = new TimelineMax();

                    setTimeout(function () {
                        tl2
                        tl2.set(img, { scale: '2.0', autoAlpha: 1, })
                            .to(cover, 1, {
                                marginLeft: '0', ease: Expo.easeInOut, onComplete() {
                                    tl2.set(revealContent, { autoAlpha: 1 });
                                    tl2.to(cover, 1, { marginLeft: '102%', ease: Expo.easeInOut });
                                    tl2.to(img, 2, { scale: '1.0', ease: Expo.easeOut }, '-=1.5');
                                }
                            })
                    }, i * 700);

                    var scene = new ScrollMagic.Scene({
                        triggerElement: this,
                        duration: "0%",
                        reverse: false,
                        offset: "-300%",
                    })
                        .setTween(tl2)
                        .addTo(controller);
                    i++;
                });
            }
        })

    $('.js-filter').on('click', function (e) {
        e.preventDefault();
        $('#filters').toggleClass('active');
    });

}

var loader = function () {
    setTimeout(function () {
        TweenMax.to('.site-loader-wrap', 1, { marginTop: 50, autoAlpha: 0, ease: Power4.easeInOut });
    }, 10);
    $(".site-loader-wrap").delay(200).fadeOut("slow");
    $("#site-loader-overlayer").delay(200).fadeOut("slow");
}


var animateReveal = function () {
    var controller = new ScrollMagic.Controller();

    var greveal = $('.gsap-reveal');

    // gsap reveal
    $('.gsap-reveal').each(function () {
        $(this).append('<span class="cover"></span>');
    });
    if (greveal.length) {
        var revealNum = 0;
        greveal.each(function () {
            var cover = $(this).find('.cover');
            var tl = new TimelineMax();
            setTimeout(function () {
                tl
                    .fromTo(cover, 2, { skewX: 0 }, { xPercent: 103, transformOrigin: "0% 100%", ease: Expo.easeInOut })
            }, revealNum * 0);
            var scene = new ScrollMagic.Scene({
                triggerElement: this,
                duration: "0%",
                reverse: false,
                offset: "-300%",
            })
                .setTween(tl)
                .addTo(controller);
            revealNum++;
        });
    }
}

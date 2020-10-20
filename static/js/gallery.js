AOS.init({
    duration: 800,
    easing: 'ease',
    once: true,
    offset: -100
});

jQuery(function ($) {
    'use strict';
    siteIstotope();
    loader();
    floatingLabel();
    portfolioItemClick();
    contactForm();
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
    $("#unslate_co--overlayer").delay(200).fadeOut("slow");
}

// form stuff
var floatingLabel = function () {
    $('.form-control').on('input', function () {
        var $field = $(this).closest('.form-group');
        if (this.value) {
            $field.addClass('field--not-empty');
        } else {
            $field.removeClass('field--not-empty');
        }
    });
};

// load ajax page
var portfolioItemClick = function () {
    $('.ajax-load-page').on('click', function (e) {

        var id = $(this).data('id'),
            href = $(this).attr('href');

        if ($('#portfolio-single-holder > div').length) {
            $('#portfolio-single-holder > div').remove();
        }

        TweenMax.to('.loader-portfolio-wrap', 1, { top: '-50px', autoAlpha: 1, display: 'block', ease: Power4.easeOut });

        $('html, body').animate({
            scrollTop: $('#portfolio-section').offset().top - 50
        }, 700, 'easeInOutExpo', function () {
        });

        setTimeout(function () {
            loadPortfolioSinglePage(id, href);
        }, 100);

        e.preventDefault();

    });

    // Close
    $('body').on('click', '.js-close-portfolio', function () {

        setTimeout(function () {
            $('html, body').animate({
                scrollTop: $('#portfolio-section').offset().top - 50
            }, 700, 'easeInOutExpo');
        }, 200);

        TweenMax.set('.portfolio-wrapper', { visibility: 'visible', height: 'auto' });
        TweenMax.to('.portfolio-single-inner', 1, {
            marginTop: '50px', opacity: 0, display: 'none', onComplete() {
                TweenMax.to('.portfolio-wrapper', 1, { marginTop: '0px', autoAlpha: 1, position: 'relative' });

            }
        });

    });
};

$(document).ajaxStop(function () {
    setTimeout(function () {
        TweenMax.to('.loader-portfolio-wrap', 1, { top: '0px', autoAlpha: 0, ease: Power4.easeOut });
    }, 400);
});

var loadPortfolioSinglePage = function (id, href) {
    $.ajax({
        url: href,
        type: 'GET',
        success: function (html) {

            TweenMax.to('.portfolio-wrapper', 1, {
                marginTop: '50px', autoAlpha: 0, visibility: 'hidden', onComplete() {
                    TweenMax.set('.portfolio-wrapper', { height: 0 });
                }
            })

            var pSingleHolder = $('#portfolio-single-holder');

            var getHTMLContent = $(html).find('.portfolio-single-wrap').html();

            pSingleHolder.append(
                '<div id="portfolio-single-' + id +
                '" class="portfolio-single-inner"><span class="unslate_co--close-portfolio js-close-portfolio d-flex align-items-center"><span class="close-portfolio-label">Back to Portfolio</span><span class="icon-close2 wrap-icon-close"></span></span>' + getHTMLContent + '</div>'
            );

            setTimeout(function () {
                owlSingleSlider();
            }, 10);

            setTimeout(function () {
                TweenMax.set('.portfolio-single-inner', { marginTop: '100px', autoAlpha: 0, display: 'none' });
                TweenMax.to('.portfolio-single-inner', .5, {
                    marginTop: '0px', autoAlpha: 1, display: 'block', onComplete() {

                        TweenMax.to('.loader-portfolio-wrap', 1, { top: '0px', autoAlpha: 0, ease: Power4.easeOut });
                    }
                });
            }, 700);
        }
    });

    return false;

};

var contactForm = function () {
    if ($('#contactForm').length > 0) {
        $("#contactForm").validate({
            rules: {
                name: "required",
                email: {
                    required: true,
                    email: true
                },
                message: {
                    required: true,
                    minlength: 5
                }
            },
            messages: {
                name: "Please enter your name",
                email: "Please enter a valid email address",
                message: "Please enter a message"
            },
            errorElement: 'span',
            errorLabelContainer: '.form-error',
            /* submit via ajax */
            submitHandler: function (form) {
                var $submit = $('.submitting'),
                    waitText = 'Submitting...';

                $.ajax({
                    type: "POST",
                    url: "php/send-email.php",
                    data: $(form).serialize(),

                    beforeSend: function () {
                        $submit.css('display', 'block').text(waitText);
                    },
                    success: function (msg) {
                        if (msg == 'OK') {
                            $('#form-message-warning').hide();
                            setTimeout(function () {
                                $('#contactForm').fadeOut();
                            }, 1000);
                            setTimeout(function () {
                                $('#form-message-success').fadeIn();
                            }, 1400);

                        } else {
                            $('#form-message-warning').html(msg);
                            $('#form-message-warning').fadeIn();
                            $submit.css('display', 'none');
                        }
                    },
                    error: function () {
                        $('#form-message-warning').html("Something went wrong. Please try again.");
                        $('#form-message-warning').fadeIn();
                        $submit.css('display', 'none');
                    }
                });
            }

        });
    }
};

// TODO IMPORTANT
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
                    .fromTo(cover, 2, { skewX: 0 }, { xPercent: 101, transformOrigin: "0% 100%", ease: Expo.easeInOut })
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

    // gsap reveal hero
    $('.gsap-reveal-hero').each(function () {
        var html = $(this).html();
        $(this).html('<span class="reveal-wrap"><span class="cover"></span><span class="reveal-content">' + html + '</span></span>');
    });
    var grevealhero = $('.gsap-reveal-hero');

    if (grevealhero.length) {
        var heroNum = 0;
        grevealhero.each(function () {
            var cover = $(this).find('.cover'),
                revealContent = $(this).find('.reveal-content');
            var tl2 = new TimelineMax();
            setTimeout(function () {
                tl2
                    .to(cover, 1, {
                        marginLeft: '0', ease: Expo.easeInOut, onComplete() {
                            tl2.set(revealContent, { x: 0 });
                            tl2.to(cover, 1, { marginLeft: '102%', ease: Expo.easeInOut });
                        }
                    })
            }, heroNum * 0);

            var scene = new ScrollMagic.Scene({
                triggerElement: this,
                duration: "0%",
                reverse: false,
                offset: "-300%",
            })
                .setTween(tl2)
                .addTo(controller);

            heroNum++;
        });
    }

}

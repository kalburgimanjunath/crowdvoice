Class('FeatureSlider')({
    prototype: {
        init: function (element, options) {
            this.options = {
                step: 1,
                current: 0,
            };
            $.extend(this.options, options);
            this.element = typeof element == "string" ? $(element) : element;
            this.timeout = '';            
            this._bindEvents();
        },

        _bindEvents: function () {
            var that = this
            that.hoverStop();
            that.slideShow();
            that.selectSlide();
        },

        slideShow: function () {
            var that = this
            var current = $('.home-slider .active');
            var next = current.next().length ? current.next() : current.parent().children(':first'); 
            var currentPoint = $('.paginate-menu .active');
            var nextPoint = currentPoint.next().length ? currentPoint.next() : currentPoint.parent().children(':first'); 

            current.removeClass('active');
            currentPoint.removeClass('active')

            that.showSlide(next, nextPoint); 

            that.timeout = setTimeout(function(){
                that.slideShow();
            }, 6000);
        },

        showSlide: function (slide, point) {
            slide.fadeIn().addClass('active');
            point.fadeIn().addClass('active');
        },

        hoverStop: function (slide) {
            var that = this
            $('.home-slider').hover(function() {
                clearInterval(that.timeout);
            }, function() {
                that.slideShow();
            });
        },
        
        selectSlide: function () { 
            var that = this
            $('.paginate-menu li').click(function () {
                var point = $(this)
                var slideIndex = point.html();
                var slide = $('.home-slider li')[slideIndex];

                $('.home-slider li').removeClass('active');
                $('.paginate-menu li').removeClass('active');

                $(slide).addClass('active');
                point.addClass('active');

                clearTimeout(that.timeout);
                that.timeout = setTimeout(function(){
                    that.slideShow();
                }, 6000);
            });
        }
    }
});


// Generated by CoffeeScript 1.8.0
(function() {
  var $, Fit;

  $ = require('jquery');

  Fit = (function() {
    "use strict";
    Fit.prototype._defaults = {
      type: 'cover',
      res: 0.5625,
      maxHeight: null,
      minHeight: null,
      lineHeight: false
    };

    Fit.prototype._init = function() {
      this.resize();
      return this;
    };

    function Fit(el, opts) {
      this.el = el;
      this.opts = $.extend({}, this._defaults, opts);
      this.$el = $(this.el);
      this._init();
    }

    Fit.prototype.setWindowSize = function() {
      this._windowWidth = $(window).width();
      if (this.opts.maxHeight != null) {
        this._windowHeight = this.opts.maxHeight;
      } else if ((this.opts.minHeight != null) && $(window).height() < this.opts.minHeight) {
        this._windowHeight = this.opts.minHeight;
      } else {
        this._windowHeight = $(window).height();
      }
      return this;
    };

    Fit.prototype.getWindowSize = function() {
      return [this._windowWidth, this._windowHeight];
    };

    Fit.prototype.calcSize = function() {
      var displayRes;
      this.setWindowSize();
      displayRes = this.getWindowSize()[1] / this.getWindowSize()[0];
      if (this.opts.res > displayRes) {
        this._width = this.getWindowSize()[0];
        this._height = this._width * this.opts.res;
        this._marginTop = -((this._height - this.getWindowSize()[1]) / 2);
        this._marginLeft = 0;
      } else {
        this._width = this.getWindowSize()[1] / this.opts.res;
        this._height = this._width * this.opts.res;
        this._marginTop = 0;
        this._marginLeft = -((this._width - this.getWindowSize()[0]) / 2);
      }
      return this;
    };

    Fit.prototype.cover = function() {
      this.calcSize();
      this.$el.css({
        width: this._width,
        height: this._height,
        marginTop: this._marginTop,
        marginLeft: this._marginLeft
      });
      if (this.opts.lineHeight === true) {
        this.$el.css({
          lineHeight: "" + this._height + "px"
        });
      }
      return this;
    };

    Fit.prototype.contain = function() {};

    Fit.prototype.resize = function() {
      if (this.opts.type === 'cover') {
        this.cover();
      } else if (this.opts.type === 'contain') {
        this.contain();
      }
      return this;
    };

    return Fit;

  })();

  if (typeof define === 'function' && define.amd) {
    define(function() {
      return Fit;
    });
  } else if (typeof module !== 'undefined' && module.exports) {
    module.exports = Fit;
  } else {
    window.Fit || (window.Fit = Fit);
  }

}).call(this);
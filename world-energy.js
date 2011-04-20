(function() {
  var animateInterval, country, defaultCountries, ktoe, paper, r, view, _i, _len;
  this.WIDTH = 1280;
  this.HEIGHT = 500;
  this.PADDING = 2;
  this.FRICTION = .995;
  this.FRAMERATE = 60;
  this.TOTALENERGYSCALE = .015;
  this.PERCAPITASCALE = 400;
  Raphael.el.offset = function() {
    var dx, dy;
    dx = this.attr("cx") - WIDTH / 2;
    dy = this.attr("cy") - HEIGHT / 2;
    return Math.sqrt(dx * dx + dy * dy);
  };
  Raphael.el.intersects = function(other) {
    var d;
    d = this.distance(other);
    return d < this.attr("r") + other.attr("r") + PADDING;
  };
  Raphael.el.distance = function(other) {
    var dx, dy;
    dx = this.attr("cx") - other.attr("cx");
    dy = this.attr("cy") - other.attr("cy");
    return Math.sqrt(dx * dx + dy * dy);
  };
  paper = Raphael("viz", WIDTH, HEIGHT);
  defaultCountries = ["United States", "China", "Russian Federation", "India", "Japan", "Germany", "Canada", "France", "Brazil", "United Kingdom", "Italy", "Finland"];
  this.views = [];
  this.anchor = paper.circle(WIDTH / 2, HEIGHT / 2, 10);
  for (_i = 0, _len = defaultCountries.length; _i < _len; _i++) {
    country = defaultCountries[_i];
    ktoe = energyAndPopulationData[country].energy[40];
    r = 2 * Math.sqrt(TOTALENERGYSCALE * ktoe / Math.PI);
    view = paper.set();
    view.push(paper.circle(WIDTH / 2, HEIGHT / 2, r).attr({
      title: country,
      fill: "#fff",
      stroke: "#000"
    })).click(function() {
      return this.attr("r", this.attr("r") + 1);
    });
    view.push(paper.text(WIDTH / 2, HEIGHT / 2 - r - 7, country).attr({
      fill: "#f00",
      font: "bold 15px Fontin-Sans, Arial, sans-serif"
    }));
    view.translate(Math.random() * 100, Math.random() * 100);
    views.push(view);
  }
  this.draw = function() {
    var view, _i, _len, _ref, _results;
    pack(views, 0.0003, []);
    _ref = window.views;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      view = _ref[_i];
      _results.push(view.translate(view.dx, view.dy));
    }
    return _results;
  };
  this.pack = function(items, damping, exclude) {
    var d, dx, dy, i, j, view1, view2, vx, vy, _ref, _ref2, _ref3, _ref4, _results;
    if (damping == null) {
      damping = 0.1;
    }
    if (exclude == null) {
      exclude = [];
    }
    window.views.sort(function(a, b) {
      return a[0].offset() - b[0].offset();
    });
    for (i = 0, _ref = window.views.length - 1; (0 <= _ref ? i <= _ref : i >= _ref); (0 <= _ref ? i += 1 : i -= 1)) {
      view1 = window.views[i];
      if (i < window.views.length - 1) {
        for (j = _ref2 = i + 1, _ref3 = window.views.length - 1; (_ref2 <= _ref3 ? j <= _ref3 : j >= _ref3); (_ref2 <= _ref3 ? j += 1 : j -= 1)) {
          view2 = window.views[j];
          d = view1[0].distance(view2[0]);
          if (d === 0) {
            view1.dx = Math.random() * 2 - 1;
            view1.dy = Math.random() * 2 - 1;
            view2.dx = Math.random() * 2 - 1;
            view2.dy = Math.random() * 2 - 1;
          } else {
            r = view1[0].attr("r") + view2[0].attr("r") + PADDING;
            if (d < r - 0.01) {
              dx = view2[0].attr("cx") - view1[0].attr("cx");
              dy = view2[0].attr("cy") - view1[0].attr("cy");
              vx = (dx / d) * (r - d) * 0.5;
              vy = (dy / d) * (r - d) * 0.5;
              view1.dx = -vx;
              view1.dy = -vy;
              view2.dx = vx;
              view2.dy = vy;
            }
          }
        }
      }
    }
    _results = [];
    for (i = 0, _ref4 = window.views.length - 1; (0 <= _ref4 ? i <= _ref4 : i >= _ref4); (0 <= _ref4 ? i += 1 : i -= 1)) {
      view = window.views[i];
      view.dx = view.dx * FRICTION;
      view.dy = view.dy * FRICTION;
      r = view[0].attr("r");
      if (view[0].attr("cx") - r <= 0) {
        view.dx = -view.dx;
      }
      if (view[0].attr("cx") + r >= WIDTH) {
        view.dx = -view.dx;
      }
      if (view[0].attr("cy") - r <= 15) {
        view.dy = -view.dy;
      }
      _results.push(view[0].attr("cy") + r >= HEIGHT ? view.dy = -view.dy : void 0);
    }
    return _results;
  };
  animateInterval = setInterval("draw()", Math.round(1000 / FRAMERATE));
}).call(this);

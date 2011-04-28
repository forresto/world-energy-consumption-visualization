(function() {
  var animateInterval, bar, barText, barView, circle, country, defaultCountries, defaultCountriesLocation, energy, paper, population, r, text, view, _i, _j, _len, _len2;
  this.WIDTH = 1280;
  this.HEIGHT = 650;
  this.PADDING = 2;
  this.FRICTION = .995;
  this.FRAMERATE = 60;
  this.TOTALENERGYSCALE = .0000004;
  this.totalEnergyScaleCurrent = .00000001;
  this.PERCAPITASCALE = 12000;
  this.perCapitaScaleCurrent = 1;
  this.MARGINTOP = 40;
  this.MARGINRIGHT = 200;
  this.MARGINBOTTOM = 0;
  this.MARGINLEFT = 0;
  this.BARHEIGHT = 35;
  this.BARMARGIN = 17;
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
  defaultCountriesLocation = [[205, 446], [945, 283], [712, 150], [726, 363], [946, 541], [530, 268], [109, 182], [412, 164], [434, 593], [281, 105], [549, 421], [542, 58]];
  this.views = [];
  this.viewsPerCapita = [];
  this.dragging = null;
  window.startDrag = function() {
    this.ox = this.attr("cx");
    this.oy = this.attr("cy");
    this.attr({
      opacity: .75
    });
    return window.dragging = this;
  };
  window.doDrag = function(dx, dy) {
    this.attr({
      cx: this.ox + dx,
      cy: this.oy + dy
    });
    return this.view[1].attr({
      "x": this.attr("cx"),
      "y": this.attr("cy") - this.attr("r") - 7
    });
  };
  window.stopDrag = function() {
    this.attr({
      opacity: 1
    });
    return window.dragging = null;
  };
  for (_i = 0, _len = defaultCountries.length; _i < _len; _i++) {
    country = defaultCountries[_i];
    energy = energyAndPopulationData[country].energy[40];
    population = energyAndPopulationData[country].population[40];
    r = 2 * Math.sqrt(totalEnergyScaleCurrent * energy / Math.PI);
    view = paper.set();
    circle = paper.circle(WIDTH / 2, HEIGHT / 2, r).attr({
      title: country,
      fill: "#FFF",
      stroke: "#666"
    }).drag(doDrag, startDrag, stopDrag);
    circle.view = view;
    view.push(circle);
    view.title = country;
    view.energy = energy;
    view.population = population;
    view.index = views.length;
    view.dx = 0;
    view.dy = 0;
    views.push(view);
    barView = paper.set();
    barView.percapita = energy / population;
    bar = paper.rect(WIDTH - MARGINRIGHT, _i * (BARHEIGHT + BARMARGIN) + 10, barView.percapita * PERCAPITASCALE, BARHEIGHT).attr({
      title: country,
      fill: "#fff",
      stroke: "#666"
    });
    barText = paper.text(WIDTH - MARGINRIGHT, _i * (BARHEIGHT + BARMARGIN) + BARHEIGHT + 15, country).attr({
      fill: "#FFF",
      font: "bold 10px Fontin-Sans, Arial, sans-serif",
      "text-anchor": "start"
    });
    barView.push(bar);
    barView.push(barText);
    viewsPerCapita.push(barView);
  }
  for (_j = 0, _len2 = views.length; _j < _len2; _j++) {
    view = views[_j];
    text = paper.text(WIDTH / 2, HEIGHT / 2 - r - 7, view.title).attr({
      fill: "#000",
      font: "bold 15px Fontin-Sans, Arial, sans-serif"
    });
    view.push(text);
    view.translate(defaultCountriesLocation[view.index][0] - WIDTH / 2, defaultCountriesLocation[view.index][1] - HEIGHT / 2);
  }
  this.draw = function() {
    var k_total, kprima, view, _i, _j, _len, _len2, _ref, _results;
    if (totalEnergyScaleCurrent < TOTALENERGYSCALE) {
      totalEnergyScaleCurrent += .000000005;
    }
    k_total = spaceToOccupy();
    for (_i = 0, _len = views.length; _i < _len; _i++) {
      view = views[_i];
      kprima = k_total * totalEnergyScaleCurrent * view.energy / views.length;
      view.ka = kprima;
      view.r = 2 * Math.sqrt(kprima / Math.PI);
      view[0].attr("r", view.r);
      view[1].attr("y", view[0].attr("cy") - view.r - 7);
    }
    pack(views, .00005);
    _ref = window.views;
    _results = [];
    for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
      view = _ref[_j];
      _results.push(view.translate(view.dx, view.dy));
    }
    return _results;
  };
  this.pack = function(items, damping) {
    var d, dx, dy, i, j, view1, view2, vx, vy, _ref, _ref2, _ref3, _results;
    if (damping == null) {
      damping = 0.1;
    }
    window.views.sort(function(a, b) {
      return a[0].offset() - b[0].offset();
    });
    _results = [];
    for (i = 0, _ref = window.views.length - 1; (0 <= _ref ? i <= _ref : i >= _ref); (0 <= _ref ? i += 1 : i -= 1)) {
      view1 = window.views[i];
      if (view1[0] === this.dragging) {
        continue;
      }
      if (i < window.views.length - 1) {
        for (j = _ref2 = i + 1, _ref3 = window.views.length - 1; (_ref2 <= _ref3 ? j <= _ref3 : j >= _ref3); (_ref2 <= _ref3 ? j += 1 : j -= 1)) {
          view2 = window.views[j];
          if (view2[0] === this.dragging) {
            continue;
          }
          d = view1[0].distance(view2[0]);
          if (d === 0) {
            view1.dx = Math.random() * 2 - 1;
            view1.dy = Math.random() * 2 - 1;
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
      view1.dx = view1.dx * FRICTION;
      view1.dy = view1.dy * FRICTION;
      r = view1[0].attr("r");
      if (view1[0].attr("cx") - r <= 0 + MARGINLEFT) {
        view1.dx = -view1.dx;
      }
      if (view1[0].attr("cx") + r >= WIDTH - MARGINRIGHT) {
        view1.dx = -view1.dx;
      }
      if (view1[0].attr("cy") - r <= 0 + MARGINTOP) {
        view1.dy = -view1.dy;
      }
      _results.push(view1[0].attr("cy") + r >= HEIGHT - MARGINBOTTOM ? view1.dy = -view1.dy : void 0);
    }
    return _results;
  };
  this.spaceToOccupy = function() {
    var k_total, tall, views_count, wide;
    tall = HEIGHT - MARGINTOP - MARGINBOTTOM;
    wide = WIDTH - MARGINLEFT - MARGINRIGHT;
    views_count = views.length;
    if (views_count <= 1) {
      if (tall < wide) {
        k_total = Math.PI * (tall / 2) * (tall / 2) * 0.8;
      } else {
        k_total = Math.PI * (wide / 2) * (wide / 2) * 0.8;
      }
    } else if ((1 < views_count && views_count <= 6)) {
      k_total = tall * wide * 0.65;
    } else if ((6 < views_count && views_count <= 20)) {
      k_total = tall * wide * 0.75;
    } else if ((20 < views_count && views_count <= 50)) {
      k_total = tall * wide * 0.80;
    } else if ((50 < views_count && views_count <= 200)) {
      k_total = tall * wide * 0.86;
    } else {
      k_total = tall * wide * 0.92;
    }
    return k_total;
  };
  animateInterval = setInterval("draw()", Math.round(1000 / FRAMERATE));
}).call(this);

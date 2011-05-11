(function() {
  var animateInterval, circle, country, d, defaultCountries, defaultCountriesProperties, view, _i, _len;
  this.WIDTH = 1280;
  this.HEIGHT = 650;
  this.PADDING = 2;
  this.FRICTION = .995;
  this.FRAMERATE = 60;
  this.TOTALENERGYSCALE = 0.2;
  this.totalEnergyScaleCurrent = 0.001;
  this.PERCAPITASCALE = 24000;
  this.perCapitaScaleCurrent = 1;
  this.MARGINTOP = 20;
  this.MARGINRIGHT = 200;
  this.MARGINBOTTOM = 0;
  this.MARGINLEFT = 0;
  this.BARHEIGHT = 35;
  this.BARMARGIN = 19;
  this.showingstickfigures = false;
  defaultCountries = ["United States", "China", "Russian Federation", "India", "Japan", "Germany", "Canada", "France", "Brazil", "United Kingdom", "Italy", "Finland"];
  defaultCountriesProperties = [[205, 446, "americas", "US"], [945, 283, "asia", "CN"], [706, 146, "europe", "RU"], [720, 378, "asia", "IN"], [946, 541, "asia", "JP"], [530, 268, "europe", "DE"], [109, 182, "americas", "CA"], [412, 164, "europe", "FR"], [434, 593, "americas", "BR"], [281, 105, "europe", "UK"], [549, 421, "europe", "IT"], [542, 58, "europe", "FI"]];
  this.views = [];
  for (_i = 0, _len = defaultCountries.length; _i < _len; _i++) {
    country = defaultCountries[_i];
    view = {};
    view.title = country;
    view.energy = energyAndPopulationData[country].energy[40];
    view.population = energyAndPopulationData[country].population[40];
    view.percapita = null;
    if (view.energy && view.population) {
      view.percapita = view.energy / view.population;
    }
    d = Math.round(Math.sqrt(totalEnergyScaleCurrent * view.energy / Math.PI));
    view.totalview = $("<div />").attr({
      title: country,
      "class": "totalview " + defaultCountriesProperties[_i][2]
    }).css({
      "position": "absolute",
      "left": defaultCountriesProperties[_i][0] - d / 2 + "px",
      "top": defaultCountriesProperties[_i][1] - d / 2 + "px"
    }).draggable();
    view.totalview.append($("<h2>" + defaultCountriesProperties[_i][3] + "</h2>"));
    circle = $("<div />").attr({
      title: country,
      "class": "circle " + defaultCountriesProperties[_i][2]
    }).css({
      "width": d,
      "height": d,
      "border-radius": d / 2
    });
    view.totalview.append(circle);
    views.push(view);
    $("#viz").append(view.totalview);
  }
  this.draw = function() {
    var level, view, _i, _j, _len, _len2;
    if (totalEnergyScaleCurrent < TOTALENERGYSCALE) {
      for (_i = 0, _len = views.length; _i < _len; _i++) {
        view = views[_i];
        d = Math.round(Math.sqrt(totalEnergyScaleCurrent * view.energy / Math.PI));
        view.d = d;
        $(view.totalview).css({
          "left": defaultCountriesProperties[_i][0] - d / 2 + "px",
          "top": defaultCountriesProperties[_i][1] - d / 2 + "px"
        }).children(".circle").css({
          "width": d,
          "height": d,
          "border-radius": d / 2
        });
      }
      return totalEnergyScaleCurrent += .001;
    } else if (!showingstickfigures) {
      for (_j = 0, _len2 = views.length; _j < _len2; _j++) {
        view = views[_j];
        if (view.percapita) {
          level = Math.round(view.percapita * PERCAPITASCALE);
          level = Math.max(level, 6);
          level = Math.min(level, 50);
          $(view.totalview).children(".circle").css({
            "background-image": "url(stickFigureDensityDraw/stick_" + level + ".png)",
            "background-position": "" + (view.d / 2) + "px " + (view.d / 2 - 3) + "px"
          });
        }
      }
      return this.showingstickfigures = true;
    }
  };
  animateInterval = setInterval("draw()", Math.round(1000 / FRAMERATE));
}).call(this);

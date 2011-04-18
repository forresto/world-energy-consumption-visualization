(function() {
  var animateInterval, defaultCountries, energyData, height, item, paper, view, width, _i, _len;
  width = 500;
  height = 500;
  Raphael.el.intersects = function(other) {
    var d;
    d = this.distance(other);
    return d < this.attr("r") + other.attr("r");
  };
  Raphael.el.distance = function(other) {
    var thatx, thaty, thisx, thisy;
    thisx = this.attr("cx");
    thisy = this.attr("cy");
    thatx = other.attr("cx");
    thaty = other.attr("cy");
    return Math.sqrt((thisx - thatx) * (thisx - thatx) + (thisy - thaty) * (thisy - thaty));
  };
  paper = Raphael("viz", width, height);
  energyData = window.totalEnergyData;
  defaultCountries = ["United States", "China", "Russian Federation", "India", "Japan", "Germany", "Canada", "France", "Brazil", "United Kingdom", "Italy", "Finland"];
  this.views = [];
  for (_i = 0, _len = energyData.length; _i < _len; _i++) {
    item = energyData[_i];
    if (defaultCountries.indexOf(item["Country Name"]) !== -1) {
      view = paper.set();
      view.push(paper.circle(width / 2, height / 2, Math.random() * 100).attr({
        title: item["Country Name"],
        fill: "r(0.5, 0.5)#fff-#ccc",
        stroke: "#FF0000"
      })).click(function() {
        return console.log(this.attr("title"));
      });
      view.push(paper.text(width / 2, height / 2, item["Country Name"]));
      views.push(view);
    }
  }
  animateInterval = setInterval("draw()", 100);
  this.draw = function() {
    var view, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = views.length; _i < _len; _i++) {
      view = views[_i];
      _results.push(view.translate(Math.random() * 4 - 2, Math.random() * 4 - 2));
    }
    return _results;
  };
}).call(this);

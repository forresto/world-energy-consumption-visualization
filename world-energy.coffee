this.WIDTH = 1280
this.HEIGHT = 650
this.PADDING = 2
this.FRICTION = .995

this.FRAMERATE = 60

this.TOTALENERGYSCALE = 0.27
this.totalEnergyScaleCurrent = 0.01
this.PERCAPITASCALE = 24000
this.perCapitaScaleCurrent = 1

this.MARGINTOP = 20
this.MARGINRIGHT = 200
this.MARGINBOTTOM = 0
this.MARGINLEFT = 0

this.DEFAULTYEAR = 2000


this.showingstickfigures = false

this.defaultCountries = [
  "United States" 
  "Canada"
  "Finland"
  "Russian Federation"
  "Germany"
  "France"
  "United Kingdom"
  "Japan"
  "Italy"
  "Brazil"
  "China"
  "India" ]

this.defaultCountriesProperties = [
  [205, 446, "americas", "us"]
  [109, 182, "americas", "ca"]
  [542, 58, "europe", "fi"] 
  [706, 146, "europe", "ru"]
  [530, 268, "europe", "de"]
  [412, 164, "europe", "fr"]
  [261, 125, "europe", "uk"]
  [946, 541, "asia", "jp"]
  [549, 421, "europe", "it"]
  [434, 593, "americas", "br"]
  [945, 283, "asia", "cn"]
  [720, 378, "asia", "in"]
  ]
  
this.views = []
# this.viewsPerCapita = []

for country in defaultCountries
  view = {}
  view.title = country
  view.initx = defaultCountriesProperties[_i][0]
  view.inity = defaultCountriesProperties[_i][1]
  view.continent = defaultCountriesProperties[_i][2]
  view.abbr = defaultCountriesProperties[_i][3]
  view.energy = energyAndPopulationData[country].energy[DEFAULTYEAR-1960]
  view.population = energyAndPopulationData[country].population[DEFAULTYEAR-1960]
  view.percapita = null
  if view.energy and view.population
    view.percapita = view.energy/view.population
    
  console.log view
  
  # scaling according to area
  d = 2
  
  view.totalview = $("<div />")
    .attr
      title: country
      class: "totalview "+view.continent+" "+view.abbr
    .css
      "position": "absolute"
      "left": view.initx - d/2 +"px"
      "top": view.inity - d/2 +"px"
    .data
      view: view
  view.totalview.append $("<h2>#{view.abbr}</h2>")
  circle = $("<div />")
    .attr
      title: country
      class: "circle "+view.continent
    .css
      "width": d
      "height": d
      "border-radius": d/2
  view.totalview.append circle
  
  view.percapitaview = $('<div />')
    .attr
      title: view.title
      class: "percapitaview "+view.continent+" "+view.abbr
    .data
      view: view
    .append $('<div />')
      .attr
        class: "bar"
      .css
        width: Math.round(view.percapita * PERCAPITASCALE)+"px"
    .append $("<h2>#{view.title}</h2>")
    
    views.push view
    

this.draw = ->
  if totalEnergyScaleCurrent <= TOTALENERGYSCALE
    for view in views
      d = Math.round( Math.sqrt( totalEnergyScaleCurrent * view.energy / Math.PI ) )
      view.d = d
      $(view.totalview)
        .css
          "left": view.initx - d/2 +"px"
          "top": view.inity - d/2 +"px"
        .children(".circle")
          .css
            "width": "#{d}px"
            "height": "#{d}px"
            "border-radius": "#{d/2 + 1}px"
    totalEnergyScaleCurrent += .01
  else if !showingstickfigures
    $("#timeline .slider")
      .slider
        min: 1978
        max: 2009
        value: DEFAULTYEAR
        slide: (event, ui) ->
          changeyear(ui.value)
    changeyear(DEFAULTYEAR)
    this.showingstickfigures = true 
    
    $(".totalview, .percapitaview")
      .mouseenter ->
        abbr = $(this).data("view")["abbr"]
        $(".circle, .bar").addClass("unhighlight")
        $(".#{abbr}").children(".circle, .bar").addClass("highlight")
      .mouseleave ->
        abbr = $(this).data("view")["abbr"]
        $(".circle, .bar").removeClass("unhighlight")
        $(".#{abbr}").children(".circle, .bar").removeClass("highlight")
  
  return false

this.changeyear = (year) ->
  $("#currentyear").text(year)
  index = year - 1960
  for view in views
    view.energy = energyAndPopulationData[view.title].energy[index]
    view.population = energyAndPopulationData[view.title].population[index]
    view.percapita = null
    if view.energy and view.population
      view.percapita = view.energy/view.population
    
    if view.percapita
      $(view.totalview).show('fast')
      $(view.percapitaview).show('fast')
      
      view.od = view.d
      view.ox = $(view.totalview).position().left + view.od/2
      view.oy = $(view.totalview).position().top + view.od/2
      
      d = Math.round( Math.sqrt( totalEnergyScaleCurrent * view.energy / Math.PI ) )
      view.d = d
      
      level = Math.round(view.percapita * 9000);
      level = Math.max(level, 6)
      level = Math.min(level, 40)
      
      $(view.totalview)
        .attr
          "title": view.title + ": " + view.energy + " kilotons of oil equivalent"
        .css
          "left": view.ox - d/2 +"px"
          "top": view.oy - d/2 +"px"
        .children(".circle")
          .attr
            "title": view.title + ": " + view.energy + " kilotons of oil equivalent"
          .css
            "width": "#{d}px"
            "height": "#{d}px"
            "border-radius": "#{d/2 + 1}px"
            "background-image": "url(stickFigureDensityDraw/stick_#{level}.png)"
            "background-position": "#{view.d/2}px #{view.d/2-3}px"
      $(view.percapitaview)
        .attr
          "title": view.title + ": " + Math.round(view.percapita*100000)/100 + " tons of oil equivalent per year"
        .children(".bar")
          .attr
            "title": view.title + ": " + Math.round(view.percapita*100000)/100 + " tons of oil equivalent per year"
          .css
            width: Math.round(view.percapita * PERCAPITASCALE)+"px"
      $(view.percapitaview)
        .children("h2").text( view.title + ": " + Math.round(view.percapita*100000)/100 )
        
    else
      $(view.totalview).hide('fast')
      $(view.percapitaview).hide('fast')




# Sort and add to page
views.sort((a,b) -> b.energy - a.energy)
for view in views
  $("#viz").append view.totalview
  $(view.totalview).draggable()
  
views.sort((a,b) -> b.percapita - a.percapita)
for view in views
  $("#percapita").append view.percapitaview
  
changeyear(DEFAULTYEAR)




# Set the loop
animateInterval = setInterval("draw()", Math.round(1000/FRAMERATE))








`

/**
 * Thanks http://james.padolsey.com/javascript/sorting-elements-with-jquery/
 * jQuery.fn.sortElements
 * --------------
 * @param Function comparator:
 *   Exactly the same behaviour as [1,2,3].sort(comparator)
 *   
 * @param Function getSortable
 *   A function that should return the element that is
 *   to be sorted. The comparator will run on the
 *   current collection, but you may want the actual
 *   resulting sort to occur on a parent or another
 *   associated element.
 *   
 *   E.g. $('td').sortElements(comparator, function(){
 *      return this.parentNode; 
 *   })
 *   
 *   The <td>'s parent (<tr>) will be sorted instead
 *   of the <td> itself.
 */
jQuery.fn.sortElements = (function(){
 
    var sort = [].sort;
 
    return function(comparator, getSortable) {
 
        getSortable = getSortable || function(){return this;};
 
        var placements = this.map(function(){
 
            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,
 
                // Since the element itself will change position, we have
                // to have some way of storing its original position in
                // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );
 
            return function() {
 
                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }
 
                // Insert before flag:
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);
 
            };
 
        });
 
        return sort.call(this, comparator).each(function(i){
            placements[i].call(getSortable.call(this));
        });
 
    };
 
})();

`
this.WIDTH = 1280
this.HEIGHT = 650
this.PADDING = 2
this.FRICTION = .995

this.FRAMERATE = 60

this.TOTALENERGYSCALE = 0.2
this.totalEnergyScaleCurrent = 0.001
this.PERCAPITASCALE = 24000
this.perCapitaScaleCurrent = 1

this.MARGINTOP = 20
this.MARGINRIGHT = 200
this.MARGINBOTTOM = 0
this.MARGINLEFT = 0

this.BARHEIGHT = 35
this.BARMARGIN = 19

this.showingstickfigures = false

defaultCountries = [
  "United States" 
  "China"
  "Russian Federation"
  "India"
  "Japan"
  "Germany"
  "Canada"
  "France"
  "Brazil"
  "United Kingdom"
  "Italy"
  "Finland" ]

defaultCountriesProperties = [
  [205, 446, "americas", "US"]
  [945, 283, "asia", "CN"]
  [706, 146, "europe", "RU"]
  [720, 378, "asia", "IN"]
  [946, 541, "asia", "JP"]
  [530, 268, "europe", "DE"]
  [109, 182, "americas", "CA"]
  [412, 164, "europe", "FR"]
  [434, 593, "americas", "BR"]
  [281, 105, "europe", "UK"]
  [549, 421, "europe", "IT"]
  [542, 58, "europe", "FI"] 
  ]
  
this.views = []
# this.viewsPerCapita = []

for country in defaultCountries
  view = {}
  view.title = country
  view.energy = energyAndPopulationData[country].energy[40]
  view.population = energyAndPopulationData[country].population[40]
  view.percapita = null
  if view.energy and view.population
    view.percapita = view.energy/view.population
  
  # scaling according to area
  d = Math.round( Math.sqrt( totalEnergyScaleCurrent * view.energy / Math.PI ) )
  
  view.totalview = $("<div />")
    .attr
      title: country
      class: "totalview "+defaultCountriesProperties[_i][2]
    .css
      "position": "absolute"
      "left": defaultCountriesProperties[_i][0] - d/2 +"px"
      "top": defaultCountriesProperties[_i][1] - d/2 +"px"
    .draggable()
  view.totalview.append $("<h2>#{defaultCountriesProperties[_i][3]}</h2>")
  circle = $("<div />")
    .attr
      title: country
      class: "circle "+defaultCountriesProperties[_i][2]
    .css
      "width": d
      "height": d
      "border-radius": d/2
  view.totalview.append circle
  
  views.push view
  $("#viz").append view.totalview
  
  # view.title = country
  # view.energy = energy
  # view.population = population
  # view.percapita = percapita
  # view.index = views.length
  # view.dx = 0
  # view.dy = 0
  # views.push view
  # 
  # if percapita
  #   barView = paper.set()
  #   barView.percapita = percapita
  #   bar = paper.rect(WIDTH - MARGINRIGHT, _i * (BARHEIGHT+BARMARGIN) + 10, barView.percapita*PERCAPITASCALE, BARHEIGHT)
  #     .attr
  #       title: country
  #       fill: "#fff"
  #       stroke: "#666"
  #   barText = paper.text(WIDTH - MARGINRIGHT, _i * (BARHEIGHT+BARMARGIN) + BARHEIGHT + 15, country)
  #     .attr
  #       fill: "#FFF"
  #       font: "bold 10px Fontin-Sans, Arial, sans-serif"
  #       "text-anchor": "start"
  #   barView.push bar
  #   barView.push barText
  #   viewsPerCapita.push barView

this.draw = ->
  if totalEnergyScaleCurrent < TOTALENERGYSCALE
    for view in views
      d = Math.round( Math.sqrt( totalEnergyScaleCurrent * view.energy / Math.PI ) )
      view.d = d
      $(view.totalview)
        .css
          "left": defaultCountriesProperties[_i][0] - d/2 +"px"
          "top": defaultCountriesProperties[_i][1] - d/2 +"px"
        .children(".circle")
          .css
            "width": d
            "height": d
            "border-radius": d/2
    totalEnergyScaleCurrent += .001
  else if !showingstickfigures
    for view in views
      if view.percapita
        level = Math.round(view.percapita * PERCAPITASCALE);
        level = Math.max(level, 6)
        level = Math.min(level, 50)
        $(view.totalview).children(".circle")
          .css
            "background-image": "url(stickFigureDensityDraw/stick_#{level}.png)"
            "background-position": "#{view.d/2}px #{view.d/2-3}px";
            
    this.showingstickfigures = true 



# Set the loop
animateInterval = setInterval("draw()", Math.round(1000/FRAMERATE))

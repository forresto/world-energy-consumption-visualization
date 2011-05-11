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


this.showingstickfigures = false

this.defaultCountries = [
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

this.defaultCountriesProperties = [
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
  view.abbr = defaultCountriesProperties[_i][3].toLowerCase()
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
      class: "totalview "+defaultCountriesProperties[_i][2]+" "+defaultCountriesProperties[_i][3].toLowerCase()
    .css
      "position": "absolute"
      "left": defaultCountriesProperties[_i][0] - d/2 +"px"
      "top": defaultCountriesProperties[_i][1] - d/2 +"px"
    .data
      view: view
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
  
  # if view.percapita
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
  if totalEnergyScaleCurrent <= TOTALENERGYSCALE
    for view in views
      d = Math.round( Math.sqrt( totalEnergyScaleCurrent * view.energy / Math.PI ) )
      view.d = d
      $(view.totalview)
        .css
          "left": defaultCountriesProperties[_i][0] - d/2 +"px"
          "top": defaultCountriesProperties[_i][1] - d/2 +"px"
        .children(".circle")
          .css
            "width": "#{d}px"
            "height": "#{d}px"
            "border-radius": "#{d/2 + 1}px"
    totalEnergyScaleCurrent += .01
  else if !showingstickfigures
    this.showingstickfigures = true 
    for view in views
      if view.percapita
        level = Math.round(view.percapita * PERCAPITASCALE);
        level = Math.max(level, 6)
        level = Math.min(level, 40)
        $(view.totalview)
          .draggable()
          .children(".circle")
            .css
              "background-image": "url(stickFigureDensityDraw/stick_#{level}.png)"
              "background-position": "#{view.d/2}px #{view.d/2-3}px";
        view.barview = $('<div />')
          .attr
            title: view.title
            class: "percapitaview "+this.defaultCountriesProperties[_j][2]+" "+this.defaultCountriesProperties[_j][3].toLowerCase()
          .data
            view: view
          .append $('<div />')
            .attr
              class: "bar"
            .css
              width: Math.round(view.percapita * PERCAPITASCALE)+"px"
            
          .append $("<h2>#{view.title}</h2>")
          
        $("#percapita").append view.barview
        
        $(".totalview, .percapitaview")
          .mouseenter ->
            abbr = $(this).data("view")["abbr"]
            $(".#{abbr}").children(".circle, .bar").addClass("highlight")
          .mouseleave ->
            abbr = $(this).data("view")["abbr"]
            $(".#{abbr}").children(".circle, .bar").removeClass("highlight")
  
  return false



# Set the loop
animateInterval = setInterval("draw()", Math.round(1000/FRAMERATE))

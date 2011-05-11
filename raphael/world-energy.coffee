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


Raphael.el.offset = ->
  dx = this.attr("cx") - WIDTH/2
  dy = this.attr("cy") - HEIGHT/2
  return Math.sqrt( dx*dx + dy*dy )

Raphael.el.intersects = (other) ->
  d = this.distance(other)
  return (d < this.attr("r") + other.attr("r") + PADDING)

Raphael.el.distance = (other) ->
  dx = this.attr("cx") - other.attr("cx")
  dy = this.attr("cy") - other.attr("cy")
  return Math.sqrt( dx*dx + dy*dy )

Raphael.el.bounce = ->
  if this is window.dragging
    return
  
  r = this.attr("r")
  
  if this.attr("cx")-r <= 0+MARGINLEFT
    this.view.dx = 1
  else if this.attr("cx")+r >= WIDTH-MARGINRIGHT
    this.view.dx = -1
  else
    this.view.dx = 0
  
  if this.attr("cy")-r <= 0+MARGINTOP
    this.view.dy = 1
  else if this.attr("cy")+r >= HEIGHT-MARGINBOTTOM
    this.view.dy = -1
  else
    this.view.dy = 0
  



# Raphael.el.startDrag = ->
#   this.ox = this.attr("cx")
#   this.oy = this.attr("cy")
#   this.attr({opacity: .75})
# Raphael.el.doDrag = (dx, dy) ->
#   this.attr
#     cx: this.ox + dx
#     cy: this.oy + dy
# Raphael.el.stopDrag = ->
#   this.attr({opacity: 1});


window.paper = Raphael("viz", WIDTH, HEIGHT)


# for i in [6..100]
#   pat = document.createElement("pattern")
#   pat.setAttribute("id", "stick_#{i}")
#   pat.setAttribute("patternUnits", "userSpaceOnUse")
#   pat.setAttribute("width", i*2)
#   pat.setAttribute("height", i*2)
#   pat.innerHTML = "<image xlink:href='stickFigureDensityDraw/stick_#{i}.png' x='0' y='0' width='#{i*2}' height='#{i*2}' />"
#   paper.defs.appendChild(pat)

# energyData = window.energyAndPopulationData

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

defaultCountriesLocation = [
  [205, 446]
  [945, 283]
  [706, 146]
  [720, 378]
  [946, 541]
  [530, 268]
  [109, 182]
  [412, 164]
  [434, 593]
  [281, 105]
  [549, 421]
  [542, 58] 
  ]
  
this.views = []
this.viewsPerCapita = []

# this.anchor = paper.circle(WIDTH/2, HEIGHT/2, 10)

this.dragging = null

window.startDrag = ->
  # storing original coordinates
  this.ox = this.attr("cx")
  this.oy = this.attr("cy")
  this.attr({opacity: .75})
  window.dragging = this
  
window.doDrag = (dx, dy) ->
  # console.log dx, dy
  # this.view.translate(dx, dy)
  this.attr({cx: this.ox + dx, cy: this.oy + dy})
  # move will be called with dx and dy
  # this.view.dx = dx
  # this.view.dy = dy
  # this.attr({cx: this.ox + dx, cy: this.oy + dy})
  # this.view.text.attr
  #   "x": this.attr("cx")
  #   "y": this.attr("cy")-this.attr("r")-7
  
window.stopDrag = ->
  # restoring state
  this.attr({opacity: 1});
  window.dragging = null

for country in defaultCountries
  energy = energyAndPopulationData[country].energy[40]
  population = energyAndPopulationData[country].population[40]
  if energy and population
    percapita = energy/population
  
  # scaling according to area
  r = 2 * Math.sqrt( totalEnergyScaleCurrent * energy / Math.PI )
  
  view = paper.set()
  
  circle = paper.circle(WIDTH/2, HEIGHT/2, r)
    .attr
      title: country
      fill: "#FFF"
      stroke: "#666"
    .drag(doDrag, startDrag, stopDrag)
  circle.view = view
  view.push circle
  view.circle = view
  
  # for i in [1..(parseInt(population/5000000))]
  #   stick = paper.path("m 0,0 v 8 l -4,4 m 4,-4 l 4,4 m -8,-8 h 8 z")
  #     .attr
  #       stroke: "#000"
  #   stick.translate(WIDTH/2 + i*5, HEIGHT/2)
  #   view.push stick
  # view.stick = stick
  
  view.title = country
  view.energy = energy
  view.population = population
  view.percapita = percapita
  view.index = views.length
  view.dx = 0
  view.dy = 0
  views.push view
  
  if percapita
    barView = paper.set()
    barView.percapita = percapita
    bar = paper.rect(WIDTH - MARGINRIGHT, _i * (BARHEIGHT+BARMARGIN) + 10, barView.percapita*PERCAPITASCALE, BARHEIGHT)
      .attr
        title: country
        fill: "#fff"
        stroke: "#666"
    barText = paper.text(WIDTH - MARGINRIGHT, _i * (BARHEIGHT+BARMARGIN) + BARHEIGHT + 15, country)
      .attr
        fill: "#FFF"
        font: "bold 10px Fontin-Sans, Arial, sans-serif"
        "text-anchor": "start"
    barView.push bar
    barView.push barText
    viewsPerCapita.push barView
  
for view in views
  text = paper.text(WIDTH/2, HEIGHT/2 - r - 7, view.title)
    .attr
      fill: "#000"
      font: "bold 15px Fontin-Sans, Arial, sans-serif"
  view.text = text
  view.push text
  view.translate(defaultCountriesLocation[view.index][0]-WIDTH/2, defaultCountriesLocation[view.index][1]-HEIGHT/2)
  
  
this.draw = ->
  # iterations = 15
  # for i in [1..iterations]
  #   pack(views, 0.0003/i, [])
  
  if totalEnergyScaleCurrent < TOTALENERGYSCALE
    totalEnergyScaleCurrent += .001
    for view in views
      view.scale = totalEnergyScaleCurrent * view.energy / views.length
      view.r = 2 * Math.sqrt( view.scale / Math.PI )
      view.circle.attr("r", view.r) # Circle
      view.text.attr("y", view[0].attr("cy") - view.r - 7) # Label
  else if !showingstickfigures
    for view in views
      if view.percapita
        level = Math.round(view.percapita * PERCAPITASCALE);
        level = Math.max(level, 6)
        level = Math.min(level, 75)
        console.log level
        view.circle.attr
          # "fill": "url(#stick_#{level})"
          "fill": "url(stickFigureDensityDraw/stick_#{level}.png)"
    window.showingstickfigures = true
    
    
  if perCapitaScaleCurrent < PERCAPITASCALE
    perCapitaScaleCurrent += 1
  
  # pack(views, .00005)
  
  for view in window.views
    # view[0].bounce()
    view.translate(view.dx, view.dy)
    
    
this.pack = (items, damping=0.1) ->
  window.views.sort((a,b) -> a[0].offset() - b[0].offset())
  
  for i in [0..window.views.length-1]
    view1 = window.views[i]
    if view1[0] is this.dragging
      continue;
    if i < window.views.length-1
      for j in [i+1..window.views.length-1]
        view2 = window.views[j]
        if view2[0] is this.dragging
          continue;
        d = view1[0].distance(view2[0])
        if d is 0
          view1.dx = Math.random()*2-1
          view1.dy = Math.random()*2-1
        else 
          r = view1[0].attr("r") + view2[0].attr("r") + PADDING
          if d < r - 0.01
            dx = view2[0].attr("cx") - view1[0].attr("cx")
            dy = view2[0].attr("cy") - view1[0].attr("cy")
            vx = (dx / d) * (r-d) * 0.5
            vy = (dy / d) * (r-d) * 0.5
            
            view1.dx = -vx
            view1.dy = -vy
            view2.dx = vx
            view2.dy = vy
                
    # pull to center
    # vx = (view1[0].attr("cx") - WIDTH/2) * damping
    # vy = (view1[0].attr("cy") - HEIGHT/2) * damping
    # view1.dx -= vx
    # view1.dy -= vy
    # friction
    view1.dx = view1.dx * FRICTION
    view1.dy = view1.dy * FRICTION
    #bounce off edges
    r = view1[0].attr("r")
    if view1[0].attr("cx") - r <= 0 + MARGINLEFT
      view1.dx = -view1.dx
    if view1[0].attr("cx") + r >= WIDTH - MARGINRIGHT
      view1.dx = -view1.dx
    if view1[0].attr("cy") - r <= 0 + MARGINTOP
      view1.dy = -view1.dy
    if view1[0].attr("cy") + r >= HEIGHT - MARGINBOTTOM
      view1.dy = -view1.dy
    
    
this.spaceToOccupy = ->
  tall = HEIGHT - MARGINTOP - MARGINBOTTOM
  wide = WIDTH - MARGINLEFT - MARGINRIGHT
  
  views_count = views.length
  
  if ( views_count <= 1 )
    if tall < wide
      k_total = Math.PI * (tall/2)*(tall/2) * 0.8 
    else 
      k_total = Math.PI * (wide/2)*(wide/2) * 0.8
  else if 1 < views_count <= 6 
    k_total = tall * wide * 0.65
  else if 6 < views_count <= 20  
    k_total = tall * wide * 0.75
  else if 20 < views_count <= 50  
    k_total = tall * wide * 0.80
  else if 50 < views_count <= 200  
    k_total = tall * wide * 0.86
  else 
    k_total = tall * wide * 0.92
  
  return k_total








# Set the loop
animateInterval = setInterval("draw()", Math.round(1000/FRAMERATE))








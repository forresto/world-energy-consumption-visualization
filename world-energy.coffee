this.WIDTH = 1200
this.HEIGHT = 600
this.PADDING = 2
this.FRICTION = .995

this.FRAMERATE = 60

this.TOTALENERGYSCALE = .00000045
this.PERCAPITASCALE = 400

this.MARGINTOP = 40
this.MARGINRIGHT = 300
this.MARGINBOTTOM = 0
this.MARGINLEFT = 0





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


paper = Raphael("viz", WIDTH, HEIGHT)

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
  
this.views = []

this.anchor = paper.circle(WIDTH/2, HEIGHT/2, 10)

this.dragging = null

window.startDrag = ->
  # storing original coordinates
  this.ox = this.attr("cx")
  this.oy = this.attr("cy")
  this.attr({opacity: .75})
  window.dragging = this
  
window.doDrag = (dx, dy) ->
  # move will be called with dx and dy
  this.attr({cx: this.ox + dx, cy: this.oy + dy})
  this.view[1].attr
    "x": this.attr("cx")
    "y": this.attr("cy")-this.attr("r")-7
  
window.stopDrag = ->
  # restoring state
  this.attr({opacity: 1});
  window.dragging = null


for country in defaultCountries
  energy = energyAndPopulationData[country].energy[40]
  population = energyAndPopulationData[country].population[40]
  
  # scaling according to area
  r = 2 * Math.sqrt( TOTALENERGYSCALE * energy / Math.PI )
  
  view = paper.set()
  circle = paper.circle(WIDTH/2, HEIGHT/2, r)
    .attr
      title: country
      fill: "#fff"
      stroke: "#666"
    .drag(doDrag, startDrag, stopDrag)
  circle.view = view
  text = paper.text(WIDTH/2, HEIGHT/2 - r - 7, country)
    .attr
      fill: "#f00"
      font: "bold 15px Fontin-Sans, Arial, sans-serif"
  view.push circle
  view.push text
  view.translate(Math.random()*WIDTH/2-WIDTH/4, Math.random()*HEIGHT/2-HEIGHT/4)
  view.title = country
  view.energy = energy
  view.population = population
  view.dx = 0
  view.dy = 0
  views.push view
  
this.draw = ->
  # iterations = 15
  # for i in [1..iterations]
  #   pack(views, 0.0003/i, [])
  
  # Scale visible items
  k_total = spaceToOccupy()
  for view in views
    kprima = k_total * TOTALENERGYSCALE * view.energy / views.length
    view.ka = kprima
    view.r = 2 * Math.sqrt( kprima / Math.PI )
    view[0].attr("r", view.r) # Circle
    view[1].attr("y", view[0].attr("cy") - view.r - 7) # Label
  
  pack(views, 0.0003)
  
  
  # for ( int i=burbujas_maximas; i>=0; i-- ) {
  #   if ( i < balls.length ) {
  #     if ( hay_gravedad ) balls[i].fall();
  #     if ( resorte_activado ) balls[i].spring();
  #     balls[i].bounce();
  #     balls[i].collide();
  #     balls[i].move();
  #     balls[i].encima();      
  #     balls[i].display();
  #   }
  # }
    
  for view in window.views
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
          view2.dx = Math.random()*2-1
          view2.dy = Math.random()*2-1
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
            
  for i in [0..window.views.length-1]
    view = window.views[i]
    # if circle1 not in exclude:
    # pull to center
    # vx = (view[0].attr("cx") - WIDTH/2) * damping
    # vy = (view[0].attr("cy") - HEIGHT/2) * damping
    # view.dx -= vx
    # view.dy -= vy
    # friction
    view.dx = view.dx * FRICTION
    view.dy = view.dy * FRICTION
    #bounce off edges
    r = view[0].attr("r")
    if view[0].attr("cx") - r <= 0
      view.dx = -view.dx
    if view[0].attr("cx") + r >= WIDTH
      view.dx = -view.dx
    if view[0].attr("cy") - r <= 15
      view.dy = -view.dy
    if view[0].attr("cy") + r >= HEIGHT
      view.dy = -view.dy
    
    
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








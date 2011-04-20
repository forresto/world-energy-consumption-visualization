this.WIDTH = 1280
this.HEIGHT = 500
this.PADDING = 2
this.FRICTION = .995

this.FRAMERATE = 60

this.TOTALENERGYSCALE = .015
this.PERCAPITASCALE = 400

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
  "Finland" 
  ]
  
this.views = []

this.anchor = paper.circle(WIDTH/2, HEIGHT/2, 10)

for country in defaultCountries
  ktoe = energyAndPopulationData[country].energy[40]
  
  # scaling according to area
  r = 2 * Math.sqrt( TOTALENERGYSCALE * ktoe / Math.PI )
  
  view = paper.set()
  view.push paper.circle(WIDTH/2, HEIGHT/2, r)
    .attr
      title: country
      fill: "#fff"
      stroke: "#000"
    .click ->
      this.attr("r", this.attr("r")+1)
  view.push paper.text(WIDTH/2, HEIGHT/2 - r - 7, country)
    .attr
      fill: "#f00"
      font: "bold 15px Fontin-Sans, Arial, sans-serif"
  view.translate(Math.random()*100, Math.random()*100)
  views.push view


this.draw = ->
  # iterations = 15
  # for i in [1..iterations]
  #   pack(views, 0.0003/i, [])
  
  pack(views, 0.0003, [])
    
  for view in window.views
    view.translate(view.dx, view.dy)
    
    
this.pack = (items, damping=0.1, exclude=[]) ->
  window.views.sort((a,b) -> a[0].offset() - b[0].offset())
  
  for i in [0..window.views.length-1]
    view1 = window.views[i]
    if i < window.views.length-1
      for j in [i+1..window.views.length-1]
        view2 = window.views[j]
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
            # if circle1 not in exclude:
            view1.dx = -vx
            view1.dy = -vy
            # if circle2 not in exclude:
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
    
    

animateInterval = setInterval("draw()", Math.round(1000/FRAMERATE))








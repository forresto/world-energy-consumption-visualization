width = 500
height = 500

Raphael.el.intersects = (other) ->
  d = this.distance(other)
  return (d < this.attr("r") + other.attr("r"))

Raphael.el.distance = (other) ->
  thisx = this.attr("cx")
  thisy = this.attr("cy")
  thatx = other.attr("cx")
  thaty = other.attr("cy")
  return Math.sqrt((thisx-thatx)*(thisx-thatx) + (thisy-thaty)*(thisy-thaty))

paper = Raphael("viz", width, height)

energyData = window.totalEnergyData

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

for item in energyData
  if defaultCountries.indexOf(item["Country Name"]) isnt -1
    view = paper.set()
    view.push paper.circle(width/2, height/2, Math.random()*100)
      .attr
        title: item["Country Name"]
        fill: "r(0.5, 0.5)#fff-#ccc"
        stroke: "#FF0000"
      .click ->
        console.log this.attr("title")
    view.push paper.text(width/2, height/2, item["Country Name"])
    views.push view



animateInterval = setInterval("draw()", 100)

this.draw = ->
  for view in views
    view.translate(Math.random()*4-2, Math.random()*4-2)

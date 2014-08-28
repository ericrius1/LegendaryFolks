THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'

class Fire
  constructor: (@scene, @audioController)->
    @flames = []


    for i in [0..@audioController.analyzer.array.length]
      flame = new THREE.Mesh(new THREE.BoxGeometry(5, 5, 5))
      flame.position.set _.random(-50, 50), 0, _.random(-50, 0)

      scene.add(flame)
      @flames.push(flame)

  update: (time)->
    for i in [0...@audioController.analyzer.array.length]
      scale = Math.max(.01, @audioController.analyzer.array[i] * .1)
      if(scale > 10)
        @flames[i].scale.y =  scale
      else 
        @flames[i].scale.y = 1



module.exports = Fire
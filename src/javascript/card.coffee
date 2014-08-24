THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'

class Card
  constructor: (@scene, @clock)->
    @canvas = document.createElement 'canvas'
    @canvas.height = 1000
    @canvas.width = 1000
    @ctx = @canvas.getContext '2d'
    @canvasTexture = new THREE.Texture(@canvas)
    @ctx.fillStyle = 'white'
    @ctx.fillRect(0, 0, @canvas.width, @canvas.height)
    @ctx.fillStyle = 'red'
    @firePos = new THREE.Vector2 550, 500
    @flameSize = 20
    @ctx.fillRect(@firePos.x, @firePos.y, @flameSize, @flameSize)
    size = 10
    geo = new THREE.PlaneGeometry(size, size, 2, 1)
    # mat = new THREE.MeshNormalMaterial
    #   side: THREE.DoubleSide
    #   wireframe: true
    mat = new THREE.MeshPhongMaterial
      map: @canvasTexture
    @cardMesh = new THREE.Mesh geo, mat
    geo.vertices[0] = geo.vertices[2].clone()
    geo.vertices[3] = geo.vertices[5].clone()
    @scene.add @cardMesh
    @radius = 5
    @fireRange = 20
    @perlin = new Perlin()

    @canvasTexture.needsUpdate = true
    @flicker()

  flicker : ()->
    @ctx.fillStyle = 'white'
    @ctx.fillRect 0, 0, @canvas.width, @canvas.height
    @ctx.fillStyle = 'red'
    time = @clock.getElapsedTime()
    @firePos.x += @perlin.simplex2(@firePos.x, time) * 10
    @firePos.y += @perlin.simplex2(@firePos.y, time) * 10
    @ctx.fillRect(@firePos.x, @firePos.y, @flameSize, @flameSize)
    @canvasTexture.needsUpdate = true

    setTimeout ()=>
      @flicker()
    , 400

  update: (time)->
    if(@cardMesh.geometry.vertices[0].z < 0)
      return
      
    else
      @cardMesh.geometry.vertices[0].x = @radius * Math.cos(time)
      @cardMesh.geometry.vertices[0].z = @radius * Math.sin(time)
      @cardMesh.geometry.vertices[3].x = @radius * Math.cos(time)
      @cardMesh.geometry.vertices[3].z = @radius * Math.sin(time)
      @cardMesh.geometry.verticesNeedUpdate = true
      @cardMesh.geometry.computeFaceNormals()
      @cardMesh.geometry.normalsNeedUpdate = true

module.exports = Card
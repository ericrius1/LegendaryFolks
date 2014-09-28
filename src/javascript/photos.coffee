THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'
rf = THREE.Math.randFloat;

class Photos
  constructor: (@scene)->
    @numPhotos = 23
    @photos = []
    @animating = false
    for i in [1..@numPhotos]
      image = document.createElement('img')
      image.src =  'images/photos/' + i + '.jpg'
      texture = new THREE.Texture(image);

      loadImage = (image, texture, i)=>
        image.addEventListener( 'load',  ( event )=> 
          texture.needsUpdate = true;
          mat = new THREE.MeshBasicMaterial
            map: texture
          photo = new THREE.Mesh(new THREE.PlaneGeometry(image.width, image.height), mat)
          photo.scale.multiplyScalar(0.01)
          photo.position.set _.random(-20, 20), (10 + (i * 7)), rf(0, 20)
          photo.velocity = rf(.03, 0.05);
          @scene.add photo
          @photos.push(photo)
        )
        
      loadImage(image, texture, i)


      
  beginAnimating: ->
    @animating = true

  update: (time)->
    if @animating
      _.each(@photos, (photo)->
        photo.position.y -= photo.velocity
      )





module.exports = Photos
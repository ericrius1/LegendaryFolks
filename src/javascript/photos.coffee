THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'

class Photos
  constructor: (@scene)->
    @numPhotos = 20
    @photos = []
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
          photo.position.set _.random(-100, 100), _.random(-100, 100), _.random(-100, 100)
          @scene.add photo
        )
        
      loadImage(image, texture, i)


      
    
  update: (time)->





module.exports = Photos
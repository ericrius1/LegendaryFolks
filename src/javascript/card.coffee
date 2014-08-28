THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'
TWEEN = require 'tween.js'

#Have the camera trained on a cheesy painting so its paused when the card opens, then pan away and focus on me and rel doing 
#something gooffy and singing happy birthday

class Card
  constructor: (@scene, @clock, @camera)->
    @cardOpenTime = 2000
    geo = new THREE.PlaneGeometry(17, 22)
    geo.merge(geo.clone(), new THREE.Matrix4().makeRotationY(Math.PI), 1)
    geo.applyMatrix(new THREE.Matrix4().makeTranslation(8.5, 0, 0))


           
    leftInnerImage = document.createElement('img')
    leftInnerImage.src = 'images/photos/1.jpg'
    leftInnerTexture = new THREE.Texture(leftInnerImage)
    leftInnerImage.addEventListener( 'load', ( event )-> 
      leftInnerTexture.needsUpdate = true
    )

    leftOuterImage = document.createElement('img')
    leftOuterImage.src = 'images/flowers.jpg'
    leftOuterTexture = new THREE.Texture(leftOuterImage);
    leftOuterImage.addEventListener( 'load',  ( event )-> 
      leftOuterTexture.needsUpdate = true;
    )


    @video = document.getElementById('video')
    @videoTexture = new THREE.Texture @video
    @videoTexture.minFilter = THREE.LinearFilter;
    @videoTexture.magFilter = THREE.LinearFilter;
    @videoTexture.format = THREE.RGBFormat;
    @videoTexture.generateMipmaps = false;

    rightOuterImage = document.createElement('img')
    rightOuterImage.src = 'images/outer-back.jpg'
    rightOuterTexture = new THREE.Texture(rightOuterImage);
    rightOuterImage.addEventListener( 'load',  ( event )-> 
      rightOuterTexture.needsUpdate = true;
    )
         
         
         
    leftTextures = [
      new THREE.MeshBasicMaterial({map: leftOuterTexture, side: THREE.FrontSide})
      new THREE.MeshBasicMaterial({map: leftInnerTexture, side: THREE.FrontSide}),
    ]
    rightTextures = [
      new THREE.MeshBasicMaterial({map: @videoTexture, side: THREE.FrontSide}),
      new THREE.MeshBasicMaterial({map: rightOuterTexture, side: THREE.FrontSide})
    ]
            
    @leftMat = new THREE.MeshFaceMaterial(leftTextures)


    @leftCard = new THREE.Mesh(geo, @leftMat)
    @leftCard.rotation.y = -Math.PI * .1
    # @leftCard.position.x -=10
    @scene.add @leftCard


    @rightMat = new THREE.MeshFaceMaterial(rightTextures)

    @rightCard = new THREE.Mesh(geo, @rightMat)
    @rightCard.rotation.y = -Math.PI * .1
    # @rightCard.position.x -=10
    @scene.add @rightCard

    csd = 
      rotY: @leftCard.rotation.y
    fsd = 
      rotY: -Math.PI * 0.8

    leftCardTween = new TWEEN.Tween(csd).
      to(fsd, @cardOpenTime).
      onUpdate(()=>
        @leftCard.rotation.y = csd.rotY
      ).start()
    leftCardTween.onComplete(()=>
      @video.play()
      @video.onended = =>
        console.log 'yar'
        csd = 
          posZ : @camera.position.z
        fsd = 
          posZ : @camera.position.z + 100
        camTween = new TWEEN.Tween(csd).
          to(fsd, 5000).
          onUpdate(()=>
            console.log fsd.posZ
            @camera.position.z = csd.posZ
          ).start()

      # csd = 
      #   rotY: @rightCard.rotation.y
      # fsd =
      #   rotY: -Math.PI
      # rightCardTween = new TWEEN.Tween(csd).
      #   to(fsd, 10000).
      #   onUpdate(()=>
      #     @rightCard.rotation.y = csd.rotY
      #   ).start()
    )



  update: (time)->
      
    @leftCard.geometry.verticesNeedUpdate = true
    @leftCard.geometry.computeFaceNormals()
    @leftCard.geometry.normalsNeedUpdate = true

    if @video.readyState is @video.HAVE_ENOUGH_DATA
      @videoTexture.needsUpdate = true


module.exports = Card
THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'
TWEEN = require 'tween.js'

#Have the camera trained on a cheesy painting so its paused when the card opens, then pan away and focus on me and rel doing 
#something gooffy and singing happy birthday

class Card
  constructor: (@scene, @clock, @camera)->
    @cardOpenTime = 2000
    @resolution = new THREE.Vector2(17,22)
    geo = new THREE.PlaneGeometry(@resolution.x, @resolution.y)

    geo.merge(geo.clone(), new THREE.Matrix4().makeRotationY(Math.PI), 1)

    #So we rotate from the edge
    geo.applyMatrix(new THREE.Matrix4().makeTranslation(@resolution.x/2, 0, 0))


           
    @leftInnerMaterial = new THREE.ShaderMaterial
      uniforms:
        time:
          type: 'f'
          value: 0.0
        resolution:
          type: 'v2'
          value: new THREE.Vector2(@resolution.x, @resolution.y)
      vertexShader: document.getElementById('vertexShader').textContent,
      fragmentShader: document.getElementById('fragmentShader').textContent


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
      new THREE.MeshBasicMaterial({map: leftOuterTexture, side: THREE.FrontSide}),
      @leftInnerMaterial,
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
        csd = 
          posZ : @camera.position.z
        fsd = 
          posZ : @camera.position.z + 100
        

        # camTween = new TWEEN.Tween(csd).
        #   to(fsd, 5000).
        #   onUpdate(()=>
        #     console.log fsd.posZ
        #     @camera.position.z = csd.posZ
        #   ).start()

        csd = 
          rotY: @rightCard.rotation.y
        fsd =
          rotY: @leftCard.rotation.y + .1
        rightCardTween = new TWEEN.Tween(csd).
          to(fsd, 2000).
          onUpdate(()=>
            @rightCard.rotation.y = csd.rotY
          ).start()
        rightCardTween.onComplete(()=>
          @explodeCard()
        )
    )

  explodeCard: ->
    console.log 'yar'

  update: (time)->
      
    @leftCard.geometry.verticesNeedUpdate = true
    @leftCard.geometry.computeFaceNormals()
    @leftCard.geometry.normalsNeedUpdate = true
    @leftInnerMaterial.uniforms.time.value = time

    if @video.readyState is @video.HAVE_ENOUGH_DATA
      @videoTexture.needsUpdate = true


module.exports = Card
THREE = require 'three'
_ = require 'underscore'
Perlin = require 'Perlin'
TWEEN = require 'tween.js'
require 'TessellateModifier'
require 'ExplodeModifier'



#Have the camera trained on a cheesy painting so its paused when the card opens, then pan away and focus on me and rel doing 
#something gooffy and singing happy birthday

class Card
  constructor: (@scene, @clock, @camera, @photos, @stream)->
    @explodingInProgress = false
    @cardOpenTime = 5000
    @rf = THREE.Math.randFloat
    @resolution = new THREE.Vector2(17,22)
    geo = new THREE.PlaneGeometry(@resolution.x, @resolution.y)
    @accelRange = 0.01

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
    leftOuterImage.src = 'images/momdad.jpg'
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
    rightOuterImage.src = 'images/back.jpg'
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
    @scene.add @leftCard


    @rightMat = new THREE.MeshFaceMaterial(rightTextures)

    @rightCard = new THREE.Mesh(geo, @rightMat)
    @rightCard.rotation.y = -Math.PI * .1
    @scene.add @rightCard

    @tesselateCard()

    csd = 
      rotY: @leftCard.rotation.y
    fsd = 
      rotY: -Math.PI * 0.8

    leftCardTween = new TWEEN.Tween(csd).
      to(fsd, @cardOpenTime).
      onUpdate(()=>
        @leftCard.rotation.y = csd.rotY
      ).
      delay(5000).start()
    leftCardTween.onComplete(()=>
      @video.play()
      @video.onended = =>
        @stream.play()
        csd = 
          posZ : @camera.position.z
        fsd = 
          posZ : @camera.position.z + 100
        


        csd = 
          rotY: @rightCard.rotation.y
        fsd =
          rotY: @leftCard.rotation.y + .1
        rightCardTween = new TWEEN.Tween(csd).
          to(fsd, @cardOpenTime).
          onUpdate(()=>
            @rightCard.rotation.y = csd.rotY
          ).start()
        rightCardTween.onComplete(()=>
          @photos.beginAnimating()
          setTimeout =>
            @explodingInProgress = true
          , 2000
        )
    )

  tesselateCard: ->
    tesselateModifier = new THREE.TessellateModifier(2)
    explodeModifier = new THREE.ExplodeModifier()

    @leftCard.geometry.dynamic = true
    tesselateModifier.modify(@leftCard.geometry)
    explodeModifier.modify(@leftCard.geometry)

    @rightCard.geometry.dynamic = true
    tesselateModifier.modify(@rightCard.geometry)
    explodeModifier.modify(@rightCard.geometry)
    
    v = 0
    for f in [0...@rightCard.geometry.faces.length]
      velocity = new THREE.Vector3 0, 0, 0
      acceleration = new THREE.Vector3 @rf(-@accelRange, @accelRange), @rf(-@accelRange, @accelRange), @rf(-@accelRange, @accelRange)
      for i in [0...3]
        @rightCard.geometry.vertices[v].velocity = velocity
        @rightCard.geometry.vertices[v].acceleration = acceleration
        v+=1

  explodeCard: ->
    for i in [0...@rightCard.geometry.vertices.length]
      vertex = @rightCard.geometry.vertices[i]
      vertex.add vertex.velocity
      vertex.velocity.add vertex.acceleration

  update: (time)->
    if @explodingInProgress
      @explodeCard()
    @leftCard.geometry.verticesNeedUpdate = true
    @leftCard.geometry.computeFaceNormals()
    @leftCard.geometry.normalsNeedUpdate = true
    @leftInnerMaterial.uniforms.time.value = time

    if @video.readyState is @video.HAVE_ENOUGH_DATA
      @videoTexture.needsUpdate = true
    


module.exports = Card
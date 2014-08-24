THREE = require 'three'
controls = require 'OrbitControls'
Card = require './card'
AudioController = require './vendor/AudioController'
AudioTexture= require './vendor/AudioTexture'
Stream = require './vendor/Stream'


time = null
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
clock = new THREE.Clock()
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(50, WIDTH/HEIGHT, 1, 2000)
camera.position.z = 30
renderer = new THREE.WebGLRenderer()
renderer.setSize WIDTH, HEIGHT
document.body.appendChild renderer.domElement
controls = new THREE.OrbitControls(camera)

#color, intensity, distance
light = new THREE.PointLight(new THREE.Color(0xffffff), 1, 100)
light.position.z = 30
scene.add light

card = new Card(scene, clock)

debugger
audioController = new AudioController()
stream = new Stream('/audio/fire.mp3', audioController)

stream.play()


animate = ()->
  requestAnimationFrame(animate)
  renderer.render scene, camera
  controls.update()
  time = clock.getElapsedTime()
  card.update(time)


animate()
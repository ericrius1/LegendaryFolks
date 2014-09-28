THREE = require 'three'
require 'OrbitControls'
Card = require './card'
Photos = require './photos'
AudioController = require './vendor/AudioController'
AudioTexture= require './vendor/AudioTexture'
Stream = require './vendor/Stream'
TWEEN = require 'tween.js'
# Fire = require './fire'


time = null
WIDTH = window.innerWidth
HEIGHT = window.innerHeight
clock = new THREE.Clock()
scene = new THREE.Scene()
camera = new THREE.PerspectiveCamera(50, WIDTH/HEIGHT, 0.001, 20000)
camera.position.z = 30
renderer = new THREE.WebGLRenderer({antialias: true})
renderer.setSize WIDTH, HEIGHT
document.body.appendChild renderer.domElement
controls = new THREE.OrbitControls(camera)

#color, intensity, distance
# pointLight  = new THREE.PointLight(new THREE.Color(0xffffff), 2.0)
# pointLight.position.set -20, 0, 30
# scene.add pointLight

audioController = new AudioController()
stream = new Stream('videos/fragments.mp3', audioController)


photos = new Photos(scene)
card = new Card(scene, clock, camera, photos, stream)

# fire = new Fire(scene, audioController)






animate = ()->
  requestAnimationFrame(animate)
  renderer.render scene, camera
  audioController.update()
  controls.update()
  photos.update()
  time = clock.getElapsedTime()
  card.update(time)
  TWEEN.update()
  # fire.update()



window.onload = ()->
  window.addEventListener('resize', onWindowResize, false)

onWindowResize = ()-> 
  renderer.setSize(window.innerWidth, window.innerHeight);
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();

animate()
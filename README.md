# Fourier and Music
WWDC 2020 Swift Student Challenge winning Playground about the Fourier Series and its uses in music

## Goal
The main goal of this Swift Playground is to teach the concept of Fourier Series, while also demonstrating some of its practical applications in music such as sound analysis and additive synthesis.

There are 3 pages with bite-sized, simple explanations about the Fourier Series and some of its key concepts, and in each page there's a live view that demonstrates what has been learned with some audio examples, consisting of a bank of 8 sine oscillators and their respective waveform views.

Finally, the last page comes loaded with a couple of predefined "instrument approximations" using this oscillator bank, and also lets you individually manipulate each of the oscillators' volume levels, allowing you to mutate these approximations and come up with novel sounds. In case things get out of hand, there are Stop and Reset buttons to rescue you and your ears 😉

<p align="center"><img src="https://i.ibb.co/pW03FRB/Captura-de-Tela-2020-06-16-a-s-19-59-26.png" alt="Playground Screenshot" width=800 border="0"></p>

## Technical tidbits
This playground was created entirely with SwiftUI, including a couple of custom homemade components such as the Waveform views.
SwiftUI runs satisfyingly well inside the Playgrounds environment, even though it needs a couple of adjustments before being ready to go. Breaking your custom components into separate structs work as expected, but you need to be careful when moving them into their own source files, since Playgrounds require you to explicitly mark all methods and properties as "public" to make them available to your playground pages.

Since this playground uses Additive Synthesis to demonstrate its concepts, I had to find a way to make sound generation possible. 
The Playground environment is too restricted to allow for proper, real-time sound synthesis, so I decided to use some clever sample trickery instead: I've generated perfectly loopable and lossless audio files for each sine oscillator, and I've made a simple 8-channel mixer using AVFoundation that blends them together as needed. 
This has worked well enough for the purposes of this playground, while also being simple enough to guarantee satisfying performance in both Xcode and Swift Playgrounds.

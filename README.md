`stepmania-musecaeditor`
========================

## About This Fork

This fork adds a new `museca-single` game mode, to be used in conjunction with [a fork of DragonMinded's `sm2museca` conversion script](https://github.com/theKeithD/sm2museca). This mode defines a 16-lane single player mode, rather than a 16-lane double play mode like the ones offered by `bm` and `techno`.

The game mode is designed mostly for use in Edit Mode. If for some reason you feel like actually trying to play this mode normally, good luck and have fun.

The included `museca` noteskin is based on the `retrobar-splithand_whiteblue` noteskin included in StepMania 5.0. Tap notes in the spin lanes are visually shifted to appear in the main tap note lanes.

As an added bonus, the maximum number of columns addressible in the editor has been extended from 10 to 16! Numpad keys 1-6 cover the overflow.

## Lane Layout, Charting, and Design Notes

There is 1 pedal lane, and then 3 channels of 5 lanes each.

    CH0 @ sm_lane[0]:      pedal (this could also move to the very end, but it feels more at home next to CH1)
    CH1 @ sm_lane[1..5]:   taps and holds
    CH2 @ sm_lane[6..10]:  left spins
    CH3 @ sm_lane[11..15]: right spins


### Mapping Examples
- **Tap** in CH1, `sm[1]`
    - **Tap** in `msc[1]`
- **Hold** in CH1, `sm[1]` 
    - **Hold** in `msc[1]`
- **Tap** in CH2, `sm[6]` 
    - **Left spin** in `msc[1]`
- **Tap** in CH3, `sm[11]` 
    - **Right spin** in `msc[1]`
- **Tap** in CH2 and CH3, `sm[6] and sm[11]` 
    - **Non-directional spin** in `msc[1]`
- **Hold *start*** in CH2 or CH3, `sm[6] or sm[11]` 
    - **Start storm object event** in `msc[1]`
- **Mine** in CH1 or CH2 or CH3, `sm[1] or sm[6] or sm[11]` 
    - **End storm object event** in `msc[1]`

### Why 3 Channels?
- Hold ends in StepMania don't have multiple end types, so we can't overlap a spinner of any kind onto a hold release
- More taps means more claps
    - An original 6-lane draft made use of all 4 note types: Tap, Mine (left spin), Fake (right spin), Lift (non-dir spin)
    - But there were still hold ends and storm objects to worry about, thus...

### Storm Objects: Why Hold Start, Why Mines?
- Storm objects are "like" holds in that they have a start and end...
    - ...but they do not claim exclusive control of the lane in Museca
    - While a storm object is out, that lane could have taps and spins going on
- To still retain the assist tick sound while distinguishing these from normal spins, we make a hold, rather than a lift/fake
    - The timing of the hold end does not matter, the converter should ignore hold end events in CH2 or CH3
- The mine will indicate the storm is over, but it can go in any 5-lane channel, even CH1
    - This way, a storm object can end at the same time a spin of any kind occurs in that lane (mine goes in CH1, taps go in CH2+CH3)
- There's still one imperfect situation...

### Case(s) Not Covered
- Storm end event in `msc[1]` at the same time as a non-directional spin acting as the "tail" of a hold in `msc[1]` (or acting as "head", but that's evil)
    - Where does the mine go? CH1 is occupied by a hold, CH2 and CH3 are occupied by taps that will become a non-directional spin
    - Either shift something (preferably the mine/stormend) by 1/192nd...
    - ...or maybe add a Label called "`STORM_END_LANE_n`" at this point, which will tell the converter to create a storm end event


StepMania
=========

StepMania is an advanced cross-platform rhythm game for home and arcade use.

Advanced cross-platform rhythm game for home and arcade use.

[![Build Status](https://travis-ci.org/stepmania/stepmania.svg?branch=master)](https://travis-ci.org/stepmania/stepmania)
[![Build status](https://ci.appveyor.com/api/projects/status/e932dk2o3anki27p?svg=true)](https://ci.appveyor.com/project/wolfman2000/stepmania-wm87c)

## Installation
### From Packages

For those that do not wish to compile the game on their own and use a binary right away, be aware of the following issues:

* Windows users are expected to have installed the [Microsoft Visual C++ x86 Redistributable for Visual Studio 2015](http://www.microsoft.com/en-us/download/details.aspx?id=48145) prior to running the game. For those on a 64-bit operating system, grab the x64 redistributable as well. [DirectX End-User Runtimes (June 2010)](http://www.microsoft.com/en-us/download/details.aspx?id=8109) is also required. Windows 7 is the minimum supported version.
* Mac OS X users need to have Mac OS X 10.6.8 or higher to run StepMania.
* Linux users should receive all they need from the package manager of their choice.

### From Source

StepMania can be compiled using [CMake](http://www.cmake.org/). More information about using CMake can be found in both the `Build` directory and CMake's documentation.

###Submodules###

This repository now uses submodules to attempt to keep the repository size down. Utilize `git submodule init` and `git submodule update` to get the necessary submodules.

## Resources

* Website: http://www.stepmania.com/
* IRC: #stepmania-devs on Freenode (chat.freenode.net), or [webchat client](http://webchat.freenode.net/?channels=%23stepmania-devs&uio=d4)
* Lua for SM5: https://dguzek.github.io/Lua-For-SM5/
* Lua API Documentation can be found in the Docs folder.

## Licensing Terms

In short- you can do anything you like with the game (including sell products made with it), provided you *do not*:

1. Sell the game *with the included songs*
2. Claim to have created the engine yourself or remove the credits
3. Not provide source code for any build which differs from any official release which includes MP3 support.

(It's not required, but we would also appreciate it if you link back to http://www.stepmania.com/)

For specific information/legalese:

* All of the our source code is under the [MIT license](http://opensource.org/licenses/MIT).
* Any songs that are included within this repository are under the [<abbr title="Creative Commons Non-Commercial">CC-NC</abbr> license](https://creativecommons.org/).
* The [MAD library](http://www.underbit.com/products/mad/) and [FFmpeg codecs](https://www.ffmpeg.org/) when built with our code use the [GPL license](http://www.gnu.org).

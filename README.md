# DateMachine & SexMachine

A CLEO mod for GTA San Andreas to recreate a +18 hot Date Sim.

## Requirements

- Copy of GTA: San Andreas v1.0 Hoodlum
- CLEO 4: https://cleo.li/
- Modloader: https://www.gtagarage.com/mods/show.php?id=25377

## Description

_DateMachine_ and _SexMachine_ is a script that will add an activity in GTA: San Andreas to recreate in it a +18 hot Date Sim. This activity will be divided in two parts: a date simulator and a sex simulator. This has the goal to be something like the known [Hot Coffee](https://gta.fandom.com/wiki/Hot_Coffee_Modification) removed feature, but expanded, with more stuff to do and more customizable.

This mod is barely on a developement stage and there is still a lot of stuff missing.

## Installing

Once you have all the requirements, download the release and extract the files on the _GTA San Andreas_ folder. Alternatively, you can download the model files to play with SexMachine, replacing dinamically the male/female models. Just follow the _README.md_ instructions in `/modloader/.ignored` folder about how to use it.

- Release: https://github.com/mumifaglalolanda/DateMachine-SexMachine/releases/download/v1.0.0/DateMachine.SexMachine.zip
- Models: https://github.com/mumifaglalolanda/DateMachine-SexMachine/releases/download/models-1.0.0/models.zip

## Progress

DateMachine: 0%

SexMachine: (A lot but still missing)%

## To do

Next
- Separate the Keys Control part in Actors Offsets menu.
- Change 'IncDecActorsOffset' name to 'MoveActors' or something...
- Cheat to make all peds dissapear/reappear.

Long-Term
- Make GenSexFiles to read the source directory of the files from a .dat or .ini file.
- Make a very simple functionality in SexTriggerer that change player to male skin and spawns the female character that will follow him everywhere, then initiate the SexMachine when they get close enough.
- Compatibility with classic mode.

Bugs
- Don't call GenSexFiles on the initialization routine, but instead when plater press TAB to choose pose at first!
- Climax stops from rising at some point, maybe after cameras menu.

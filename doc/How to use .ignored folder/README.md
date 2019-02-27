# How to use this folder

The `/. ignored` folder will be ignored by the SA's modloader.
Its use is to provide a quick replacement of models for the male/female characters in SexMachine.
The `/. ignored` folder will act together with the `/Models` folder in order to replace the male/female characters.

#### In order to use it:

__Manually:__ copy the desired dff/txd pair in `/modloader/Models` and rename it as _male.dff_/_male.txd_ or _female.dff_/_female.txd_.

__Advanced:__
Copy all your desired dff/txd files in `/modloader/. ignored/models`.
Notice that in `/modloader/. ignored` there are two bat files named `copy female file.bat` and `copy male file.bat`.
Just create a duplicate of `/modloader/. ignored/copy female file.bat` and rename it the same as your dff/txd female model. The same for male, but in this case add a + character at the end of the bat filename.

For example, if you have `/modloader/. ignored/models/bdoll.dff` & `/modloader/. ignored/models/bdoll.txd`, you will rename your bat file as `/. ignored/bdoll.bat`, and each time you want to replace your female model, you simply double-click in your `/. ignored/bdoll.bat`.

Example for male character: for "char.dff"/"char.txd", the .bat file rename will result as "char+.bat". This is so you can replace the male or female with the same model and you can have the two bat files in the same folder.

#### Note:

In case isn't working, make sure you have in `modloader.ini` file the next line:
```
Date&Sex=49
Models=51
```

After this:
```
[Profiles.Default.Priority]
; Defines mods priority (which mods should go into effect if both replaces the same file)
; The priority should be between 1 and 100, where 100 overrides 1, additionally priority 0 makes be ignored (just like IgnoreMods)
; The default priority is 50!
;MyMod=50
```

In order to force the modloader to make `Models` overwrite the files in `Date&Sex`. The release package should already contain the `modloader.ini` with this modification.
# How to use this folder

The `/. ignored` folder will be ignored by the SA's modloader.
Its use is to provide a quick replacement of models for the male/female characters in SexMachine.
The `/. ignored` folder will act together with the `/Models` folder in order to replace the male/female characters.

#### In order to use it:

Copy all your desired dff/txd files in `/. ignored/models`.
Then create a duplicate of `/. ignored/copy female file.bat` and rename it the same as your dff/txd female model.

For example, if you have `/models/bdoll.dff` & `/models/bdoll.txd`, you will rename your bat file as `/. ignored/bdoll.bat`, and each time you want to replace your female model, you simply double-click in your `/. ignored/bdoll.bat`.

If you want your dff/txd model to replace the male character, then rename the .bat as "name of the model" followed by "+".
Example: for "char.dff"/"char.txd", the .bat file rename will result as "char+.bat".

#### Note:

Don't forget to add in `modloader.ini` file the next line:
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

In order to force the modloader to make `Models` overwrite the files in `Date&Sex`.
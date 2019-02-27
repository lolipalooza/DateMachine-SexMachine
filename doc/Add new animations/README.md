# Adding a New Pose in SCM files

__Warning:__ This is outdated, wait for new readme file!

#### File `CmSexMachine/ActorsAndPoses.txt`

Register the speed options of the pose in `:SexPoses` hex block, replacing empty line by actual line:

```
"______" 0 "______" 0 "______" 0 "______" 0 // Foot
```

```
"idle__" 1 "slow__" 1 "normal" 3 "fast__" 1 // Foot
```

#### File `CmSexMachine/CamerasAndCoordinates.txt`

1. Register new _First Person Camera_ coordinates in method `:GetFirstPersonCamCoordinates`:

```
if 1@ == PL_FOOT
then 0AB2: ret 12 cam_pos 2372.681152 -1125.007690 1051.875366 cam_target 2372.661377 -1125.376953 1050.917725 rotation -2.0 angle 180.0 min_rotation -2.5 max_rotation -1.76 min_angle 150.0 max_angle 210.0
end
```

2. Register Coordinates for _Center of Rotating Camera_ in method `:GetCenterCoordinates`:

```
if 1@ == PL_FOOT
then 0AB2: ret 3 2372.6848 -1125.203 1050.875
end
```

3. Register _Fixed Camera Coordinates_ (They are 12 in total) in method `:GetCameraCoordinates`:

```
if 2@ == PL_FOOT
then
	if 0@ == 0
	then 0AB2: ret 6 cam_pos 2371.675293 -1127.482544 1051.575439 cam_target 2372.015381 -1126.580444 1051.310059 // Camera 1
	end
	
	// ...
	
	if 0@ == 11
	then 0AB2: ret 6 cam_pos 2372.656250 -1125.243042 1052.075317 cam_target 2372.656250 -1125.261719 1051.075439 // Camera 15
	end
end
```

4. For last, register _Male and Female coordinates_, replacing zero values by actual values in method `:GetActorsCoordinates`:

```
if 1@ == PL_FOOT
then 0AB2: ret 8 fem_xyz 0.0 0.0 0.0 angle 0.0 male_xyz 0.0 0.0 0.0 angle 0.0
end
```

```
if 1@ == PL_FOOT
then 0AB2: ret 8 fem_xyz 2372.697998 -1125.624634 1049.845337 angle 180.0 male_xyz 2372.679688 -1124.909058 1049.935303 angle 180.0
end
```

#### File `CmSexMachine/GenerateSexFiles.txt`

Register paths to ifp files where poses are:

```
if 1@ == PL_FOOT
then
	0B04: copy_file "path\to\ifp\file\idle1.ifp" to DEST_IDLE1 //IF and SET
	0B04: copy_file "path\to\ifp\file\slow1.ifp" to DEST_SLOW1 //IF and SET
	0B04: copy_file "path\to\ifp\file\normal1.ifp" to DEST_NORMAL1 //IF and SET
	0B04: copy_file "path\to\ifp\file\fast1.ifp" to DEST_FAST1 //IF and SET
end
```

#### File `CmSexMachine/SexualMenuAndStats.txt`

In hex block `:SexMenuOptions_` + interior name where pose will be available, register GXT entries for pose:

```
"______" "______" "______" "______" "______" <--- choose slot and enter GXT name, example: "S_BJ_1"
```

`S_BJ_1` must be defined in a GXT or FXT file.
GXT name must be always 6 characters long!

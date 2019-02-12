# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node2D

# This script should be attached to the root node of each level to define exported variables

# The time limit in seconds
#warning-ignore:unused_class_variable
export(int, 1, 1000) var time_limit := 180

# The music volume offset in decibels
#warning-ignore:unused_class_variable
export(float, -50.0, 0.0) var music_volume_db := 0.0

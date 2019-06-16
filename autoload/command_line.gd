# Copyright © 2018-2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends Node

var arguments = {}


func _ready():
	for argument in OS.get_cmdline_args():
		# Parse valid command-line arguments of the form `--key=value` into a dictionary
		if argument.find("=") > -1:
			var key_value = argument.split("=")
			arguments[key_value[0].lstrip("--")] = key_value[1]

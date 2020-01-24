#!/usr/bin/env bats

@test "testing if pi is installed" {
	run pi
	[ "$status" -eq 1 ]
}

@test "parsing version string" {
	run pi version
	[ "$status" -eq 0 ]
	[[ "$output" =~ ^pi.* ]]
}


#@test "parsing list github repositories" {
#	run pi listgh
#	[ "${lines[0]}" = "pi - Pharo Install [version 0.4.1 - 12/02/2019]" ]
#}

@test "parsing command line examples" {
	run pi examples
	examples=$(<EXAMPLES)
	[ "$output" = "
$examples" ]
}

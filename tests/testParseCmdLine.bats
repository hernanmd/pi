#!/usr/bin/env bats

@test "parsing version string" {
	run pi version
	[ "$status" -eq 0 ]
	[ "$output" = "pi - Pharo Install [version 0.3.9 - 08/02/2019]" ]
}


@test "parsing command line" {
	run pi
	[ "${lines[0]}" = "pi - Pharo Install [version 0.3.9 - 08/02/2019]" ]
}

@test "parsing command line examples" {
	run pi examples
	[ "$output" = "
List GitHub packages:
pi listgh

List SmalltalkHub packages:
pi listsh

Search Both SmalltalkHub and GitHub packages:
pi search pillar

Download latest stable Pharo image and VM:
pi image

Install multiple packages:
pi install Diacritics ISO3166 StringExtensions" ]
}

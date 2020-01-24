#!/usr/bin/env bats

@test "testing clean cache command" {
	run pi clean
	[[ "$output" =~ "^Cache is empty" ]]
}

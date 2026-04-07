package types

import "core:fmt"
import "core:mem"


main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	track.bad_free_callback = mem.tracking_allocator_bad_free_callback_add_to_array
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)

	// main program

	// check for memory leaks
	for _, leak in track.allocation_map {
		fmt.printfln("\non line %d, leaked %m", leak.location.line, leak.size)
	}

	// check for bad frees
	for entry in track.bad_free_array {
		fmt.printfln("\nbad free at line %d", entry.location.line)
	}
}

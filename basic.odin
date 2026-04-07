package basic

import "core:fmt"
import "core:mem"

test_variables :: proc() {
	number_def: int // initialied to 0 by default
	number_empty: int = --- // uninitialied

	fmt.printfln("number_def: %d", number_def)
	fmt.printfln("number_empty: %d", number_empty)

	number_def = 7
	fmt.printfln("number_def: %d", number_def)

	/*
	Multi line
	Comment
	*/
	number := 8
	fmt.printfln("number: %d", number)
}

test_constants :: proc() {
	CONSTANT_NUMBER :: 12
	fmt.printfln("CONSTANT_NUMBER: %d", CONSTANT_NUMBER)

	// explicit type
	CONSTANT_DECIMAL: f32 : 7.42
	fmt.printfln("CONSTANT_DECIMAL: %f", CONSTANT_DECIMAL)
}

is_bigger_than :: proc(number: int, compare_to: int) -> bool {
	return number > compare_to
}

test_for_loop :: proc() {
	fmt.println("for range: ..<")
	for i in 0 ..< 3 {
		fmt.println(i)
	}

	fmt.println("for range: ..=")
	for i in 0 ..= 3 {
		fmt.println(i)
	}

	fmt.println("labeled for loop")
	fmt.println("break")
	outer1: for x in 0 ..< 3 {
		for y in 0 ..< 3 {
			if x == 2 && y == 2 {
				break outer1
			}
			fmt.printfln("x, y: %d, %d", x, y)
		}
	}

	fmt.println("continue")
	outer2: for x in 0 ..< 3 {
		for y in 0 ..< 3 {
			if x == 1 && y == 2 {
				continue outer2
			}
			fmt.printfln("x, y: %d, %d", x, y)
		}
	}
}

test_arrays :: proc() {
	ten_ints: [10]int
	fmt.printfln("ten_ints: %+v", ten_ints)

	five_ints := [5]int{1, 3, 0, -0, -5}
	fmt.printfln("five_ints: %+v", five_ints)

	fmt.println("Loop through array using index")
	for i in 0 ..< len(five_ints) {
		fmt.printfln("five_ints[%d]: %d", i, five_ints[i])
	}

	fmt.println("Loop through array using element")
	for i in five_ints {
		fmt.printfln("five_ints[i]: %d", i)
	}

	fmt.println("Loop through array using element: reversed")
	#reverse for i in five_ints {
		fmt.printfln("five_ints[i]: %d", i)
	}
}

main :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	track.bad_free_callback = mem.tracking_allocator_bad_free_callback_add_to_array
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)

	// main program
	test_variables()
	test_constants()
	fmt.printfln("is %d bigger than %d?: %v", 3, 5, is_bigger_than(3, 5))
	test_for_loop()
	test_arrays()

	// check for memory leaks
	for _, leak in track.allocation_map {
		fmt.printfln("\non line %d, leaked %m", leak.location.line, leak.size)
	}

	// check for bad frees
	for entry in track.bad_free_array {
		fmt.printfln("\nbad free at line %d", entry.location.line)
	}
}

track_mem :: proc() {
	track: mem.Tracking_Allocator
	mem.tracking_allocator_init(&track, context.allocator)
	track.bad_free_callback = mem.tracking_allocator_bad_free_callback_add_to_array
	defer mem.tracking_allocator_destroy(&track)
	context.allocator = mem.tracking_allocator(&track)

	// test_variables() // main program

	// check for memory leaks
	for _, leak in track.allocation_map {
		fmt.printfln("\non line %d, leaked %m", leak.location.line, leak.size)
	}

	// check for bad frees
	for entry in track.bad_free_array {
		fmt.printfln("\nbad free at line %d", entry.location.line)
	}
}

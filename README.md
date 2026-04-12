# Learning Odin

## Memory Management

- Odin gives you explicit control over memory.
    - No garbage collection.
    - No hidden allocations.
    - You decide when memory is allocated and freed.
- Stack
    - Fast
    - Automatic
    - Limited lifetime
- Heap
    - Manual
    - You choose the lifetime
- `new` and `free`
    - `new` allocates a single value on the heap and returns a pointer.
- `make` and `delete`
    - `make` is for slices and dynamic arrays.
- `defer` runs a statement when the current scope exits. Normally used to pair
    allocations with frees. Idomatic odin: always cleanup right after allocating.
- Built-in allocators:
    - `heap_allocator`: general purpose, default.
    - `arena_allocator`: many short-lived allocs, free all at once.
    - `temp_allocator`: scratch allocator meant to be reset periodically.
    - `tracking_allocator`: debugging; detects leaks and double-frees.
- Every `proc` has an implicit `context` parameter carrying the current allocator.
    This makes it possible to swap allocators for a whole call subtree. You can
    isolate allocations per request, per frame, per thread, without changing any
    code.
- Slices don't own memory: deleting a sub-slice is wrong, only delete the original.
- Stack memory doesn't outlive its scope: don't return pointers or slices pointing
    into a stack frame.
- Swap allocators via context: don't thread allocator pointers manually through
    every function.

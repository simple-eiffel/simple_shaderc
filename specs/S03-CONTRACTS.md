# S03: CONTRACTS
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Design by Contract Summary

### SIMPLE_SHADERC Contracts

```eiffel
compile_glsl (a_source: STRING; a_kind: INTEGER): detachable MANAGED_POINTER
    require
        source_not_empty: not a_source.is_empty
    ensure
        error_on_void: Result = Void implies has_error

save_spirv (a_spirv: MANAGED_POINTER; a_path: STRING)
    require
        spirv_valid: a_spirv.count > 0
        path_not_empty: not a_path.is_empty

verify_spirv_magic (a_spirv: MANAGED_POINTER): BOOLEAN
    require
        sufficient_size: a_spirv.count >= 4
```

### SHADERC_COMPILER Contracts

```eiffel
make
    ensure
        validity_check: is_valid = (handle /= default_pointer)

compile (a_source: STRING; a_kind: INTEGER; a_filename: STRING; a_entry_point: STRING): SHADERC_RESULT
    require
        valid_compiler: is_valid
        source_not_empty: not a_source.is_empty
        filename_not_empty: not a_filename.is_empty
        entry_not_empty: not a_entry_point.is_empty

dispose
    ensure
        disposed: handle = default_pointer
        not_valid: not is_valid
```

### SHADERC_RESULT Contracts

```eiffel
make_from_handle (a_handle: POINTER)
    require
        valid_handle: a_handle /= default_pointer
    ensure
        handle_set: handle = a_handle

dispose
    ensure
        disposed: is_disposed
```

## Class Invariants

### SIMPLE_SHADERC
- `last_error` is never Void (may be empty)

### SHADERC_RESULT
- `error_message` is never Void (may be empty)

# S06: BOUNDARIES
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## System Boundaries

```
┌─────────────────────────────────────────────────────┐
│                   simple_shaderc                     │
│  ┌─────────────────────────────────────────────┐   │
│  │              SIMPLE_SHADERC                  │   │
│  │  (user-facing facade, error handling)       │   │
│  └─────────────────────────────────────────────┘   │
│                      │                              │
│                      ▼                              │
│  ┌─────────────────────────────────────────────┐   │
│  │            SHADERC_COMPILER                  │   │
│  │     (native handle, C external calls)       │   │
│  └─────────────────────────────────────────────┘   │
│                      │                              │
│                      ▼                              │
│  ┌─────────────────────────────────────────────┐   │
│  │             SHADERC_RESULT                   │   │
│  │    (SPIR-V bytes, error messages)           │   │
│  └─────────────────────────────────────────────┘   │
│                      │                              │
└──────────────────────│──────────────────────────────┘
                       │
                       ▼
              ┌────────────────┐
              │    shaderc     │
              │ (native lib)   │
              │ shaderc.h API  │
              └────────────────┘
                       │
                       ▼
              ┌────────────────┐
              │   SPIR-V       │
              │   Tools        │
              └────────────────┘
```

## Interface Boundaries

### Eiffel Interface
- **Input**: GLSL source as STRING
- **Output**: SPIR-V as MANAGED_POINTER
- **Errors**: STRING messages, BOOLEAN status

### Native Interface
- **Compiler**: shaderc_compiler_t handle
- **Result**: shaderc_compilation_result_t handle
- **Functions**: 8 C inline externals

### C External Calls

```eiffel
-- Compiler
c_compiler_initialize: POINTER
c_compiler_release (a_compiler: POINTER)
c_compile_into_spv (...): POINTER

-- Result
c_result_get_compilation_status (a_result: POINTER): INTEGER
c_result_get_length (a_result: POINTER): INTEGER_64
c_result_get_bytes (a_result: POINTER): POINTER
c_result_get_error_message (a_result: POINTER): POINTER
c_result_get_num_warnings (a_result: POINTER): INTEGER
c_result_get_num_errors (a_result: POINTER): INTEGER
c_result_release (a_result: POINTER)
```

# S02: CLASS CATALOG
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Class Hierarchy

```
ANY
├── SIMPLE_SHADERC (high-level facade)
├── SHADERC_COMPILER (native compiler wrapper)
└── SHADERC_RESULT (compilation result)
```

## Class Descriptions

### SIMPLE_SHADERC
**Purpose**: User-friendly shader compilation facade
**Responsibilities**:
- Lazily initialize compiler
- Provide typed compile methods (vertex, fragment, compute)
- Manage error state
- Utility functions (save, verify magic)

**Key Features**:
- `compile_glsl`: Generic compilation with shader kind
- `compile_vertex/fragment/compute`: Typed shortcuts
- `save_spirv`: Write bytes to file
- `verify_spirv_magic`: Validate SPIR-V format

### SHADERC_COMPILER
**Purpose**: Direct wrapper for shaderc_compiler_t
**Responsibilities**:
- Initialize native compiler handle
- Execute compilation
- Release resources on dispose

**Key Features**:
- `compile`: Full compilation with all parameters
- `compile_compute/vertex/fragment`: Convenience wrappers
- `dispose`: Release native handle

### SHADERC_RESULT
**Purpose**: Encapsulate compilation output
**Responsibilities**:
- Parse native result
- Copy SPIR-V bytes to managed memory
- Extract error messages
- Track warning/error counts

**Key Attributes**:
- `is_success`: Compilation succeeded
- `spirv_bytes`: MANAGED_POINTER with binary
- `error_message`: Failure reason
- `warning_count/error_count`: Diagnostic counts

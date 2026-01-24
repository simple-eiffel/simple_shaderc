# S04: FEATURE SPECIFICATIONS
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## SIMPLE_SHADERC Features

### Compilation
| Feature | Signature | Description |
|---------|-----------|-------------|
| compile_glsl | (STRING, INTEGER): detachable MANAGED_POINTER | Generic compilation |
| compile_compute | (STRING): detachable MANAGED_POINTER | Compute shader |
| compile_vertex | (STRING): detachable MANAGED_POINTER | Vertex shader |
| compile_fragment | (STRING): detachable MANAGED_POINTER | Fragment shader |

### Status
| Feature | Signature | Description |
|---------|-----------|-------------|
| has_error | BOOLEAN | Last compilation failed |
| last_error | STRING | Error message |
| is_ready | BOOLEAN | Compiler initialized |

### Utility
| Feature | Signature | Description |
|---------|-----------|-------------|
| save_spirv | (MANAGED_POINTER, STRING) | Write to file |
| verify_spirv_magic | (MANAGED_POINTER): BOOLEAN | Check magic number |
| dispose | | Release compiler |

### Constants
| Feature | Value | Description |
|---------|-------|-------------|
| Shader_vertex | 0 | Vertex shader kind |
| Shader_fragment | 1 | Fragment shader kind |
| Shader_compute | 2 | Compute shader kind |
| Shader_geometry | 3 | Geometry shader kind |
| Shader_tess_control | 4 | Tessellation control |
| Shader_tess_evaluation | 5 | Tessellation evaluation |
| Spirv_magic | 0x07230203 | SPIR-V magic number |

## SHADERC_RESULT Features

### Access
| Feature | Signature | Description |
|---------|-----------|-------------|
| is_success | BOOLEAN | Compilation succeeded |
| spirv_bytes | detachable MANAGED_POINTER | Binary output |
| spirv_size | INTEGER | Byte count |
| error_message | STRING | Failure reason |
| warning_count | INTEGER | Warning count |
| error_count | INTEGER | Error count |
| is_disposed | BOOLEAN | Resources released |

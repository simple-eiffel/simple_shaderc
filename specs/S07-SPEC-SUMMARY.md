# S07: SPECIFICATION SUMMARY
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## One-Line Description

Eiffel wrapper for Google's shaderc library providing runtime GLSL to SPIR-V shader compilation.

## Key Specifications

| Aspect | Specification |
|--------|---------------|
| **Type** | Native Library Wrapper |
| **Platform** | Windows, Linux (with shaderc) |
| **Language** | Eiffel with C inline externals |
| **External Dependency** | shaderc native library |
| **Input Format** | GLSL source code (STRING) |
| **Output Format** | SPIR-V binary (MANAGED_POINTER) |

## Shader Types Supported

| Type | Constant | Value |
|------|----------|-------|
| Vertex | Shader_vertex | 0 |
| Fragment | Shader_fragment | 1 |
| Compute | Shader_compute | 2 |
| Geometry | Shader_geometry | 3 |
| Tessellation Control | Shader_tess_control | 4 |
| Tessellation Evaluation | Shader_tess_evaluation | 5 |

## Typical Usage

```eiffel
local
    shaderc: SIMPLE_SHADERC
    spirv: detachable MANAGED_POINTER
do
    create shaderc.make
    spirv := shaderc.compile_fragment (my_glsl)
    if attached spirv then
        use_spirv_bytes (spirv.item, spirv.count)
    else
        print (shaderc.last_error)
    end
    shaderc.dispose
end
```

## Critical Invariants

1. Compiler handle must be valid before compilation
2. Result bytes are copied - safe after result disposal
3. dispose() must be called to prevent native memory leaks
4. Empty source string is rejected by precondition

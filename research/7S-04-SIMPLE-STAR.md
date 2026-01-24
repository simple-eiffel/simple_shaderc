# 7S-04: SIMPLE-STAR ECOSYSTEM
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Ecosystem Dependencies

### Uses (Dependencies)
- **EiffelBase**: MANAGED_POINTER for memory management
- **C_STRING**: String marshaling to C
- **RAW_FILE**: Saving SPIR-V binaries

### Used By (Dependents)
- **simple_vulkan** (potential) - Vulkan graphics wrapper
- **simple_gpu** (potential) - GPU compute library

## Integration Points

### SPIR-V Output
```eiffel
local
    shaderc: SIMPLE_SHADERC
    spirv: detachable MANAGED_POINTER
do
    create shaderc.make
    spirv := shaderc.compile_compute (glsl_source)
    if attached spirv as spv then
        -- spv.item = pointer to bytes
        -- spv.count = byte count
    end
    shaderc.dispose
end
```

### Vulkan Integration (typical usage)
```eiffel
-- Compile shader
spirv := shaderc.compile_vertex (vertex_source)

-- Create Vulkan shader module
create_info.code_size := spirv.count
create_info.p_code := spirv.item
vkCreateShaderModule (device, create_info, shader_module)
```

## Ecosystem Role

simple_shaderc is a **foundation library** for GPU programming - it provides the compilation step needed before shaders can be loaded into Vulkan/GPU pipelines.

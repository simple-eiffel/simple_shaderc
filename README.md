<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/simple_shaderc/master/docs/images/logo.svg" alt="simple_ library logo" width="400">
</p>

# simple_shaderc

**[Documentation](https://simple-eiffel.github.io/simple_shaderc/)** | **[GitHub](https://github.com/simple-eiffel/simple_shaderc)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()

Runtime GLSL to SPIR-V shader compilation for Eiffel via Google's shaderc library.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production** - 7 tests passing, wraps Vulkan SDK's shaderc library

## Overview

SIMPLE_SHADERC provides runtime shader compilation capabilities, allowing Eiffel applications to compile GLSL shader source code to SPIR-V binary format at runtime. This enables dynamic shader generation and hot-reloading workflows without requiring offline compilation tools.

## Quick Start

```eiffel
local
    shaderc: SIMPLE_SHADERC
    spirv: detachable MANAGED_POINTER
    glsl: STRING
do
    glsl := "[
        #version 450
        layout(local_size_x = 64) in;
        layout(std430, binding = 0) buffer Data { float values[]; };
        void main() {
            uint idx = gl_GlobalInvocationID.x;
            values[idx] = values[idx] * 2.0;
        }
    ]"

    create shaderc.make
    spirv := shaderc.compile_compute (glsl)

    if attached spirv as spv then
        print ("Compiled to " + spv.count.out + " bytes of SPIR-V")
    else
        print ("Error: " + shaderc.last_error)
    end

    shaderc.dispose
end
```

## Features

- **Runtime Compilation** - Compile GLSL to SPIR-V without offline tools
- **Multiple Shader Types** - Vertex, fragment, and compute shader support
- **Error Reporting** - Detailed compilation error messages
- **SPIR-V Output** - Direct binary output for Vulkan consumption
- **File I/O** - Save compiled shaders to disk
- **Vulkan SDK Integration** - Uses battle-tested shaderc from Vulkan SDK

## Installation

1. **Install Vulkan SDK** from https://vulkan.lunarg.com/sdk/home

2. Set the ecosystem environment variable:
```
SIMPLE_EIFFEL=D:\prod
```

3. Add to ECF:
```xml
<library name="simple_shaderc" location="$SIMPLE_EIFFEL/simple_shaderc/simple_shaderc.ecf"/>
```

4. Copy the shaderc DLL to your executable directory:
```batch
copy %VULKAN_SDK%\Bin\shaderc_shared.dll your_app_directory\
```

## Shader Compilation Example

```eiffel
local
    shaderc: SIMPLE_SHADERC
    spirv: detachable MANAGED_POINTER
do
    create shaderc.make

    -- Compile vertex shader
    spirv := shaderc.compile_vertex (vertex_glsl)
    if attached spirv as spv then
        shaderc.save_spirv (spv, "vertex.spv")
    end

    -- Compile fragment shader
    spirv := shaderc.compile_fragment (fragment_glsl)
    if attached spirv as spv then
        shaderc.save_spirv (spv, "fragment.spv")
    end

    -- Compile compute shader
    spirv := shaderc.compile_compute (compute_glsl)
    if attached spirv as spv then
        shaderc.save_spirv (spv, "compute.spv")
    end

    shaderc.dispose
end
```

## Integration with simple_vulkan

Use simple_shaderc with simple_vulkan for a complete GPU compute pipeline:

```eiffel
local
    builder: SDF_GLSL_BUILDER
    shaderc: SIMPLE_SHADERC
    vk: SIMPLE_VULKAN
    ctx: VULKAN_CONTEXT
    shader: VULKAN_SHADER
    glsl: STRING
    spirv: detachable MANAGED_POINTER
do
    -- Generate GLSL from Eiffel DSL
    create builder.make
    glsl := builder.generate_basic_shader (scene_code)

    -- Compile to SPIR-V at runtime
    create shaderc.make
    spirv := shaderc.compile_compute (glsl)

    if attached spirv as spv then
        -- Save and load with Vulkan
        shaderc.save_spirv (spv, "dynamic.spv")

        create vk
        ctx := vk.create_context
        if ctx.is_valid then
            shader := vk.load_shader (ctx, "dynamic.spv")
            -- Use shader...
        end
    end

    shaderc.dispose
end
```

## Dependencies

- Vulkan SDK (https://vulkan.lunarg.com/) for shaderc library
- `shaderc_shared.dll` must be in PATH or application directory
- No Eiffel library dependencies

## Shader Types

| Type | Constant | Use Case |
|------|----------|----------|
| Compute | `Shader_compute` | GPU parallel computation |
| Vertex | `Shader_vertex` | Vertex transformation |
| Fragment | `Shader_fragment` | Pixel shading |

## API Overview

### SIMPLE_SHADERC

Main facade class for shader compilation.

| Feature | Description |
|---------|-------------|
| `make` | Initialize the compiler |
| `compile_glsl (source, kind)` | Compile GLSL source to SPIR-V |
| `compile_compute (source)` | Compile compute shader |
| `compile_vertex (source)` | Compile vertex shader |
| `compile_fragment (source)` | Compile fragment shader |
| `save_spirv (data, path)` | Save SPIR-V to file |
| `last_error` | Last compilation error message |
| `has_error` | True if last compilation failed |
| `dispose` | Release compiler resources |

## Error Handling

```eiffel
spirv := shaderc.compile_compute (glsl)
if spirv = Void then
    print ("Compilation failed:%N")
    print (shaderc.last_error)
else
    -- Use spirv...
end
```

## Performance

- Compiler initialization: <5ms
- Simple shader compilation: <50ms
- Complex SDF shader (300+ lines): ~100ms

## License

MIT License

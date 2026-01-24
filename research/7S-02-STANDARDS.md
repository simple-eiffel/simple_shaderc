# 7S-02: STANDARDS
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Applicable Standards

### SPIR-V Standards
- **SPIR-V 1.0+**: Khronos standard intermediate representation
- **Magic Number**: 0x07230203 (little-endian validation)
- **Binary Format**: Word-aligned 32-bit format

### GLSL Standards
- **GLSL 4.50+**: OpenGL Shading Language
- **Vulkan GLSL**: Version with Vulkan-specific extensions
- **Entry Point**: Standard "main" function

### Shaderc Library
- **Google shaderc**: Reference GLSL compiler
- **Header**: `<shaderc/shaderc.h>`
- **Compilation Status**: 0 = success

## Design Patterns

1. **Facade Pattern**: SIMPLE_SHADERC wraps SHADERC_COMPILER
2. **Resource Management**: Explicit dispose() for native handles
3. **Lazy Initialization**: Compiler created on first use
4. **Result Object**: SHADERC_RESULT encapsulates compilation output

## References

- Khronos SPIR-V Specification: https://www.khronos.org/registry/SPIR-V/
- Shaderc GitHub: https://github.com/google/shaderc
- Vulkan GLSL: https://www.khronos.org/opengl/wiki/Core_Language_(GLSL)

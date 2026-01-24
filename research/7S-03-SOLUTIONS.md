# 7S-03: SOLUTIONS
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Existing Solutions Analyzed

### 1. glslang (Khronos Reference Compiler)
- **Pros**: Official reference, comprehensive
- **Cons**: Complex API, requires multiple headers

### 2. shaderc (Google)
- **Pros**: Simple C API, well-maintained, used by Chrome
- **Cons**: Requires linking external library

### 3. SPIRV-Cross
- **Pros**: Bidirectional (SPIR-V <-> GLSL)
- **Cons**: Different purpose (reflection/decompilation)

### 4. Offline Compilation (glslc)
- **Pros**: No runtime dependency
- **Cons**: No hot-reload, extra build step

## Why shaderc?

1. **Simplest API**: Single header, clear lifecycle
2. **Industry Proven**: Used in Chromium, Filament
3. **Active Development**: Regular updates from Google
4. **Complete Feature Set**: All shader types, good errors

## Key Differentiators of simple_shaderc

- Eiffel-native wrapper with contracts
- Type-safe SPIR-V output (MANAGED_POINTER)
- Automatic resource cleanup pattern
- Simplified facade for common operations

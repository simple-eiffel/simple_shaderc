# S05: CONSTRAINTS
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Technical Constraints

### Native Library
- **shaderc Required**: Must have shaderc library installed
- **Platform**: Windows (shaderc.dll) or Linux (libshaderc.so)
- **Header**: shaderc/shaderc.h must be in include path

### GLSL Requirements
- Entry point must be "main"
- Must be valid Vulkan GLSL (not desktop OpenGL)
- No #include support in basic compilation

### Output Format
- SPIR-V binary format only
- Little-endian byte order
- 32-bit word aligned

## Design Constraints

### Memory Management
- Caller owns returned MANAGED_POINTER
- Must call dispose() on compiler when done
- Must call dispose() on results after copying
- SPIR-V bytes are copied (safe after dispose)

### Threading
- SHADERC_COMPILER is NOT thread-safe
- Create separate instances for parallel compilation
- SHADERC_RESULT is read-only after creation

### Error Handling
- No exceptions - check has_error after compile
- Error details in last_error string
- Void result indicates failure

## Operational Constraints

### Performance
- First compilation incurs initialization cost
- Subsequent compilations are faster
- No built-in caching

### Shader Complexity
- Compiler may timeout on extremely complex shaders
- Memory usage proportional to shader size
- Deep recursion in GLSL may fail

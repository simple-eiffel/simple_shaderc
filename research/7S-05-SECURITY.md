# 7S-05: SECURITY
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Security Considerations

### Threat Model

1. **Malicious Shader Code**: Untrusted GLSL could exploit compiler bugs
2. **Memory Corruption**: Native pointer handling errors
3. **Resource Exhaustion**: Large/complex shaders consuming resources

### Mitigations

#### Input Validation
- Source string must not be empty (precondition)
- Compiler reports errors for invalid GLSL
- SPIR-V magic number validation available

#### Memory Safety
- MANAGED_POINTER provides safe byte access
- Result bytes are COPIED from native memory
- Explicit dispose() releases native handles
- Void-safe design prevents null dereference

#### Resource Management
- Compiler instances are lightweight
- Results must be disposed after use
- No persistent state between compilations

### Native Code Risks

The library uses C inline externals:
```eiffel
external
    "C inline use <shaderc/shaderc.h>"
```

This means:
- Requires shaderc library to be installed
- Trusts shaderc implementation security
- Native memory managed by shaderc

### Recommendations

1. Validate shader source from untrusted sources
2. Implement timeout for compilation
3. Consider sandboxing for user-provided shaders
4. Always call dispose() to prevent leaks

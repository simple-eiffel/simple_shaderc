# 7S-01: SCOPE
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## What Problem Does This Solve?

simple_shaderc provides Eiffel applications with runtime GLSL shader compilation:
- Compile GLSL shaders to SPIR-V at runtime
- Support for all shader stages (vertex, fragment, compute, geometry, tessellation)
- Error reporting for shader compilation failures
- Integration with Vulkan graphics pipelines

## Target Users

1. **Vulkan/Graphics Developers** - Need shader compilation for rendering
2. **GPU Compute Applications** - Compile compute shaders dynamically
3. **Game Developers** - Hot-reload shader changes during development

## Domain

GPU shader compilation using Google's shaderc library for Vulkan/SPIR-V targets.

## In-Scope

- GLSL to SPIR-V compilation
- All shader types (vertex, fragment, compute, geometry, tessellation)
- Compilation error reporting
- SPIR-V binary output as MANAGED_POINTER
- SPIR-V magic number validation
- File save utility for compiled shaders

## Out-of-Scope

- HLSL compilation
- Shader optimization passes
- Reflection/introspection of compiled shaders
- Runtime shader linking
- Cross-compilation to non-SPIR-V targets

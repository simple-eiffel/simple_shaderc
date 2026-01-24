# 7S-06: SIZING
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Current Size

### Source Files
- **Classes**: 3 Eiffel classes
- **Lines**: ~375 lines of Eiffel code
- **Test Classes**: 2

### Class Breakdown
| Class | Lines | Responsibility |
|-------|-------|----------------|
| SIMPLE_SHADERC | 171 | High-level facade |
| SHADERC_COMPILER | 176 | Native compiler wrapper |
| SHADERC_RESULT | 203 | Compilation result with SPIR-V |

## External Dependencies

### Native Library Size
- **shaderc.dll**: ~5-10 MB (includes SPIRV-Tools)
- **Header**: shaderc.h only

### Memory Usage
- Compiler instance: Small (handle only)
- Result: Varies with shader complexity
- SPIR-V output: Typically 1-100 KB per shader

## Complexity Assessment

- **Cyclomatic Complexity**: Low (mostly delegation)
- **C External Calls**: 8 inline externals
- **API Surface**: 6 public features on facade

## Growth Projections

- Stable - shaderc API rarely changes
- Potential additions: compile options, include handling
- No significant growth expected

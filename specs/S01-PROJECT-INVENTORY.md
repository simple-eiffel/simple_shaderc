# S01: PROJECT INVENTORY
**Library**: simple_shaderc
**Status**: BACKWASH (retroactive documentation)
**Date**: 2026-01-23

## Project Structure

```
simple_shaderc/
├── src/
│   ├── simple_shaderc.e       # High-level facade
│   ├── shaderc_compiler.e     # Native compiler wrapper
│   └── shaderc_result.e       # Compilation result
├── testing/
│   ├── test_app.e             # Test runner
│   └── lib_tests.e            # Test suite
├── research/                   # 7S research documents
├── specs/                      # Specification documents
└── simple_shaderc.ecf         # Project configuration
```

## Source Files

| File | Type | Lines | Purpose |
|------|------|-------|---------|
| simple_shaderc.e | Facade | 171 | User-facing compilation API |
| shaderc_compiler.e | Core | 176 | Native shaderc wrapper |
| shaderc_result.e | Data | 203 | SPIR-V bytes and errors |

## Dependencies

### External Libraries
- EiffelBase (standard library)
- shaderc native library (C)

### Native Requirements
- shaderc.dll / libshaderc.so
- shaderc/shaderc.h header

### Test Dependencies
- None (basic test harness)

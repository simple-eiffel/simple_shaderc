note
	description: "[
		simple_shaderc - Eiffel wrapper for Google's shaderc library.
		
		Provides runtime GLSL to SPIR-V compilation for Vulkan shaders.
		
		Example usage:
			local
				shaderc: SIMPLE_SHADERC
				spirv: detachable MANAGED_POINTER
			do
				create shaderc
				spirv := shaderc.compile_compute (glsl_source)
				if attached spirv as spv then
					-- Use spv.item and spv.count for SPIR-V bytes
				else
					print (shaderc.last_error)
				end
				shaderc.dispose
			end
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SIMPLE_SHADERC

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize shaderc compiler.
		do
			create last_error.make_empty
		end

feature -- Compilation

	compile_glsl (a_source: STRING; a_kind: INTEGER): detachable MANAGED_POINTER
			-- Compile GLSL source to SPIR-V bytes.
			-- Returns Void on failure; check `last_error`.
		require
			source_not_empty: not a_source.is_empty
		local
			l_result: SHADERC_RESULT
		do
			ensure_compiler
			if attached compiler as comp then
				l_result := comp.compile (a_source, a_kind, "shader", "main")
				if l_result.is_success then
					Result := l_result.spirv_bytes
					has_error := False
					last_error.wipe_out
				else
					has_error := True
					last_error := l_result.error_message.twin
				end
				l_result.dispose
			else
				has_error := True
				last_error := "Failed to initialize shaderc compiler"
			end
		ensure
			error_on_void: Result = Void implies has_error
		end

	compile_compute (a_source: STRING): detachable MANAGED_POINTER
			-- Compile compute shader GLSL to SPIR-V.
		require
			source_not_empty: not a_source.is_empty
		do
			Result := compile_glsl (a_source, Shader_compute)
		end

	compile_vertex (a_source: STRING): detachable MANAGED_POINTER
			-- Compile vertex shader GLSL to SPIR-V.
		require
			source_not_empty: not a_source.is_empty
		do
			Result := compile_glsl (a_source, Shader_vertex)
		end

	compile_fragment (a_source: STRING): detachable MANAGED_POINTER
			-- Compile fragment shader GLSL to SPIR-V.
		require
			source_not_empty: not a_source.is_empty
		do
			Result := compile_glsl (a_source, Shader_fragment)
		end

feature -- Status

	has_error: BOOLEAN
			-- Did last compilation fail?

	last_error: STRING
			-- Error message from last failed compilation.

	is_ready: BOOLEAN
			-- Is compiler ready for use?
		do
			ensure_compiler
			Result := attached compiler as c and then c.is_valid
		end

feature -- Shader Types

	Shader_vertex: INTEGER = 0
	Shader_fragment: INTEGER = 1
	Shader_compute: INTEGER = 2
	Shader_geometry: INTEGER = 3
	Shader_tess_control: INTEGER = 4
	Shader_tess_evaluation: INTEGER = 5

feature -- Cleanup

	dispose
			-- Release compiler resources.
		do
			if attached compiler as c then
				c.dispose
				compiler := Void
			end
		end

feature {NONE} -- Implementation

	compiler: detachable SHADERC_COMPILER
			-- Lazily initialized compiler instance.

	ensure_compiler
			-- Ensure compiler is initialized.
		do
			if compiler = Void then
				create compiler.make
			end
		ensure
			compiler_exists: compiler /= Void
		end

feature -- Utility

	save_spirv (a_spirv: MANAGED_POINTER; a_path: STRING)
			-- Save SPIR-V bytes to file.
		require
			spirv_valid: a_spirv.count > 0
			path_not_empty: not a_path.is_empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_write (a_path)
			l_file.put_managed_pointer (a_spirv, 0, a_spirv.count)
			l_file.close
		end

	verify_spirv_magic (a_spirv: MANAGED_POINTER): BOOLEAN
			-- Check if data has valid SPIR-V magic number.
		require
			sufficient_size: a_spirv.count >= 4
		do
			Result := a_spirv.read_natural_32 (0) = Spirv_magic
		end

	Spirv_magic: NATURAL_32 = 0x07230203
			-- SPIR-V magic number (little-endian).

end

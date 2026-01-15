note
	description: "[
		Wrapper for shaderc compiler instance.
		
		Use `compile` to compile GLSL source to SPIR-V.
		Must call `dispose` when done to release resources.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SHADERC_COMPILER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize the compiler.
		do
			handle := c_compiler_initialize
			is_valid := (handle /= default_pointer)
		ensure
			validity_check: is_valid = (handle /= default_pointer)
		end

feature -- Access

	is_valid: BOOLEAN
			-- Is compiler initialized successfully?

feature -- Compilation

	compile (a_source: STRING; a_kind: INTEGER; a_filename: STRING; a_entry_point: STRING): SHADERC_RESULT
			-- Compile GLSL source to SPIR-V.
			-- `a_kind` is shader type (use Shader_* constants).
			-- `a_filename` is for error reporting.
			-- `a_entry_point` is usually "main".
		require
			valid_compiler: is_valid
			source_not_empty: not a_source.is_empty
			filename_not_empty: not a_filename.is_empty
			entry_not_empty: not a_entry_point.is_empty
		local
			l_source_c, l_filename_c, l_entry_c: C_STRING
			l_result_handle: POINTER
		do
			create l_source_c.make (a_source)
			create l_filename_c.make (a_filename)
			create l_entry_c.make (a_entry_point)

			l_result_handle := c_compile_into_spv (
				handle,
				l_source_c.item,
				a_source.count,
				a_kind,
				l_filename_c.item,
				l_entry_c.item,
				default_pointer  -- No options for now
			)

			create Result.make_from_handle (l_result_handle)
		end

	compile_compute (a_source: STRING): SHADERC_RESULT
			-- Compile compute shader GLSL to SPIR-V.
		require
			valid_compiler: is_valid
			source_not_empty: not a_source.is_empty
		do
			Result := compile (a_source, Shader_compute, "compute.comp", "main")
		end

	compile_vertex (a_source: STRING): SHADERC_RESULT
			-- Compile vertex shader GLSL to SPIR-V.
		require
			valid_compiler: is_valid
			source_not_empty: not a_source.is_empty
		do
			Result := compile (a_source, Shader_vertex, "shader.vert", "main")
		end

	compile_fragment (a_source: STRING): SHADERC_RESULT
			-- Compile fragment shader GLSL to SPIR-V.
		require
			valid_compiler: is_valid
			source_not_empty: not a_source.is_empty
		do
			Result := compile (a_source, Shader_fragment, "shader.frag", "main")
		end

feature -- Shader Types

	Shader_vertex: INTEGER = 0
			-- shaderc_vertex_shader

	Shader_fragment: INTEGER = 1
			-- shaderc_fragment_shader

	Shader_compute: INTEGER = 2
			-- shaderc_compute_shader

	Shader_geometry: INTEGER = 3
			-- shaderc_geometry_shader

	Shader_tess_control: INTEGER = 4
			-- shaderc_tess_control_shader

	Shader_tess_evaluation: INTEGER = 5
			-- shaderc_tess_evaluation_shader

feature -- Cleanup

	dispose
			-- Release compiler resources.
		do
			if handle /= default_pointer then
				c_compiler_release (handle)
				handle := default_pointer
				is_valid := False
			end
		ensure
			disposed: handle = default_pointer
			not_valid: not is_valid
		end

feature {NONE} -- Implementation

	handle: POINTER
			-- Native shaderc_compiler_t handle.

feature {NONE} -- C Externals

	c_compiler_initialize: POINTER
			-- Initialize a new compiler instance.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_POINTER)shaderc_compiler_initialize();
			]"
		end

	c_compiler_release (a_compiler: POINTER)
			-- Release compiler resources.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				shaderc_compiler_release((shaderc_compiler_t)$a_compiler);
			]"
		end

	c_compile_into_spv (a_compiler, a_source: POINTER; a_size: INTEGER;
						a_kind: INTEGER; a_filename, a_entry, a_options: POINTER): POINTER
			-- Compile GLSL into SPIR-V.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_POINTER)shaderc_compile_into_spv(
					(shaderc_compiler_t)$a_compiler,
					(const char*)$a_source,
					(size_t)$a_size,
					(shaderc_shader_kind)$a_kind,
					(const char*)$a_filename,
					(const char*)$a_entry,
					(const shaderc_compile_options_t)$a_options
				);
			]"
		end

end

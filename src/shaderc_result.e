note
	description: "[
		Result of a shaderc compilation operation.
		
		Contains SPIR-V bytes on success, or error message on failure.
		Must call `dispose` when done to free native resources.
	]"
	author: "Larry Rix"
	date: "$Date$"
	revision: "$Revision$"

class
	SHADERC_RESULT

create
	make_from_handle

feature {NONE} -- Initialization

	make_from_handle (a_handle: POINTER)
			-- Create from native compilation result handle.
		require
			valid_handle: a_handle /= default_pointer
		do
			handle := a_handle
			parse_result
		ensure
			handle_set: handle = a_handle
		end

feature -- Access

	is_success: BOOLEAN
			-- Did compilation succeed?

	spirv_bytes: detachable MANAGED_POINTER
			-- SPIR-V binary data (valid only if `is_success`).
			-- This is a COPY - safe to use after dispose.

	spirv_size: INTEGER
			-- Size of SPIR-V binary in bytes.

	error_message: STRING
			-- Error message if compilation failed.
		attribute
			create Result.make_empty
		end

	warning_count: INTEGER
			-- Number of warnings during compilation.

	error_count: INTEGER
			-- Number of errors during compilation.

feature -- Status

	is_disposed: BOOLEAN
			-- Has this result been disposed?

feature -- Cleanup

	dispose
			-- Release native resources.
		do
			if not is_disposed and handle /= default_pointer then
				c_result_release (handle)
				handle := default_pointer
				is_disposed := True
			end
		ensure
			disposed: is_disposed
		end

feature {NONE} -- Implementation

	handle: POINTER
			-- Native shaderc_compilation_result_t handle.

	parse_result
			-- Parse native result into Eiffel attributes.
		local
			l_status: INTEGER
			l_size: INTEGER
			l_bytes: POINTER
			l_msg: POINTER
			l_c_str: C_STRING
		do
			l_status := c_result_get_compilation_status (handle)
			is_success := (l_status = 0) -- shaderc_compilation_status_success

			warning_count := c_result_get_num_warnings (handle)
			error_count := c_result_get_num_errors (handle)

			if is_success then
				l_size := c_result_get_length (handle).to_integer_32
				spirv_size := l_size
				if l_size > 0 then
					l_bytes := c_result_get_bytes (handle)
					if l_bytes /= default_pointer then
						-- Make a copy of the SPIR-V data
						create spirv_bytes.make (l_size)
						check attached spirv_bytes as spv then
							spv.item.memory_copy (l_bytes, l_size)
						end
					end
				end
			else
				l_msg := c_result_get_error_message (handle)
				if l_msg /= default_pointer then
					create l_c_str.make_by_pointer (l_msg)
					error_message := l_c_str.string
				else
					error_message := "Unknown compilation error"
				end
			end
		end

feature {NONE} -- C Externals

	c_result_get_compilation_status (a_result: POINTER): INTEGER
			-- Get compilation status (0 = success).
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_INTEGER)shaderc_result_get_compilation_status(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_get_length (a_result: POINTER): INTEGER_64
			-- Get length of compiled output in bytes.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_INTEGER_64)shaderc_result_get_length(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_get_bytes (a_result: POINTER): POINTER
			-- Get pointer to compiled output bytes.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_POINTER)shaderc_result_get_bytes(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_get_error_message (a_result: POINTER): POINTER
			-- Get error message string.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_POINTER)shaderc_result_get_error_message(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_get_num_warnings (a_result: POINTER): INTEGER
			-- Get number of warnings.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_INTEGER)shaderc_result_get_num_warnings(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_get_num_errors (a_result: POINTER): INTEGER
			-- Get number of errors.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				return (EIF_INTEGER)shaderc_result_get_num_errors(
					(shaderc_compilation_result_t)$a_result
				);
			]"
		end

	c_result_release (a_result: POINTER)
			-- Release compilation result.
		external
			"C inline use <shaderc/shaderc.h>"
		alias
			"[
				shaderc_result_release((shaderc_compilation_result_t)$a_result);
			]"
		end

end

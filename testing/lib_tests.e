note
	description: "Tests for simple_shaderc library"
	author: "Larry Rix"

class
	LIB_TESTS

feature -- Tests

	test_compiler_initialization
			-- Test that compiler initializes successfully.
		local
			compiler: SHADERC_COMPILER
		do
			create compiler.make
			check_true ("compiler valid", compiler.is_valid)
			compiler.dispose
			check_true ("compiler disposed", not compiler.is_valid)
		end

	test_facade_ready
			-- Test facade initialization.
		local
			shaderc: SIMPLE_SHADERC
		do
			create shaderc.make
			check_true ("shaderc ready", shaderc.is_ready)
			shaderc.dispose
		end

	test_compile_simple_compute_shader
			-- Test compiling a minimal compute shader.
		local
			shaderc: SIMPLE_SHADERC
			spirv: detachable MANAGED_POINTER
			glsl: STRING
		do
			glsl := "[
				#version 450
				layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
				layout(std430, binding = 0) buffer Data { uint data[]; };
				void main() {
					data[gl_GlobalInvocationID.x] = 42u;
				}
			]"

			create shaderc.make
			spirv := shaderc.compile_compute (glsl)

			if spirv = Void then
				print ("Compute shader error: " + shaderc.last_error + "%N")
			end
			check_true ("compilation succeeded", spirv /= Void)
			check_true ("no error", not shaderc.has_error)

			if attached spirv as spv then
				check_true ("has content", spv.count > 0)
				check_true ("valid spirv magic", shaderc.verify_spirv_magic (spv))
			end

			shaderc.dispose
		end

	test_compile_fragment_shader
			-- Test compiling a fragment shader.
		local
			shaderc: SIMPLE_SHADERC
			spirv: detachable MANAGED_POINTER
			glsl: STRING
		do
			glsl := "[
				#version 450
				layout(location = 0) out vec4 fragColor;
				void main() {
					fragColor = vec4(1.0, 0.0, 0.0, 1.0);
				}
			]"

			create shaderc.make
			spirv := shaderc.compile_fragment (glsl)

			check_true ("fragment compilation succeeded", spirv /= Void)
			if attached spirv as spv then
				check_true ("valid spirv", shaderc.verify_spirv_magic (spv))
			end

			shaderc.dispose
		end

	test_compile_vertex_shader
			-- Test compiling a vertex shader.
		local
			shaderc: SIMPLE_SHADERC
			spirv: detachable MANAGED_POINTER
			glsl: STRING
		do
			glsl := "[
				#version 450
				layout(location = 0) in vec3 position;
				void main() {
					gl_Position = vec4(position, 1.0);
				}
			]"

			create shaderc.make
			spirv := shaderc.compile_vertex (glsl)

			check_true ("vertex compilation succeeded", spirv /= Void)
			if attached spirv as spv then
				check_true ("valid spirv", shaderc.verify_spirv_magic (spv))
			end

			shaderc.dispose
		end

	test_compile_error_handling
			-- Test that compilation errors are reported.
		local
			shaderc: SIMPLE_SHADERC
			spirv: detachable MANAGED_POINTER
			glsl: STRING
		do
			glsl := "[
				#version 450
				void main() {
					this_is_invalid_glsl;
				}
			]"

			create shaderc.make
			spirv := shaderc.compile_compute (glsl)

			check_true ("compilation failed", spirv = Void)
			check_true ("has error", shaderc.has_error)
			check_true ("error message not empty", not shaderc.last_error.is_empty)

			shaderc.dispose
		end

	test_sdf_sphere_shader
			-- Test compiling a basic SDF sphere shader.
		local
			shaderc: SIMPLE_SHADERC
			spirv: detachable MANAGED_POINTER
			glsl: STRING
		do
			glsl := "[
				#version 450
				layout(local_size_x = 16, local_size_y = 16, local_size_z = 1) in;
				layout(std430, binding = 0) buffer Output { uint pixels[]; };
				layout(std430, binding = 1) buffer Params {
					float cam_x, cam_y, cam_z;
					float cam_yaw, cam_pitch;
					float time;
					uint width, height;
				};

				float sdSphere(vec3 p, float r) { return length(p) - r; }

				void main() {
					uvec2 gid = gl_GlobalInvocationID.xy;
					if (gid.x >= width || gid.y >= height) return;

					vec2 uv = (vec2(gid) / vec2(width, height)) * 2.0 - 1.0;
					uv.x *= float(width) / float(height);

					vec3 ro = vec3(cam_x, cam_y, cam_z);
					vec3 rd = normalize(vec3(uv, -1.0));

					float t = 0.0;
					for (int i = 0; i < 64; i++) {
						float d = sdSphere(ro + rd * t, 1.0);
						if (d < 0.001) break;
						t += d;
						if (t > 100.0) break;
					}

					vec3 col = t < 100.0 ? vec3(1.0, 0.5, 0.2) : vec3(0.1);
					uint r = uint(col.r * 255.0);
					uint g = uint(col.g * 255.0);
					uint b = uint(col.b * 255.0);
					pixels[gid.y * width + gid.x] = 0xFF000000u | (b << 16) | (g << 8) | r;
				}
			]"

			create shaderc.make
			spirv := shaderc.compile_compute (glsl)

			if spirv = Void then
				print ("SDF shader error: " + shaderc.last_error + "%N")
			end
			check_true ("SDF shader compiled", spirv /= Void)
			check_true ("no error", not shaderc.has_error)

			if attached spirv as spv then
				check_true ("substantial size", spv.count > 500)
			end

			shaderc.dispose
		end

feature {NONE} -- Assertion

	check_true (a_tag: STRING; a_condition: BOOLEAN)
			-- Assert condition is true.
		do
			if not a_condition then
				print ("ASSERTION FAILED: " + a_tag + "%N")
				(create {EXCEPTIONS}).raise ("Assertion failed: " + a_tag)
			end
		end

end

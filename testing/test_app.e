note
	description: "Test application for simple_shaderc"
	author: "Larry Rix"

class
	TEST_APP

create
	make

feature {NONE} -- Initialization

	make
			-- Run tests.
		do
			print ("Running simple_shaderc tests...%N%N")
			passed := 0
			failed := 0

			create lib_tests
			run_test (agent lib_tests.test_compiler_initialization, "test_compiler_initialization")
			run_test (agent lib_tests.test_facade_ready, "test_facade_ready")
			run_test (agent lib_tests.test_compile_simple_compute_shader, "test_compile_simple_compute_shader")
			run_test (agent lib_tests.test_compile_fragment_shader, "test_compile_fragment_shader")
			run_test (agent lib_tests.test_compile_vertex_shader, "test_compile_vertex_shader")
			run_test (agent lib_tests.test_compile_error_handling, "test_compile_error_handling")
			run_test (agent lib_tests.test_sdf_sphere_shader, "test_sdf_sphere_shader")

			print ("%N========================%N")
			print ("Results: " + passed.out + " passed, " + failed.out + " failed%N")

			if failed > 0 then
				print ("TESTS FAILED%N")
			else
				print ("ALL TESTS PASSED%N")
			end
		end

feature {NONE} -- Test Runner

	lib_tests: LIB_TESTS

	passed, failed: INTEGER

	run_test (a_test: PROCEDURE; a_name: STRING)
			-- Run a single test.
		local
			l_rescued: BOOLEAN
		do
			if not l_rescued then
				print ("  " + a_name + "... ")
				a_test.call (Void)
				print ("PASSED%N")
				passed := passed + 1
			end
		rescue
			print ("FAILED%N")
			failed := failed + 1
			l_rescued := True
			retry
		end

end

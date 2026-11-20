module test_greet
    use testdrive, only: new_unittest, unittest_type, error_type, check
    use {{PROJECT_SNAKE}}, only: greet
    implicit none
    private

    public :: collect_greet

contains

    subroutine collect_greet(testsuite)
        type(unittest_type), allocatable, intent(out) :: testsuite(:)

        testsuite = [new_unittest("a greeting addresses the name it is given", test_greeting)]
    end subroutine collect_greet

    subroutine test_greeting(error)
        type(error_type), allocatable, intent(out) :: error

        call check(error, greet("world"), "Hello, world!")
    end subroutine test_greeting

end module test_greet

program test_greet_runner
    use, intrinsic :: iso_fortran_env, only: error_unit
    use testdrive, only: run_testsuite
    use test_greet, only: collect_greet
    implicit none

    integer :: failures

    failures = 0
    call run_testsuite(collect_greet, error_unit, failures)
    if (failures > 0) error stop
end program test_greet_runner

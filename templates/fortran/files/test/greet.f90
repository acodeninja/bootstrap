! This file is both the test and its own runner: the module holds the tests and
! the program at the foot of the file runs them. fpm finds it by being under
! test/, and builds each file there as its own executable -- so a test is found
! by existing and deleting one is safe. Run the suite with `make test`.
module test_greet
    ! `only:` narrows what a `use` brings in, which is worth writing every time:
    ! without it a module dumps every public name into scope, and two modules
    ! exporting the same name is then a clash you have to go looking for.
    use testdrive, only: new_unittest, unittest_type, error_type, check
    use {{PROJECT_SNAKE}}, only: greet
    implicit none
    private

    public :: collect_greet

contains

    ! test-drive asks each test module for its tests rather than discovering
    ! them, so this subroutine is the registration: a test not in the array
    ! below does not run.
    subroutine collect_greet(testsuite)
        type(unittest_type), allocatable, intent(out) :: testsuite(:)

        ! The array is built with [ ... ] and assigned in one go. The string is
        ! the test name and it is what a failure prints, so it is a real
        ! sentence; the second argument is the subroutine itself, passed as a
        ! value.
        testsuite = [new_unittest("a greeting addresses the name it is given", test_greeting)]
    end subroutine collect_greet

    ! A test is a subroutine taking one argument out. Fortran has no exceptions,
    ! so a failure cannot be thrown: `error` is allocated by check when the
    ! assertion does not hold, and the runner looks at whether it was.
    subroutine test_greeting(error)
        type(error_type), allocatable, intent(out) :: error

        ! `call` is how a subroutine is invoked -- a function would be used in
        ! an expression instead, and that distinction is enforced.
        !
        ! check takes the error to fill in, then the actual value, then the
        ! expected one.
        call check(error, greet("world"), "Hello, world!")
    end subroutine test_greeting

end module test_greet

! The program, which has to be in this file because fpm builds one executable
! per test file and an executable needs a program.
program test_greet_runner
    use, intrinsic :: iso_fortran_env, only: error_unit
    use testdrive, only: run_testsuite
    use test_greet, only: collect_greet
    implicit none

    integer :: failures

    failures = 0
    call run_testsuite(collect_greet, error_unit, failures)
    ! `error stop` ends the program with a non-zero status, which is the only
    ! thing `make test` can see. Without this line a failing assertion would
    ! print its complaint and the build would still go green.
    if (failures > 0) error stop
end program test_greet_runner

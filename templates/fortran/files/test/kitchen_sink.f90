!> Fifteen passing assertions: the toolbox for solving a kata in Fortran.
module test_kitchen_sink
    use testdrive, only: new_unittest, unittest_type, error_type, check
    implicit none
    private

    public :: collect_kitchen_sink

    type :: point
        integer :: x
        integer :: y
    end type point

    integer, parameter :: locked = 1
    integer, parameter :: unlocked = 2

    abstract interface
        function mapper(value) result(mapped)
            integer, intent(in) :: value
            integer :: mapped
        end function mapper
    end interface

contains

    subroutine collect_kitchen_sink(testsuite)
        type(unittest_type), allocatable, intent(out) :: testsuite(:)

        testsuite = [ &
                    new_unittest("an array keeps what you put in it, in order", test_array_order), &
                    new_unittest("a lookup for a key that is not there comes back as zero", test_lookup_misses), &
                    new_unittest("counting is how you ask whether a value is already there", test_counting), &
                    new_unittest("a string is split by finding the separator yourself", test_split), &
                    new_unittest("a substring counts from one and includes its last position", test_substring), &
                    new_unittest("text is built up by concatenation, repetition and an internal write", test_building_text), &
                    new_unittest("assigning a derived type copies its value", test_derived_type_copies), &
                    new_unittest("a fixed set of states is a set of integer parameters", test_named_states), &
                    new_unittest("a branch that yields a value has to assign it", test_branch_assigns), &
                    new_unittest("a loop can read both the position and the item", test_loop_position), &
                    new_unittest("a sequence can be walked two items at a time", test_lookahead), &
                    new_unittest("a function can be handed to another function through an interface", test_function_argument), &
                    new_unittest("an array is folded to one value by an intrinsic", test_fold), &
                    new_unittest("an invalid input is refused through a status argument", test_status_argument), &
                    new_unittest("a fixed-length string is padded with blanks, so its length lies", test_blank_padding) &
                    ]
    end subroutine collect_kitchen_sink

    ! collections

    subroutine test_array_order(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=1), allocatable :: items(:)

        items = ["a", "b"]
        items = [items, "c"]

        call check(error, size(items), 3)
        call check(error, items(2), "b")
        call check(error, size(items(2:3)), 2)
    end subroutine test_array_order

    !> Fortran has no map type, so a key is a position in one array and the value
    !> is the same position in another. FINDLOC answers zero for a key it cannot
    !> find, which is why nothing here indexes without checking first.
    subroutine test_lookup_misses(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=1), parameter :: keys(2) = ["a", "b"]
        integer, parameter :: counts(2) = [2, 1]

        call check(error, findloc(keys, "a", dim=1), 1)
        call check(error, findloc(keys, "z", dim=1), 0)
        call check(error, counts(findloc(keys, "a", dim=1)), 2)
    end subroutine test_lookup_misses

    !> There is no set type either. Uniqueness is a question you ask an array.
    subroutine test_counting(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=1), parameter :: letters(3) = ["a", "b", "a"]

        call check(error, count(letters == "a"), 2)
        call check(error, any(letters == "b"))
        call check(error, count(letters == "z") == 0)
    end subroutine test_counting

    ! strings

    subroutine test_split(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=*), parameter :: text = "one two three"
        integer :: at

        at = index(text, " ")

        call check(error, at, 4)
        call check(error, text(:at - 1), "one")
        call check(error, text(at + 1:), "two three")
    end subroutine test_split

    subroutine test_substring(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=*), parameter :: text = "abcdef"

        call check(error, text(1:1), "a")
        call check(error, text(1:3), "abc")
        call check(error, text(len(text) - 1:), "ef")
    end subroutine test_substring

    subroutine test_building_text(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=:), allocatable :: built
        character(len=32) :: line

        built = "one"//"-"//"two"
        write (line, '(a, " x", i0)') "world", 2

        call check(error, built, "one-two")
        call check(error, repeat("ab", 3), "ababab")
        call check(error, trim(line), "world x2")
    end subroutine test_building_text

    ! types and branching

    subroutine test_derived_type_copies(error)
        type(error_type), allocatable, intent(out) :: error
        type(point) :: origin, moved

        origin = point(1, 2)
        moved = origin
        moved%x = 5

        call check(error, moved%x, 5)
        call check(error, origin%x, 1)
        call check(error, origin%y, moved%y)
    end subroutine test_derived_type_copies

    !> Fortran 2018 has no enumeration type, so a fixed set of states is a set of
    !> integer parameters and the set itself is something you write down.
    subroutine test_named_states(error)
        type(error_type), allocatable, intent(out) :: error
        integer, parameter :: states(2) = [locked, unlocked]
        integer :: state

        state = unlocked

        call check(error, state, unlocked)
        call check(error, locked /= unlocked)
        call check(error, size(states), 2)
    end subroutine test_named_states

    !> SELECT CASE is a statement and not an expression, so every branch assigns
    !> to the same variable rather than the construct producing a value.
    subroutine test_branch_assigns(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=8) :: label

        select case (locked)
        case (locked)
            label = "locked"
        case (unlocked)
            label = "unlocked"
        end select

        call check(error, trim(label), "locked")

        select case (99)
        case (locked, unlocked)
            label = "known"
        case default
            label = "unknown"
        end select

        call check(error, trim(label), "unknown")
    end subroutine test_branch_assigns

    ! iteration

    subroutine test_loop_position(error)
        type(error_type), allocatable, intent(out) :: error
        integer, parameter :: values(4) = [1, 2, 3, 4]
        integer :: at, weighted

        weighted = 0
        do at = 1, size(values)
            weighted = weighted + at*values(at)
        end do

        call check(error, weighted, 30)
        call check(error, lbound(values, dim=1), 1)
    end subroutine test_loop_position

    subroutine test_lookahead(error)
        type(error_type), allocatable, intent(out) :: error
        integer, parameter :: values(4) = [1, 2, 4, 8]
        integer :: at, gaps(3)

        do at = 1, size(values) - 1
            gaps(at) = values(at + 1) - values(at)
        end do

        call check(error, gaps(1), 1)
        call check(error, gaps(3), 4)
        call check(error, sum(gaps), 7)
    end subroutine test_lookahead

    ! functions

    subroutine test_function_argument(error)
        type(error_type), allocatable, intent(out) :: error
        integer, parameter :: values(3) = [1, 2, 3]
        integer, allocatable :: mapped(:)

        mapped = apply(doubled, values)

        call check(error, mapped(1), 2)
        call check(error, mapped(3), 6)
        call check(error, sum(mapped), 12)
    end subroutine test_function_argument

    subroutine test_fold(error)
        type(error_type), allocatable, intent(out) :: error
        integer, parameter :: values(4) = [1, 2, 3, 4]

        call check(error, sum(values), 10)
        call check(error, product(values), 24)
        call check(error, maxval(values), 4)
    end subroutine test_fold

    ! errors

    !> Fortran reports failure through a status argument rather than by raising
    !> anything, and a read that cannot parse its input leaves the variable alone.
    subroutine test_status_argument(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=12) :: source
        integer :: value, status

        source = "42"
        read (source, *, iostat=status) value

        call check(error, status, 0)
        call check(error, value, 42)

        source = "not a number"
        read (source, *, iostat=status) value

        call check(error, status /= 0)
    end subroutine test_status_argument

    ! gotchas

    !> The hour this saves: a fixed-length string is blank-padded to its declared
    !> length, so LEN reports the declaration rather than the content. Comparison
    !> pads the shorter side as well, which is why the last assertion holds.
    subroutine test_blank_padding(error)
        type(error_type), allocatable, intent(out) :: error
        character(len=8) :: padded

        padded = "ab"

        call check(error, len(padded), 8)
        call check(error, len_trim(padded), 2)
        call check(error, padded == "ab")
    end subroutine test_blank_padding

    function apply(transform, values) result(mapped)
        procedure(mapper) :: transform
        integer, intent(in) :: values(:)
        integer, allocatable :: mapped(:)
        integer :: at

        allocate (mapped(size(values)))
        do at = 1, size(values)
            mapped(at) = transform(values(at))
        end do
    end function apply

    function doubled(value) result(mapped)
        integer, intent(in) :: value
        integer :: mapped

        mapped = value*2
    end function doubled

end module test_kitchen_sink

program test_kitchen_sink_runner
    use, intrinsic :: iso_fortran_env, only: error_unit
    use testdrive, only: run_testsuite
    use test_kitchen_sink, only: collect_kitchen_sink
    implicit none

    integer :: failures

    failures = 0
    call run_testsuite(collect_kitchen_sink, error_unit, failures)
    if (failures > 0) error stop
end program test_kitchen_sink_runner

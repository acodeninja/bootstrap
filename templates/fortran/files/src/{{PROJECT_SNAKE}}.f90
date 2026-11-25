! A module, and the name is referenced by every file that uses it -- the test
! beside this one says `use <project>`, so renaming the module means renaming
! that too. Comments are an exclamation mark to end of line; there is no block
! form. This is free-form source, so the column rules of punched-card Fortran
! do not apply -- but a continued line needs a trailing ampersand, and a comment
! cannot sit between a line and its continuation.
module {{PROJECT_SNAKE}}
    ! Two declarations that should be the first thing in every module you write.
    !
    ! `implicit none` turns off implicit typing, under which any undeclared
    ! variable whose name begins with I to N is an integer and everything else
    ! is a real. That rule is why a typo used to be a new variable rather than
    ! an error, and this line is what makes it an error.
    implicit none
    ! `private` makes everything in the module private by default, so visibility
    ! is opt-in rather than opt-out.
    private

    ! The opt-in. This is the whole export list.
    public :: greet

! Declarations above, procedure bodies below. `contains` is the divider, and
! everything after it is inside the module rather than beside it.
contains

    ! A function with a named result: `result(message)` says which variable
    ! holds the answer, so there is no `return` statement and nothing called
    ! after the function itself. A subroutine would be the other form --
    ! returning nothing and taking its outputs as arguments.
    function greet(name) result(message)
        ! Arguments and the result are declared in the body, not in the
        ! signature, which is the shape to get used to.
        !
        ! `len=*` means the length is taken from whatever the caller passed, and
        ! `intent(in)` promises not to assign to it -- intent is worth declaring
        ! on every argument, because the compiler checks it.
        character(len=*), intent(in) :: name
        ! `len=:` with `allocatable` is a string whose length is decided when it
        ! is assigned. Without allocatable a character variable has a fixed
        ! length and pads with blanks to fill it, which is the classic way to
        ! end up comparing "Hi" against "Hi                ".
        character(len=:), allocatable :: message

        ! // concatenates. It is two slashes, not an ampersand -- the ampersand
        ! is line continuation -- and there is no interpolation in the language.
        message = "Hello, "//name//"!"
    end function greet

end module {{PROJECT_SNAKE}}

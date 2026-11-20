module {{PROJECT_SNAKE}}
    implicit none
    private

    public :: greet

contains

    function greet(name) result(message)
        character(len=*), intent(in) :: name
        character(len=:), allocatable :: message

        message = "Hello, "//name//"!"
    end function greet

end module {{PROJECT_SNAKE}}

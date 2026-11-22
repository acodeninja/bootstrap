@Test
def a_greeting_addresses_the_name_it_is_given(): Unit \ Assert =
    let name = "world";

    let greeting = greet(name);

    Assert.assertEq(expected = "Hello, world!", greeting)

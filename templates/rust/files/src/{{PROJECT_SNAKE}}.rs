pub fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn a_greeting_addresses_the_name_it_is_given() {
        let name = "world";

        let greeting = greet(name);

        assert_eq!(greeting, "Hello, world!");
    }
}

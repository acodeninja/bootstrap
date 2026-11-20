let greets_by_name =
  Alcotest.test_case "a greeting addresses the name it is given" `Quick (fun () ->
      let name = "world" in

      let greeting = Greeter.greet name in

      Alcotest.(check string) "the name is addressed" "Hello, world!" greeting)

let suite = [ greets_by_name ]


#[no_mangle]
pub extern fn greet(name: String) -> String {
    return format!("Hello {}", name)
}

#[no_mangle]
pub extern "C" fn hello() {
    println!("Hello world")
}
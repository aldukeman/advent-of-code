use std::io::Read;

fn main() {
    let mut file = std::fs::File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut cal = 0;
    for line in contents.lines() {
        let mut val = 0;
        for c in line.chars() {
            if c.is_digit(10) {
                val = c.to_digit(10).unwrap();
                break;
            }
        }
  	val *= 10;
        for c in line.chars().rev() {
            if c.is_digit(10) {
                val += c.to_digit(10).unwrap();
                break;
            }
        }
        cal += val;
    }
    println!("{}", cal);
}

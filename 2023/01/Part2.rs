use std::io::Read;

fn find_number(line: &Vec<char>) -> Option<u32> {
  let line_str = line.iter().rev().cloned().collect::<String>();
  if line_str.starts_with("eno") {
     return Some(1);
  } else if line_str.starts_with("owt") {
     return Some(2);
  } else if line_str.starts_with("eerht") {
     return Some(3);
  } else if line_str.starts_with("ruof") {
     return Some(4);
  } else if line_str.starts_with("evif") {
     return Some(5);
  } else if line_str.starts_with("xis") {
     return Some(6);
  } else if line_str.starts_with("neves") {
     return Some(7);
  } else if line_str.starts_with("thgie") {
     return Some(8);
  } else if line_str.starts_with("enin") {
     return Some(9);
  }
  return None
}

fn parse_to_numbers(line: Vec<char>) -> Vec<u32> {
  let mut ret_vec: Vec<u32> = Vec::new();
  let mut so_far: Vec<char> = Vec::new();
  for c in line {
    if c.is_digit(10) {
      so_far= Vec::new();
      let val = c.to_digit(10).unwrap();
      ret_vec.push(val);
      continue;
    }

    so_far.push(c);
    if let Some(val) = find_number(&so_far) {
      ret_vec.push(val);
    }
  }
  return ret_vec;
}

fn main() {
    let mut file = std::fs::File::open("input.txt").unwrap();
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    let mut cal = 0;
    for line in contents.lines() {
        let numbers = parse_to_numbers(line.chars().collect());
        let mut val = numbers[0];
  	val *= 10;
        val += numbers.last().unwrap();
        cal += val;
    }
    println!("{}", cal);
}

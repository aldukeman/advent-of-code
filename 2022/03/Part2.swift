import Foundation

// We want an integer representation of the first character in each set
// Where C-style languages make the conversion automatically, Swift and
// other modern languages do not allow that
let capAValue = "A"
  // Convert the String to an array of the unicode values
  .unicodeScalars
  // Fetch the first value in the array as an optional and use '!' to 
  // tell Swift the value will always be there...if for some reason it 
  // isn't then the executable will crash
  .first!
  // Get the UInt32 representation of the Unicode value
  .value

// Same as above, but for "a"
let lowerAValue = "a".unicodeScalars.first!.value

// A set with all the integers from 1 to 52 inclusive
let allValues = Set<UInt32>(1...52)

// Initialize an empty array of UInt32 values. "var" keyword means we can 
// modify the array v.s. "let" used earlier means a constant
var badges = [UInt32]()

// Keep reading the file line-by-line until there's none left
while let firstLine = readLine() {
  // create an array of Optional<String> with the already read line and read two 
  // more lines
  let badge = [firstLine, readLine(), readLine()]
    // readLine returns an Optional<String>, but we want a String, so compactMap
    // will drop all nil values...assuming we have properly formatted input, this 
    // is really just a type conversion to String to make Swift happy
    .compactMap { $0 }
    // map and compactMap take lambdas, where the input values can be represented 
    // as $0, $1, etc., but in this case we name the only parameter line, because
    // I wanted to use $0 in the inner maps and variable shadowing doesn't work 
    // with $0 representation
    .map { line in
      // Similar to first lines in this file, we really want unicode representations
      // of this string
      line.unicodeScalars
        // jk...we really want integer representations of each character
        .map { $0.value }
        // Now we can compare against the capitalized or lower case versions
        .map { $0 >= lowerAValue ? $0 - lowerAValue : $0 - capAValue + 26 }
        // Add 1 because this math treats 'a' as 0 and the problem statement
        // wants it to be 1
        .map { $0 + 1 }
    }
    // So now we have a list of integers, but all we really care about is if there
    // are duplicates between the three packs, so throw them into a set
    .map { Set($0) }
    // Now we have three sets, so find the intersection between them using 
    // allValues as the initial value in the reduction
    .reduce(allValues) { $0.intersection($1) }

  // Now append the resulting array to our results array
  badges += badge
}

// Sum up all the values in the results array
print(badges.reduce(0,+))

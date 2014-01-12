# test gcd
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

gcd = erdos.gcd

describe "gcd", ->
  it "should find the greatest common divisor of two or more numbers", ->
    assert.equal gcd(12, 8), 4
    assert.equal gcd(8, 12), 4
    assert.equal gcd(8, -12), 4
    assert.equal gcd(-12, 8), 4
    assert.equal gcd(12, -8), 4
    assert.equal gcd(15, 3), 3
    assert.equal gcd(25, 15, -10, 30), 5

  it "should calculate gcd for edge cases around zero", ->
    assert.equal gcd(3, 0), 3
    assert.equal gcd(-3, 0), 3
    assert.equal gcd(0, 3), 3
    assert.equal gcd(0, -3), 3
    assert.equal gcd(0, 0), 0
    assert.equal gcd(1, 1), 1
    assert.equal gcd(1, 0), 1
    assert.equal gcd(1, -1), 1
    assert.equal gcd(-1, 1), 1
    assert.equal gcd(-1, 0), 1
    assert.equal gcd(-1, -1), 1
    assert.equal gcd(0, 1), 1
    assert.equal gcd(0, -1), 1
    assert.equal gcd(0, 0), 0

  it "should calculate gcd for edge cases with negative values", ->
    assert.deepEqual 1, gcd(2, 5)
    assert.deepEqual 1, gcd(2, -5)
    assert.deepEqual 1, gcd(-2, 5)
    assert.deepEqual 1, gcd(-2, -5)
    assert.deepEqual 2, gcd(2, 6)
    assert.deepEqual 2, gcd(2, -6)
    assert.deepEqual 2, gcd(-2, 6)
    assert.deepEqual 2, gcd(-2, -6)

  it "should calculate gcd for BigNumbers (downgrades to Number)", ->
    assert.equal gcd(erdos.bignumber(12), erdos.bignumber(8)), 4
    assert.equal gcd(erdos.bignumber(8), erdos.bignumber(12)), 4

  it "should calculate gcd for mixed BigNumbers to Numbers (downgrades to Number)", ->
    assert.equal gcd(erdos.bignumber(12), 8), 4
    assert.equal gcd(8, erdos.bignumber(12)), 4

  it "should find the greatest common divisor of booleans", ->
    assert.equal gcd(true, true), 1
    assert.equal gcd(true, false), 1
    assert.equal gcd(false, true), 1
    assert.equal gcd(false, false), 0

  it "should throw an error if only one argument", ->
    assert.throws (->
      gcd 1
    ), SyntaxError, "Wrong number of arguments in function gcd (3 provided, 1-2 expected)"

  it "should throw an error with complex numbers", ->
    assert.throws (->
      gcd erdos.complex(1, 3), 2
    ), erdos.error.UnsupportedTypeErrorTypeError, "Function gcd(complex, number) not supported"

  it "should throw an error with strings", ->
    assert.throws (->
      gcd "a", 2
    ), erdos.error.UnsupportedTypeErrorTypeError, "Function gcd(string, number) not supported"
    
    assert.throws (->
      gcd 2, "a"
    ), erdos.error.UnsupportedTypeErrorTypeError, "Function gcd(number, string) not supported"

  it "should throw an error with units", ->
    assert.throws (->
      gcd erdos.unit("5cm"), 2
    ), erdos.error.UnsupportedTypeErrorTypeError, "Function gcd(unit, number) not supported"

  it "should find the greatest common divisor element-wise in a matrix", ->
    assert.deepEqual gcd([5, 2, 3], [25, 3, 6]), [5, 1, 3]

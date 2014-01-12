# test xgcd
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

gcd = erdos.gcd
xgcd = erdos.xgcd

describe "xgcd", ->
  it "should return extended greatest common divisor of two numbers", ->
    
    # xgcd(36163, 21199) = 1247 => -7(36163) + 12(21199) = 1247
    assert.deepEqual [1247, -7, 12], xgcd(36163, 21199)
    
    # xgcd(120, 23) = 1 => -9(120) + 47(23) = 1
    assert.deepEqual [1, -9, 47], xgcd(120, 23)
    
    # some unit tests from: https://github.com/sjkaliski/numbers.js/blob/master/test/basic.test.js
    assert.deepEqual [5, -3, 5], xgcd(65, 40)
    assert.deepEqual [5, 5, -3], xgcd(40, 65)
    assert.deepEqual [21, -16, 27], xgcd(1239, 735)
    assert.deepEqual [21, 5, -2], xgcd(105, 252)
    assert.deepEqual [21, -2, 5], xgcd(252, 105)

  it "should calculate xgcd for edge cases around zero", ->
    assert.deepEqual [3, 1, 0], xgcd(3, 0)
    assert.deepEqual [3, -1, 0], xgcd(-3, 0)
    assert.deepEqual [3, 0, 1], xgcd(0, 3)
    assert.deepEqual [3, 0, -1], xgcd(0, -3)
    assert.deepEqual [1, 0, 1], xgcd(1, 1)
    assert.deepEqual [1, 1, 0], xgcd(1, 0)
    assert.deepEqual [1, 0, -1], xgcd(1, -1)
    assert.deepEqual [1, 0, 1], xgcd(-1, 1)
    assert.deepEqual [1, -1, 0], xgcd(-1, 0)
    assert.deepEqual [1, 0, -1], xgcd(-1, -1)
    assert.deepEqual [1, 0, 1], xgcd(0, 1)
    assert.deepEqual [1, 0, -1], xgcd(0, -1)
    assert.deepEqual [0, 0, 0], xgcd(0, 0)

  it "should calculate xgcd for BigNumbers (downgrades to Number)", ->
    assert.deepEqual xgcd(erdos.bignumber(65), erdos.bignumber(40)), [5, -3, 5]
    assert.deepEqual xgcd(erdos.bignumber(65), erdos.bignumber(40)), [5, -3, 5]

  it "should calculate xgcd for mixed BigNumbers to Numbers (downgrades to Number)", ->
    assert.deepEqual xgcd(erdos.bignumber(65), 40), [5, -3, 5]
    assert.deepEqual xgcd(65, erdos.bignumber(40)), [5, -3, 5]

  it.skip "should calculate xgcd for edge cases with negative values", ->
    assert.deepEqual [1, -2, 1], xgcd(2, 5)
    assert.deepEqual [1, -2, -1], xgcd(2, -5)
    assert.deepEqual [1, 2, 1], xgcd(-2, 5)
    assert.deepEqual [1, 2, -1], xgcd(-2, -5)
    assert.deepEqual [2, 1, 0], xgcd(2, 6)
    assert.deepEqual [2, 1, 0], xgcd(2, -6)
    assert.deepEqual [2, -1, 0], xgcd(-2, 6)
    assert.deepEqual [2, -1, 0], xgcd(-2, -6)

  it "should find the greatest common divisor of booleans", ->
    assert.deepEqual [1, 0, 1], xgcd(true, true)
    assert.deepEqual [1, 1, 0], xgcd(true, false)
    assert.deepEqual [1, 0, 1], xgcd(false, true)
    assert.deepEqual [0, 0, 0], xgcd(false, false)

  it "should give same results as gcd", ->
    assert.equal gcd(1239, 735), xgcd(1239, 735)[0]
    assert.equal gcd(105, 252), xgcd(105, 252)[0]
    assert.equal gcd(7, 13), xgcd(7, 13)[0]

  it "should throw an error if used with wrong number of arguments", ->
    assert.throws ->
      xgcd 1

    assert.throws ->
      xgcd 1, 2, 3

  it "should throw an error when used with a complex number", ->
    assert.throws (->
      xgcd erdos.complex(1, 3), 2
    ), erdos.error.UnsupportedTypeError, "Function xgcd(complex, number) not supported"

  it "should throw an error when used with a string", ->
    assert.throws (->
      xgcd "a", 2
    ), erdos.error.UnsupportedTypeError, "Function xgcd(string, number) not supported"

    assert.throws (->
      xgcd 2, "a"
    ), erdos.error.UnsupportedTypeError, "Function xgcd(number, string) not supported"

  it "should throw an error when used with a unit", ->
    assert.throws (->
      xgcd erdos.unit("5cm"), 2
    ), erdos.error.UnsupportedTypeError, "Function xgcd(unit, number) not supported"

  it "should throw an error when used with a matrix", ->
    assert.throws (->
      xgcd [5, 2, 3], [25, 3, 6]
    ), erdos.error.UnsupportedTypeError, "Function xgcd(array, array) not supported"

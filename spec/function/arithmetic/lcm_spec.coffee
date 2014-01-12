assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

lcm = erdos.lcm

describe "lcm", ->
  it "should find the lowest common multiple of two or more numbers", ->
    assert.equal lcm(4, 6), 12
    assert.equal lcm(4, -6), 12
    assert.equal lcm(6, 4), 12
    assert.equal lcm(-6, 4), 12
    assert.equal lcm(-6, -4), 12
    assert.equal lcm(21, 6), 42
    assert.equal lcm(3, -4, 24), 24
    assert.throws (->
      lcm 1
    ), SyntaxError, "Wrong number of arguments in function lcm (3 provided, 1-2 expected)"

  it "should calculate lcm for edge cases around zero", ->
    assert.equal lcm(3, 0), 0
    assert.equal lcm(-3, 0), 0
    assert.equal lcm(0, 3), 0
    assert.equal lcm(0, -3), 0
    assert.equal lcm(0, 0), 0
    assert.equal lcm(1, 1), 1
    assert.equal lcm(1, 0), 0
    assert.equal lcm(1, -1), 1
    assert.equal lcm(-1, 1), 1
    assert.equal lcm(-1, 0), 0
    assert.equal lcm(-1, -1), 1
    assert.equal lcm(0, 1), 0
    assert.equal lcm(0, -1), 0
    assert.equal lcm(0, 0), 0

  it "should calculate lcm for BigNumbers (downgrades to Number)", ->
    assert.equal lcm(erdos.bignumber(4), erdos.bignumber(6)), 12
    assert.equal lcm(erdos.bignumber(4), erdos.bignumber(6)), 12

  it "should calculate lcm for mixed BigNumbers to Numbers (downgrades to Number)", ->
    assert.equal lcm(erdos.bignumber(4), 6), 12
    assert.equal lcm(4, erdos.bignumber(6)), 12

  it "should find the lowest common multiple of booleans", ->
    assert.equal lcm(true, true), 1
    assert.equal lcm(true, false), 0
    assert.equal lcm(false, true), 0
    assert.equal lcm(false, false), 0

  it "should throw an error with complex numbers", ->
    assert.throws (->
      lcm erdos.complex(1, 3), 2
    ), erdos.error.UnsupportedTypeError, "Function lcm(complex, number) not supported"

  it "should throw an error with strings", ->
    assert.throws (->
      lcm "a", 2
    ), erdos.error.UnsupportedTypeError, "Function lcm(string, number) not supported"
   
    assert.throws (->
      lcm 2, "a"
    ), erdos.error.UnsupportedTypeError, "Function lcm(number, string) not supported"

  it "should throw an error with units", ->
    assert.throws (->
      lcm erdos.unit("5cm"), 2
    ), erdos.error.UnsupportedTypeError, "Function lcm(unit, number) not supported"

  it "should perform element-wise lcm on two or more matrices of the same size", ->
    assert.deepEqual lcm([5, 2, 3], [25, 3, 6]), [25, 6, 6]

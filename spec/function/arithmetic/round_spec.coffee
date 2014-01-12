# test round
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
round = erdos.round

describe "round", ->
  it "should round a number to te given number of decimals", ->
    approx.equal round(erdos.pi), 3
    approx.equal round(erdos.pi * 1000), 3142
    approx.equal round(erdos.pi, 3), 3.142
    approx.equal round(erdos.pi, 6), 3.141593
    approx.equal round(1234.5678, 2), 1234.57

  it "should round booleans (yeah, not really useful but it should be supported)", ->
    approx.equal round(true, 2), 1
    approx.equal round(false, 2), 0

  it "should throw an error on invalid type of n", ->
    assert.throws (->
      round erdos.pi, true
    ), TypeError
  
  # TODO: also test other types
  it "should throw an error if used with wrong number of arguments", ->
    assert.throws (->
      round()
    ), SyntaxError, "Wrong number of arguments in function round (3 provided, 1-2 expected)"
    assert.throws (->
      round 1, 2, 3
    ), SyntaxError, "Wrong number of arguments in function round (3 provided, 1-2 expected)"

  it "should round bignumbers", ->
    assert.deepEqual round(bignumber(2.7)), bignumber(3)
    assert.deepEqual round(bignumber(2.1)), bignumber(2)
    assert.deepEqual round(bignumber(2.123456), bignumber(3)), bignumber(2.123)
    assert.deepEqual round(bignumber(2.123456), 3), bignumber(2.123)
    assert.deepEqual round(2.1234567, bignumber(3)), 2.123
    assert.deepEqual round(true, bignumber(3)), 1

  it "should round real and imag part of a complex number", ->
    assert.deepEqual round(erdos.complex(2.2, erdos.pi)), erdos.complex(2, 3)

  it "should round a complex number with a bignumber as number of decimals", ->
    assert.deepEqual round(erdos.complex(2.157, erdos.pi), bignumber(2)), erdos.complex(2.16, 3.14)

  it "should throw an error if used with a unit", ->
    assert.throws (->
      round erdos.unit("5cm")
    ), erdos.error.UnsupportedTypeError, "Function round(unit) not supported"

    assert.throws (->
      round erdos.unit("5cm"), 2
    ), erdos.error.UnsupportedTypeError, "Function round(unit) not supported"

    assert.throws (->
      round erdos.unit("5cm"), bignumber(2)
    ), erdos.error.UnsupportedTypeError, "Function round(unit) not supported"

  it "should throw an error if used with a string", ->
    assert.throws (->
      round "hello world"
    ), erdos.error.UnsupportedTypeError, "Function round(unit) not supported"
    

  it "should round each element in a matrix, array, range", ->
    assert.deepEqual round(erdos.range(0, 2.1, 1 / 3), 2), erdos.matrix([0, 0.33, 0.67, 1, 1.33, 1.67, 2])
    assert.deepEqual round(erdos.range(0, 2.1, 1 / 3)), erdos.matrix([0, 0, 1, 1, 1, 2, 2])
    assert.deepEqual round([1.7, 2.3]), [2, 2]
    assert.deepEqual round(erdos.matrix([1.7, 2.3])).valueOf(), [2, 2]

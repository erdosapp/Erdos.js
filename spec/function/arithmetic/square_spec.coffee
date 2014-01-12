# test square
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

unit = erdos.unit
bignumber = erdos.bignumber
matrix = erdos.matrix
range = erdos.range
square = erdos.square

describe "square", ->
  it "should return the square of a boolean", ->
    assert.equal square(true), 1
    assert.equal square(false), 0

  it "should return the square of a number", ->
    assert.equal square(4), 16
    assert.equal square(-2), 4
    assert.equal square(0), 0

  it "should return the cube of a big number", ->
    assert.deepEqual square(bignumber(4)), bignumber(16)
    assert.deepEqual square(bignumber(-2)), bignumber(4)
    assert.deepEqual square(bignumber(0)), bignumber(0)

  it "should throw an error if used with wrong number of arguments", ->
    assert.throws (->
      square()
    ), SyntaxError, "Wrong number of arguments in function square (0 provided, 1 expected)"
    assert.throws (->
      square 1, 2
    ), SyntaxError, "Wrong number of arguments in function square (2 provided, 1 expected)"

  it "should return the square of a complex number", ->
    assert.deepEqual square(erdos.complex("2i")), erdos.complex("-4")
    assert.deepEqual square(erdos.complex("2+3i")), erdos.complex("-5+12i")
    assert.deepEqual square(erdos.complex("2")), erdos.complex("4")

  it "should throw an error when used with a unit", ->
    assert.throws ->
      square unit("5cm")

  it "should throw an error when used with a string", ->
    assert.throws ->
      square "text"

  it "should return the square of each element in a matrix", ->
    assert.deepEqual square([2, 3, 4, 5]), [4, 9, 16, 25]
    assert.deepEqual square(matrix([2, 3, 4, 5])), matrix([4, 9, 16, 25])
    assert.deepEqual square(matrix([[1, 2], [3, 4]])), matrix([[1, 4], [9, 16]])

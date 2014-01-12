# test cube
assert = require("chai").assert
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

unit      = erdos.unit
bignumber = erdos.bignumber
matrix    = erdos.matrix
range     = erdos.range
cube      = erdos.cube

describe "cube", ->
  it "should return the cube of a boolean", ->
    assert.equal cube(true), 1
    assert.equal cube(false), 0

  it "should return the cube of a number", ->
    assert.equal cube(4), 64
    assert.equal cube(-2), -8
    assert.equal cube(0), 0

  it "should return the cube of a big number", ->
    assert.deepEqual cube(bignumber(4)), bignumber(64)
    assert.deepEqual cube(bignumber(-2)), bignumber(-8)
    assert.deepEqual cube(bignumber(0)), bignumber(0)

  it "should return the cube of a complex number", ->
    assert.deepEqual cube(erdos.complex("2i")), erdos.complex("-8i")
    assert.deepEqual cube(erdos.complex("2+3i")), erdos.complex("-46+9i")
    assert.deepEqual cube(erdos.complex("2")), erdos.complex("8")

  it "should throw an error with strings", ->
    assert.throws ->
      cube "text"

  it "should throw an error with units", ->
    assert.throws ->
      cube unit("5cm")

  it "should throw an error if there's wrong number of args", ->
    assert.throws (->
      cube()
    ), SyntaxError, "Wrong number of arguments in function cube (0 provided, 1 expected)"
    assert.throws (->
      cube 1, 2
    ), SyntaxError, "Wrong number of arguments in function cube (2 provided, 1 expected)"

  it "should cube each element in a matrix, array or range", -> 
    # array, matrix, range
    # arrays are evaluated element wise
    assert.deepEqual cube([2, 3, 4, 5]), [8, 27, 64, 125]
    assert.deepEqual cube(matrix([2, 3, 4, 5])), matrix([8, 27, 64, 125])
    assert.deepEqual cube(matrix([[1, 2], [3, 4]])), matrix([[1, 8], [27, 64]])

# test edivide (element-wise divide)
assert = require("chai").assert
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

edivide = erdos.edivide
complex = erdos.complex

describe "edivide", ->
  it "should divide two numbers", ->
    assert.equal edivide(4, 2), 2
    assert.equal edivide(-4, 2), -2
    assert.equal edivide(4, -2), -2
    assert.equal edivide(-4, -2), 2
    assert.equal edivide(4, 0), Infinity
    assert.equal edivide(0, -5), 0
    assert.ok isNaN(edivide(0, 0))

  it "should divide booleans", ->
    assert.equal edivide(true, true), 1
    assert.equal edivide(true, false), Infinity
    assert.equal edivide(false, true), 0
    assert.ok isNaN(edivide(false, false))

  it "should add mixed numbers and booleans", ->
    assert.equal edivide(2, true), 2
    assert.equal edivide(2, false), Infinity
    approx.equal edivide(true, 2), 0.5
    assert.equal edivide(false, 2), 0

  it "should throw an error if there's wrong number of arguments", ->
    assert.throws ->
      edivide 2, 3, 4

    assert.throws ->
      edivide 2

  it "should divide two complex numbers", ->
    approx.deepEqual edivide(complex("2+3i"), 2), complex("1+1.5i")
    approx.deepEqual edivide(complex("2+3i"), complex("4i")), complex("0.75 - 0.5i")
    approx.deepEqual edivide(complex("2i"), complex("4i")), 0.5
    approx.deepEqual edivide(4, complex("1+2i")), complex("0.8 - 1.6i")

  it "should divide a unit by a number", ->
    assert.equal edivide(erdos.unit("5 m"), 10).toString(), "500 mm"

  it "should throw an error if dividing a number by a unit", ->
    assert.throws ->
      edivide(10, erdos.unit("5 m")).toString()

  it "should divide all the elements of a matrix by one number", ->
    assert.deepEqual edivide([2, 4, 6], 2), [1, 2, 3]
    a = erdos.matrix([[1, 2], [3, 4]])
    assert.deepEqual edivide(a, 2), erdos.matrix([[0.5, 1], [1.5, 2]])
    assert.deepEqual edivide(a.valueOf(), 2), [[0.5, 1], [1.5, 2]]
    assert.deepEqual edivide([], 2), []
    assert.deepEqual edivide([], 2), []

  it "should divide 1 over a matrix element-wise", ->
    approx.deepEqual erdos.format(edivide(1, [[1, 4, 7], [3, 0, 5], [-1, 9, 11]])), erdos.format([[1, 0.25, 1 / 7], [1 / 3, Infinity, 0.2], [-1, 1 / 9, 1 / 11]])

  it "should perform matrix element-wise matrix division", ->
    a = erdos.matrix([[1, 2], [3, 4]])
    b = erdos.matrix([[5, 6], [7, 8]])
    assert.deepEqual edivide(a, b), erdos.matrix([[1 / 5, 2 / 6], [3 / 7, 4 / 8]])

  it "should throw an error when dividing element-wise by a matrix with differing size", ->
    assert.throws ->
      edivide a, [[1]]

# test abs
assert = require("assert")
erdos  = require("../../../lib/erdos")()

describe "abs", ->
  it "should return the abs value of a boolean", ->
    assert.equal erdos.abs(true), 1
    assert.equal erdos.abs(false), 0

  it "should return the abs value of a number", ->
    assert.equal erdos.abs(-4.2), 4.2
    assert.equal erdos.abs(-3.5), 3.5
    assert.equal erdos.abs(100), 100
    assert.equal erdos.abs(0), 0

  it "should return the absolute value of a big number", ->
    assert.deepEqual erdos.abs(erdos.bignumber(-2.3)), erdos.bignumber(2.3)
    assert.deepEqual erdos.abs(erdos.bignumber("5e500")), erdos.bignumber("5e500")
    assert.deepEqual erdos.abs(erdos.bignumber("-5e500")), erdos.bignumber("5e500")

  it "should return the absolute value of a complex number", ->
    assert.equal erdos.abs(erdos.complex(3, -4)), 5

  it "should return the absolute value of all elements in a matrix", ->
    a1 = erdos.abs(erdos.matrix([1, -2, 3]))
    assert.ok a1 instanceof erdos.Matrix
    assert.deepEqual a1.size(), [3]
    assert.deepEqual a1.valueOf(), [1, 2, 3]
    a1 = erdos.abs(erdos.matrix([-2, -1, 0, 1, 2]))
    assert.ok a1 instanceof erdos.Matrix
    assert.deepEqual a1.size(), [5]
    assert.deepEqual a1.valueOf(), [2, 1, 0, 1, 2]

  it "should throw an error with a measurment unit", ->
    assert.throws ->
      erdos.abs erdos.unit(5, "km")

  it "should throw an error with a string", ->
    assert.throws ->
      erdos.abs "a string"

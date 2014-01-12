assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

factorial = erdos.factorial

describe "factorial", ->
  it "should calculate the factorial of a number", ->
    assert.equal factorial(0), 1
    assert.equal factorial(1), 1
    assert.equal factorial(2), 2
    assert.equal factorial(3), 6
    assert.equal factorial(4), 24
    assert.equal factorial(5), 120

  it "should calculate the factorial of a bignumber", ->
    assert.deepEqual factorial(erdos.bignumber(0)), erdos.bignumber(1)
    assert.deepEqual factorial(erdos.bignumber(1)), erdos.bignumber(1)
    assert.deepEqual factorial(erdos.bignumber(2)), erdos.bignumber(2)
    assert.deepEqual factorial(erdos.bignumber(3)), erdos.bignumber(6)
    assert.deepEqual factorial(erdos.bignumber(4)), erdos.bignumber(24)
    assert.deepEqual factorial(erdos.bignumber(5)), erdos.bignumber(120)
    assert.deepEqual factorial(erdos.bignumber(20)), erdos.bignumber("2432902008176640000")

  it "should calculate the factorial of a boolean", ->
    assert.equal factorial(true), 1
    assert.equal factorial(false), 1

  it "should calculate the factorial of each element in a matrix", ->
    assert.deepEqual factorial(erdos.matrix([0, 1, 2, 3, 4, 5])), erdos.matrix([1, 1, 2, 6, 24, 120])

  it "should calculate the factorial of each element in an array", ->
    assert.deepEqual factorial([0, 1, 2, 3, 4, 5]), [1, 1, 2, 6, 24, 120]

  it "should throw an error if called with negative number", ->
    assert.throws ->
      factorial -1

  it "should throw an error if called with non-integer number", ->
    assert.throws ->
      factorial 1.5

  it "should throw en error if called with invalid number of arguments", ->
    assert.throws ->
      factorial()

    assert.throws ->
      factorial 1, 3

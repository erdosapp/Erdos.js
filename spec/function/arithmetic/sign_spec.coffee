# test sign
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber

describe "sign", ->
  it "should calculate the sign of a boolean", ->
    assert.equal erdos.sign(true), 1
    assert.equal erdos.sign(false), 0

  it "should calculate the sign of a number", ->
    assert.equal erdos.sign(3), 1
    assert.equal erdos.sign(-3), -1
    assert.equal erdos.sign(0), 0

  it "should calculate the sign of a big number", ->
    assert.deepEqual erdos.sign(bignumber(3)), bignumber(1)
    assert.deepEqual erdos.sign(bignumber(-3)), bignumber(-1)
    assert.deepEqual erdos.sign(bignumber(0)), bignumber(0)

  it "should calculate the sign of a complex value", ->
    approx.deepEqual erdos.sign(erdos.complex(2, -3)), erdos.complex(0.554700196225229, -0.832050294337844)

  it "should throw an error when used with a unit", ->
    assert.throws ->
      erdos.sign erdos.unit("5cm")

  it "should throw an error when used with a string", ->
    assert.throws ->
      erdos.sign "hello world"

  it "should return a matrix of the signs of each elements in the given array", ->
    assert.deepEqual erdos.sign([-2, -1, 0, 1, 2]), [-1, -1, 0, 1, 1]

  it "should return a matrix of the signs of each elements in the given matrix", ->
    assert.deepEqual erdos.sign(erdos.matrix([-2, -1, 0, 1, 2])), erdos.matrix([-1, -1, 0, 1, 1])

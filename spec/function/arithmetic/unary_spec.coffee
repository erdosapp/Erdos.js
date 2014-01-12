# test unary minus
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber

describe "unaryminus", ->
  it "should parform unary minus of a boolean", ->
    assert.equal erdos.unary(true), -1
    assert.equal erdos.unary(false), 0

  it "should perform unary minus of a number", ->
    assert.deepEqual erdos.unary(2), -2
    assert.deepEqual erdos.unary(-2), 2
    assert.deepEqual erdos.unary(0), 0

  it "should perform unary minus of a big number", ->
    assert.deepEqual erdos.unary(bignumber(2)), bignumber(-2)
    assert.deepEqual erdos.unary(bignumber(-2)), bignumber(2)
    assert.deepEqual erdos.unary(bignumber(0)).valueOf(), bignumber(0).valueOf()

  it "should perform unary minus of a complex number", ->
    assert.equal erdos.unary(erdos.complex(3, 2)), "-3 - 2i"
    assert.equal erdos.unary(erdos.complex(3, -2)), "-3 + 2i"
    assert.equal erdos.unary(erdos.complex(-3, 2)), "3 - 2i"
    assert.equal erdos.unary(erdos.complex(-3, -2)), "3 + 2i"

  it "should perform unary minus of a unit", ->
    assert.equal erdos.unary(erdos.unit(5, "km")).toString(), "-5 km"

  it "should throw an error when used with a string", ->
    assert.throws ->
      Erdos.subtract "hello ", "world"

    assert.throws ->
      Erdos.subtract "str", 123

    assert.throws ->
      Erdos.subtract 123, "str"

  it "should perform element-wise unary minus on a matrix", ->
    a2 = erdos.matrix([[1, 2], [3, 4]])
    a7 = erdos.unary(a2)
    assert.ok a7 instanceof erdos.Matrix
    assert.deepEqual a7.size(), [2, 2]
    assert.deepEqual a7.valueOf(), [[-1, -2], [-3, -4]]
    assert.deepEqual erdos.unary([[1, 2], [3, 4]]), [[-1, -2], [-3, -4]]

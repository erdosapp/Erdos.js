# test divide
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

divide    = erdos.divide
bignumber = erdos.bignumber
complex   = erdos.complex

describe "divide", ->
  it "should divide two numbers", ->
    assert.equal divide(4, 2), 2
    assert.equal divide(-4, 2), -2
    assert.equal divide(4, -2), -2
    assert.equal divide(-4, -2), 2
    assert.equal divide(4, 0), Infinity
    assert.equal divide(-4, 0), -Infinity
    assert.equal divide(0, -5), 0
    assert.ok isNaN(divide(0, 0))

  it "should divide booleans", ->
    assert.equal divide(true, true), 1
    assert.equal divide(true, false), Infinity
    assert.equal divide(false, true), 0
    assert.ok isNaN(divide(false, false))

  it "should divide mixed numbers and booleans", ->
    assert.equal divide(2, true), 2
    assert.equal divide(2, false), Infinity
    approx.equal divide(true, 2), 0.5
    assert.equal divide(false, 2), 0

  it "should divide bignumbers", ->
    assert.deepEqual divide(bignumber(0.3), bignumber(0.2)), bignumber(1.5)
    assert.deepEqual divide(bignumber("2.6e5000"), bignumber("2")), bignumber("1.3e5000")

  it "should divide mixed numbers and bignumbers", ->
    assert.deepEqual divide(bignumber(0.3), 0.2), bignumber(1.5)
    assert.deepEqual divide(0.3, bignumber(0.2)), bignumber(1.5)
    assert.deepEqual divide(bignumber("2.6e5000"), 2), bignumber("1.3e5000")
    approx.equal divide(1 / 3, bignumber(2)), 0.166666666666667
    approx.equal divide(bignumber(1), 1 / 3), 3
 
  it "should divide two complex numbers", ->
    approx.deepEqual divide(complex("2+3i"), 2), complex("1+1.5i")
    approx.deepEqual divide(complex("2+3i"), complex("4i")), complex("0.75 - 0.5i")
    approx.deepEqual divide(complex("2i"), complex("4i")), complex("0.5")
    approx.deepEqual divide(4, complex("1+2i")), complex("0.8 - 1.6i")
    approx.deepEqual divide(erdos.i, 0), complex(0, Infinity)
    approx.deepEqual divide(complex(0, 1), 0), complex(0, Infinity)
    approx.deepEqual divide(complex(1, 0), 0), complex(Infinity, 0)
    approx.deepEqual divide(complex(0, 1), complex(0, 0)), complex(0, Infinity)
    approx.deepEqual divide(complex(1, 1), complex(0, 0)), complex(Infinity, Infinity)
    approx.deepEqual divide(complex(1, -1), complex(0, 0)), complex(Infinity, -Infinity)
    approx.deepEqual divide(complex(-1, 1), complex(0, 0)), complex(-Infinity, Infinity)
    approx.deepEqual divide(complex(1, 1), complex(0, 1)), complex(1, -1)
    approx.deepEqual divide(complex(1, 1), complex(1, 0)), complex(1, 1)
    approx.deepEqual divide(complex(2, 3), complex(4, 5)), complex("0.5609756097560976 + 0.0487804878048781i")
    approx.deepEqual divide(complex(2, 3), complex(4, -5)), complex("-0.170731707317073 + 0.536585365853659i")
    approx.deepEqual divide(complex(2, 3), complex(-4, 5)), complex("0.170731707317073 - 0.536585365853659i")
    approx.deepEqual divide(complex(2, 3), complex(-4, -5)), complex("-0.5609756097560976 - 0.0487804878048781i")
    approx.deepEqual divide(complex(2, -3), complex(4, 5)), complex("-0.170731707317073 - 0.536585365853659i")
    approx.deepEqual divide(complex(2, -3), complex(4, -5)), complex("0.5609756097560976 - 0.0487804878048781i")
    approx.deepEqual divide(complex(2, -3), complex(-4, 5)), complex("-0.5609756097560976 + 0.0487804878048781i")
    approx.deepEqual divide(complex(2, -3), complex(-4, -5)), complex("0.170731707317073 + 0.536585365853659i")
    approx.deepEqual divide(complex(-2, 3), complex(4, 5)), complex("0.170731707317073 + 0.536585365853659i")
    approx.deepEqual divide(complex(-2, 3), complex(4, -5)), complex("-0.5609756097560976 + 0.0487804878048781i")
    approx.deepEqual divide(complex(-2, 3), complex(-4, 5)), complex("0.5609756097560976 - 0.0487804878048781i")
    approx.deepEqual divide(complex(-2, 3), complex(-4, -5)), complex("-0.170731707317073 - 0.536585365853659i")
    approx.deepEqual divide(complex(-2, -3), complex(4, 5)), complex("-0.5609756097560976 - 0.0487804878048781i")
    approx.deepEqual divide(complex(-2, -3), complex(4, -5)), complex("0.170731707317073 - 0.536585365853659i")
    approx.deepEqual divide(complex(-2, -3), complex(-4, 5)), complex("-0.170731707317073 + 0.536585365853659i")
    approx.deepEqual divide(complex(-2, -3), complex(-4, -5)), complex("0.5609756097560976 + 0.0487804878048781i")

  it "should divide mixed complex numbers and numbers", ->
    assert.deepEqual divide(erdos.complex(6, -4), 2), erdos.complex(3, -2)
    assert.deepEqual divide(1, erdos.complex(2, 4)), erdos.complex(0.1, -0.2)
  
  it "should divide mixed complex numbers and bignumbers", ->
    assert.deepEqual divide(erdos.complex(6, -4), bignumber(2)), erdos.complex(3, -2)
    assert.deepEqual divide(bignumber(1), erdos.complex(2, 4)), erdos.complex(0.1, -0.2)
  
  it "should divide units by a number", ->
    assert.equal divide(erdos.unit("5 m"), 10).toString(), "500 mm"

  it "should divide units by a big number", ->
    assert.equal divide(erdos.unit("5 m"), bignumber(10)).toString(), "500 mm"

  it "should divide each elements in a matrix by a number", ->
    assert.deepEqual divide([2, 4, 6], 2), [1, 2, 3]
    a = erdos.matrix([[1, 2], [3, 4]])
    assert.deepEqual divide(a, 2), erdos.matrix([[0.5, 1], [1.5, 2]])
    assert.deepEqual divide(a.valueOf(), 2), [[0.5, 1], [1.5, 2]]
    assert.deepEqual divide([], 2), []
    assert.deepEqual divide([], 2), []

  it "should divide 1 over a matrix (matrix inverse)", ->
    approx.deepEqual(divide(1, [
       [ 1, 4,  7],
       [ 3, 0,  5],
       [-1, 9, 11]
    ]), 
    [ 
      [ 5.625, -2.375, -2.5],
      [ 4.75,  -2.25,  -2],
      [-3.375,  1.625,  1.5]
    ])
 
  it "should perform matrix division", ->
    a = erdos.matrix([[1, 2], [3, 4]])
    b = erdos.matrix([[5, 6], [7, 8]])
    divide(a, b)

  it "should divide a matrix by a matrix containing a scalar", ->
    assert.throws ->
      divide a, [[1]]
 
  it "should throw an error if dividing a number by a unit", ->
    assert.throws ->
      divide(10, erdos.unit("5 m")).toString()
 
  it "should throw an error if there's wrong number of arguments", ->
    assert.throws ->
      divide 2, 3, 4
 
    assert.throws ->
      divide 2

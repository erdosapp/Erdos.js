# test multiply
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

multiply = erdos.multiply
divide = erdos.divide
matrix = erdos.matrix
complex = erdos.complex
bignumber = erdos.bignumber
range = erdos.range
i = erdos.i
unit = erdos.unit

describe "multiply", ->
  it "should multiply two numbers correctly", ->
    approx.equal multiply(2, 3), 6
    approx.equal multiply(-2, 3), -6
    approx.equal multiply(-2, -3), 6
    approx.equal multiply(5, 0), 0
    approx.equal multiply(0, 5), 0
    approx.deepEqual multiply(0, Infinity), NaN
    approx.deepEqual multiply(2, Infinity), Infinity
    approx.deepEqual multiply(-2, Infinity), -Infinity

  it "should multiply booleans", ->
    assert.equal multiply(true, true), 1
    assert.equal multiply(true, false), 0
    assert.equal multiply(false, true), 0
    assert.equal multiply(false, false), 0

  it "should multiply mixed numbers and booleans", ->
    assert.equal multiply(2, true), 2
    assert.equal multiply(2, false), 0
    assert.equal multiply(true, 2), 2
    assert.equal multiply(false, 2), 0

  it "should multiply bignumbers", ->
    assert.deepEqual multiply(bignumber(1.5), bignumber(0.2)), bignumber(0.3)
    assert.deepEqual multiply(bignumber("1.3e5000"), bignumber("2")), bignumber("2.6e5000")

  it "should multiply mixed numbers and bignumbers", ->
    assert.deepEqual multiply(bignumber(1.5), 0.2), bignumber(0.3)
    assert.deepEqual multiply(1.5, bignumber(0.2)), bignumber(0.3)
    assert.deepEqual multiply(bignumber("1.3e5000"), 2), bignumber("2.6e5000")
    approx.equal multiply(1 / 3, bignumber(1).div(3)), 1 / 9
    approx.equal multiply(bignumber(1).div(3), 1 / 3), 1 / 9

  it "should multiply mixed booleans and bignumbers", ->
    assert.deepEqual multiply(bignumber(0.3), bignumber(true)), bignumber(0.3)
    assert.deepEqual multiply(false, bignumber("2")), bignumber(0)

  it "should multiply two complex numbers correctly", ->
    approx.deepEqual multiply(complex(2, 3), 2), complex(4, 6)
    approx.deepEqual multiply(complex(2, -3), -2), complex(-4, 6)
    approx.deepEqual multiply(complex(2, -3), 2), complex(4, -6)
    approx.deepEqual multiply(complex(-2, 3), 2), complex(-4, 6)
    approx.deepEqual multiply(complex(-2, -3), 2), complex(-4, -6)
    approx.deepEqual multiply(2, complex(2, 3)), complex(4, 6)
    approx.deepEqual multiply(i, complex(2, 3)), complex(-3, 2)
    approx.deepEqual multiply(complex(0, 1), complex(2, 3)), complex(-3, 2)
    approx.deepEqual multiply(complex(1, 1), complex(2, 3)), complex(-1, 5)
    approx.deepEqual multiply(complex(2, 3), complex(1, 1)), complex(-1, 5)
    approx.deepEqual multiply(complex(2, 3), complex(2, 3)), complex(-5, 12)
    approx.deepEqual divide(complex(-5, 12), complex(2, 3)), complex(2, 3)
    approx.deepEqual multiply(complex(2, 3), 0), complex(0, 0)
    approx.deepEqual multiply(complex(0, 3), complex(0, -4)), complex(12, 0)
    approx.deepEqual multiply(multiply(3, i), multiply(-4, i)), complex(12, 0)
    approx.deepEqual multiply(erdos.i, Infinity), complex(0, Infinity)
    approx.deepEqual multiply(Infinity, erdos.i), complex(0, Infinity)
    approx.deepEqual multiply(complex(2, 0), complex(0, 2)), complex(0, 4)
    approx.deepEqual multiply(complex(0, 2), complex(0, 2)), -4
    approx.deepEqual multiply(complex(2, 2), complex(0, 2)), complex(-4, 4)
    approx.deepEqual multiply(complex(2, 0), complex(2, 2)), complex(4, 4)
    approx.deepEqual multiply(complex(0, 2), complex(2, 2)), complex(-4, 4)
    approx.deepEqual multiply(complex(2, 2), complex(2, 2)), complex(0, 8)
    approx.deepEqual multiply(complex(2, 0), complex(2, 0)), 4
    approx.deepEqual multiply(complex(0, 2), complex(2, 0)), complex(0, 4)
    approx.deepEqual multiply(complex(2, 2), complex(2, 0)), complex(4, 4)
    approx.deepEqual multiply(complex(2, 3), complex(4, 5)), complex(-7, 22)
    approx.deepEqual multiply(complex(2, 3), complex(4, -5)), complex(23, 2)
    approx.deepEqual multiply(complex(2, 3), complex(-4, 5)), complex(-23, -2)
    approx.deepEqual multiply(complex(2, 3), complex(-4, -5)), complex(7, -22)
    approx.deepEqual multiply(complex(2, -3), complex(4, 5)), complex(23, -2)
    approx.deepEqual multiply(complex(2, -3), complex(4, -5)), complex(-7, -22)
    approx.deepEqual multiply(complex(2, -3), complex(-4, 5)), complex(7, 22)
    approx.deepEqual multiply(complex(2, -3), complex(-4, -5)), complex(-23, 2)
    approx.deepEqual multiply(complex(-2, 3), complex(4, 5)), complex(-23, 2)
    approx.deepEqual multiply(complex(-2, 3), complex(4, -5)), complex(7, 22)
    approx.deepEqual multiply(complex(-2, 3), complex(-4, 5)), complex(-7, -22)
    approx.deepEqual multiply(complex(-2, 3), complex(-4, -5)), complex(23, -2)
    approx.deepEqual multiply(complex(-2, -3), complex(4, 5)), complex(7, -22)
    approx.deepEqual multiply(complex(-2, -3), complex(4, -5)), complex(-23, -2)
    approx.deepEqual multiply(complex(-2, -3), complex(-4, 5)), complex(23, 2)
    approx.deepEqual multiply(complex(-2, -3), complex(-4, -5)), complex(-7, 22)

  it "should multiply mixed complex numbers and numbers", ->
    assert.deepEqual multiply(erdos.complex(6, -4), 2), erdos.complex(12, -8)
    assert.deepEqual multiply(2, erdos.complex(2, 4)), erdos.complex(4, 8)

  it "should multiply mixed complex numbers and big numbers", ->
    assert.deepEqual multiply(erdos.complex(6, -4), erdos.bignumber(2)), erdos.complex(12, -8)
    assert.deepEqual multiply(erdos.bignumber(2), erdos.complex(2, 4)), erdos.complex(4, 8)

  it "should multiply a number and a unit correctly", ->
    assert.equal multiply(2, unit("5 mm")).toString(), "10 mm"
    assert.equal multiply(2, unit("5 mm")).toString(), "10 mm"
    assert.equal multiply(unit("5 mm"), 2).toString(), "10 mm"
    assert.equal multiply(unit("5 mm"), 0).toString(), "0 m"

  it "should multiply a bignumber and a unit correctly", ->
    assert.equal multiply(bignumber(2), unit("5 mm")).toString(), "10 mm"
    assert.equal multiply(bignumber(2), unit("5 mm")).toString(), "10 mm"
    assert.equal multiply(unit("5 mm"), bignumber(2)).toString(), "10 mm"
    assert.equal multiply(unit("5 mm"), bignumber(0)).toString(), "0 m"

  it "should throw an error if used with strings", ->
    assert.throws ->
      multiply "hello", "world"

    assert.throws ->
      multiply "hello", 2

  a = matrix([[1, 2], [3, 4]])
  b = matrix([[5, 6], [7, 8]])
  c = matrix([[5], [6]])
  d = matrix([[5, 6]])
  it "should perform element-wise multiplication if multiplying a matrix and a number", ->
    approx.deepEqual multiply(a, 3), matrix([[3, 6], [9, 12]])
    approx.deepEqual multiply(3, a), matrix([[3, 6], [9, 12]])

  it "should perform matrix multiplication", ->
    approx.deepEqual multiply(a, b), matrix([[19, 22], [43, 50]])
    approx.deepEqual multiply(a, c), matrix([[17], [39]])
    approx.deepEqual multiply(d, a), matrix([[23, 34]])
    approx.deepEqual multiply(d, b), matrix([[67, 78]])
    approx.deepEqual multiply(d, c), matrix([[61]])
    approx.deepEqual multiply([[1, 2], [3, 4]], [[5, 6], [7, 8]]), [[19, 22], [43, 50]]
    approx.deepEqual multiply([1, 2, 3, 4], 2), [2, 4, 6, 8]
    approx.deepEqual multiply(matrix([1, 2, 3, 4]), 2), matrix([2, 4, 6, 8])

  it "should multiply a vector with a matrix correctly", ->
    a = [1, 2, 3]
    b = [[8, 1, 6], [3, 5, 7], [4, 9, 2]]
    approx.deepEqual multiply(a, b), [26, 38, 26]
    approx.deepEqual multiply(b, a), [28, 34, 28]

  it "should multiply vectors correctly (dot product)", ->
    a = [1, 2, 3]
    b = [4, 5, 6]
    approx.deepEqual multiply(a, b), 32

  it "should throw an error if multiplying matrices with incompatible sizes", ->
    assert.throws ->
      multiply c, b

# TODO: test vector*vector with wrong size
# TODO: test vector*matrix with wrong size
# TODO: test matrix*vector with wrong size

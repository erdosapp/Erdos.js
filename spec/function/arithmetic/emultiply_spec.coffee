# test emultiply (element-wise multiply)
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

emultiply = erdos.emultiply
divide = erdos.divide
matrix = erdos.matrix
complex = erdos.complex
range = erdos.range
i = erdos.i
unit = erdos.unit

describe "emultiply", ->
  it "should multiply 2 numbers", ->
    
    # number
    approx.equal emultiply(2, 3), 6
    approx.equal emultiply(-2, 3), -6
    approx.equal emultiply(-2, -3), 6
    approx.equal emultiply(5, 0), 0
    approx.equal emultiply(0, 5), 0

  it "should multiply booleans", ->
    assert.equal emultiply(true, true), 1
    assert.equal emultiply(true, false), 0
    assert.equal emultiply(false, true), 0
    assert.equal emultiply(false, false), 0

  it "should multiply mixed numbers and booleans", ->
    assert.equal emultiply(2, true), 2
    assert.equal emultiply(2, false), 0
    assert.equal emultiply(true, 2), 2
    assert.equal emultiply(false, 2), 0

  it "should multiply 2 complex numbers", ->
    
    # complex
    approx.deepEqual emultiply(complex(2, 3), 2), complex(4, 6)
    approx.deepEqual emultiply(complex(2, -3), 2), complex(4, -6)
    approx.deepEqual emultiply(complex(0, 1), complex(2, 3)), complex(-3, 2)
    approx.deepEqual emultiply(complex(2, 3), complex(2, 3)), complex(-5, 12)
    approx.deepEqual emultiply(2, complex(2, 3)), complex(4, 6)
    approx.deepEqual divide(complex(-5, 12), complex(2, 3)), complex(2, 3)

  it "should multiply a unit by a number", ->
    
    # unit
    assert.equal emultiply(2, unit("5 mm")).toString(), "10 mm"
    assert.equal emultiply(2, unit("5 mm")).toString(), "10 mm"
    assert.equal emultiply(unit("5 mm"), 2).toString(), "10 mm"
    assert.equal emultiply(unit("5 mm"), 0).toString(), "0 m"

  it "should throw an error with strings", ->
    # string
    assert.throws ->
      emultiply "hello", "world"

    assert.throws ->
      emultiply "hello", 2

  a = matrix([[1, 2], [3, 4]])
  b = matrix([[5, 6], [7, 8]])
  c = matrix([[5], [6]])
  d = matrix([[5, 6]])
  it "should multiply a all elements in a matrix by a number", ->
    
    # matrix, array, range
    approx.deepEqual emultiply(a, 3), matrix([[3, 6], [9, 12]])
    approx.deepEqual emultiply(3, a), matrix([[3, 6], [9, 12]])

  it "should perform element-wise matrix multiplication", ->
    approx.deepEqual emultiply(a, b), matrix([[5, 12], [21, 32]])
    approx.deepEqual emultiply([[1, 2], [3, 4]], [[5, 6], [7, 8]]), [[5, 12], [21, 32]]
    approx.deepEqual emultiply([1, 2, 3, 4], 2), [2, 4, 6, 8]

  it "should throw an error if matrices are of different sizes", ->
    assert.throws ->
      emultiply a, c

    assert.throws ->
      emultiply d, a

    assert.throws ->
      emultiply d, b

    assert.throws ->
      emultiply d, c

    assert.throws ->
      emultiply c, b

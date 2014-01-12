# test resize
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

Matrix = erdos.Matrix

describe "resize", ->
  it "should resize an array", ->
    array = [[0, 1, 2], [3, 4, 5]]
    assert.deepEqual erdos.resize(array, [3, 2]), [[0, 1], [3, 4], arr(uninit, uninit)]
    
    # content should be cloned
    x = erdos.complex(2, 3)
    a = [x]
    b = erdos.resize(a, [2], 4)
    assert.deepEqual b, [x, 4]
    assert.notStrictEqual b[0], x

  it "should resize an array with a default value", ->
    array = [[0, 1, 2], [3, 4, 5]]
    assert.deepEqual erdos.resize(array, [3, 2], 5), [[0, 1], [3, 4], [5, 5]]
    assert.deepEqual erdos.resize(array, [3]), [0, 1, 2]
 
  it "should resize an array with bignumbers", ->
    zero = erdos.bignumber(0)
    one = erdos.bignumber(1)
    two = erdos.bignumber(2)
    three = erdos.bignumber(3)
    array = [one, two, three]
    assert.deepEqual erdos.resize(array, [three, two], zero), [[one, two], [zero, zero], [zero, zero]]
 
  it "should resize a matrix", ->
    matrix = new Matrix([[0, 1, 2], [3, 4, 5]])
    assert.deepEqual erdos.resize(matrix, [3, 2]), new Matrix([[0, 1], [3, 4], arr(uninit, uninit)])
    assert.deepEqual erdos.resize(matrix, new Matrix([3, 2])), new Matrix([[0, 1], [3, 4], arr(uninit, uninit)])
    
    # content should be cloned
    x = erdos.complex(2, 3)
    a = new Matrix([x])
    b = erdos.resize(a, [2], 4)
    assert.deepEqual b, new Matrix([x, 4])
    assert.notStrictEqual b.valueOf()[0], x
 
  it "should resize an array into a scalar", ->
    array = [[0, 1, 2], [3, 4, 5]]
    assert.deepEqual erdos.resize(array, []), 0
 
  it "should resize a matrix into a scalar", ->
    matrix = new Matrix([[0, 1, 2], [3, 4, 5]])
    assert.deepEqual erdos.resize(matrix, []), 0

  it "should resize a scalar into an array when array is specified in settings", ->
    erdos = require("../../../lib/erdos")(matrix: "array")
    assert.deepEqual erdos.resize(2, [3], 4), [2, 4, 4]
    assert.deepEqual erdos.resize(2, [2, 2], 4), [[2, 4], [4, 4]]

  it "should resize a scalar into a matrix", ->
    assert.deepEqual erdos.resize(2, [3], 4),    new Matrix([2, 4, 4]).valueOf()
    assert.deepEqual erdos.resize(2, [2, 2], 4), new Matrix([[2, 4], [4, 4]]).valueOf()
 
  it "should resize a scalar into a scalar", ->
    x = erdos.complex(2, 3)
    y = erdos.resize(x, [])
    assert.deepEqual x, y
    assert.notStrictEqual x, y
 
  it "should resize a string", ->
    assert.equal erdos.resize("hello", [2]), "he"
    assert.equal erdos.resize("hello", [8]), "hello   "
    assert.equal erdos.resize("hello", [5]), "hello"
    assert.equal erdos.resize("hello", [8], "!"), "hello!!!"

  it "should throw an error on invalid arguments", ->
    assert.throws ->
      erdos.resize()

    assert.throws ->
      erdos.resize []

    assert.throws ->
      erdos.resize [], 2

    assert.throws ->
      erdos.resize [], [], 4, 555

    assert.throws ->
      erdos.resize "hello", []

    assert.throws ->
      erdos.resize "hello", [2, 3]

    assert.throws ->
      erdos.resize "hello", [8], "charzzz"

    assert.throws ->
      erdos.resize "hello", [8], 2

###
# Helper function to create an Array containing uninitialized values
# Example: arr(uninit, uninit, 2);    // [ , , 2 ]
###
arr = ->
  array = []
  array.length = arguments.length
  i = 0

  while i < arguments.length
    value = arguments[i]
    array[i] = value  if value isnt uninit
    i++
  array
uninit = {}

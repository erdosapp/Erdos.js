# test matrix construction
assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

matrix = erdos.matrix

describe "matrix", ->
  it "should create an empty matrix with one dimension if called without argument", ->
    a = matrix()
    assert.ok a instanceof erdos.Matrix
    assert.deepEqual erdos.size(a), matrix([0]) # TODO: wouldn't it be nicer if an empty matrix has zero dimensions?

  it "should create a matrix from an array", ->
    b = matrix([[1, 2], [3, 4]])
    assert.ok b instanceof erdos.Matrix
    assert.deepEqual b, new erdos.Matrix([[1, 2], [3, 4]])
    assert.deepEqual erdos.size(b), matrix([2, 2])

  it "should be the identity if called with a matrix", ->
    b = matrix([[1, 2], [3, 4]])
    c = matrix(b)
    assert.ok c._data isnt b._data # data should be cloned
    assert.deepEqual c, new erdos.Matrix([[1, 2], [3, 4]])
    assert.deepEqual erdos.size(c), matrix([2, 2])

  it "should create a matrix from a range correctly", ->
    d = matrix(erdos.range(1, 6))
    assert.ok d instanceof erdos.Matrix
    assert.deepEqual d, new erdos.Matrix([1, 2, 3, 4, 5])
    assert.deepEqual erdos.size(d), matrix([5])

  it "should throw an error if called with a single number", ->
    assert.throws (->
      matrix 123
    ), TypeError

  it "should throw an error if called with a unit", ->
    assert.throws (->
      matrix erdos.unit("5cm")
    ), TypeError

  it "should throw an error if called with 2 numbers", ->
    assert.throws (->
      matrix 2, 3
    ), SyntaxError

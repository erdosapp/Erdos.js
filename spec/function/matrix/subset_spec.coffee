assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

subset = erdos.subset
matrix = erdos.matrix
range = erdos.range
index = erdos.index

describe "subset", ->
  a = [[1, 2], [3, 4]]
  b = erdos.matrix(a)
  it "should get the right subset of an array", ->
    assert.deepEqual(subset(a, index([0,2], 1)), [[2],[4]])
    assert.deepEqual subset(a, index(1, 0)), 3

  it "should throw an error if trying to access an invalid subset of an array", ->
    assert.throws (->
      subset a, index(6, 0)
    ), RangeError
    assert.throws (->
      subset a, index(1)
    ), RangeError
    assert.throws (->
      subset a, index(1, 0, 0)
    ), RangeError
    assert.throws (->
      subset a, index(1.3, 0)
    ), TypeError

  it "should get the right subset of a matrix", ->
    assert.deepEqual subset(b, index([0, 2], 1)), matrix([[2], [4]])
    assert.deepEqual subset(b, index(1, 0)), 3

  it "should throw an error if trying to access an invalid subset of a matrix", ->
    assert.throws (->
      subset b, index(6, 0)
    ), RangeError
    assert.throws (->
      subset b, index(1)
    ), RangeError
    assert.throws (->
      subset b, index(1, 0, 0)
    ), RangeError
    assert.throws (->
      subset b, index(1.3, 0)
    ), TypeError

  it "should get the right subset of a string", ->
    assert.deepEqual subset("hello", index(1)), "e"
    assert.deepEqual subset("hello", index([4, -1, -1])), "olleh"

  it "should throw an error if trying to access an invalid subset of a string", ->
    assert.throws (->
      subset "hello", 1
    ), TypeError
    assert.throws (->
      subset "hello", index([6])
    ), SyntaxError
    assert.throws (->
      subset "hello", index([-2])
    ), SyntaxError
    assert.throws (->
      subset "hello", index([1.3])
    ), TypeError

  d = [[1, 2], [3, 4]]
  g = matrix([[1, 2], [3, 4]])

  # TODO: test getting subset of an array and matrix
  it "should set the right subset of an array", ->
    assert.deepEqual d, [[1, 2], [3, 4]]
    assert.deepEqual subset(d, index([0, 2], 1), [[-2], [-4]]), [[1, -2], [3, -4]]
    assert.deepEqual d, [[1, 2], [3, 4]]
    assert.deepEqual subset(d, index(2, [0, 2]), [[5, 6]]), [[1, 2], [3, 4], [5, 6]]
    assert.deepEqual d, [[1, 2], [3, 4]]
    assert.deepEqual subset(d, index(0, 0), 123), [[123, 2], [3, 4]]

  it "should throw an error if setting the subset of an array with an invalid replacement", ->
    assert.throws (->
      subset d, index(1), 123
    ), RangeError
    assert.throws (->
      subset d, index(1.3, 0), 123
    ), TypeError

  it "should set the right subset of a matrix", ->
    assert.deepEqual g, matrix([[1, 2], [3, 4]])
    assert.deepEqual subset(g, index([0, 2], 1), [[-2], [-4]]), matrix([[1, -2], [3, -4]])
    assert.deepEqual g, matrix([[1, 2], [3, 4]])
    assert.deepEqual subset(g, index(2, [0, 2]), [[5, 6]]), matrix([[1, 2], [3, 4], [5, 6]])

  it "should throw an error if setting the subset of a matrix with an invalid replacement", ->
    assert.throws (->
      subset d, index(1), 123
    ), RangeError
    assert.throws (->
      subset d, index(1.3, 0), 123
    ), TypeError

  it "should set the right subset of a string", ->
    j = "hello"
    assert.deepEqual subset(j, index(0), "H"), "Hello"
    assert.deepEqual j, "hello"
    assert.deepEqual subset(j, index(5), "!"), "hello!"
    assert.deepEqual j, "hello"
    assert.deepEqual subset(j, index([5, 11]), " world"), "hello world"
    assert.deepEqual j, "hello"

  it "should set the right subset of a string with resizing", ->
    j = ""
    defaultValue = "i"
    assert.deepEqual subset(j, index(5), "!", defaultValue), "iiiii!"

  it "should throw an error if setting the subset of a string with an invalid replacement", ->
    assert.throws (->
      subset "hello", index([1, 2]), "1234"
    ), RangeError
    assert.throws (->
      subset "hello", index(1, 2), "a"
    ), RangeError
  #
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "map", ->
  it "should apply map to all elements of the matrix", ->
    m = erdos.matrix([[1, 2, 3], [4, 5, 6]])
    m2 = erdos.map(m, (value) ->
      value * 2
    )
    assert.deepEqual m2.valueOf(), [[2, 4, 6], [8, 10, 12]]
    assert.ok m2 instanceof erdos.Matrix

  it "should apply deep-map to all elements in the array", ->
    arr = [[1, 2, 3], [4, 5, 6]]
    arr2 = erdos.map(arr, (value) ->
      value * 2
    )
    assert.deepEqual arr2, [[2, 4, 6], [8, 10, 12]]
    assert.ok Array.isArray(arr2)

  it "should invoke callback with parameters value, index, obj", ->
    arr = [[1, 2, 3], [4, 5, 6]]
    assert.deepEqual erdos.map(arr, (value, index, obj) ->
      erdos.clone [value, index, obj is arr]
    ).valueOf(), [[[1, [0, 0], true], [2, [0, 1], true], [3, [0, 2], true]], [[4, [1, 0], true], [5, [1, 1], true], [6, [1, 2], true]]]

  it "should throw an error if called with unsupported type", ->
    assert.throws ->
      erdos.map 1, ->

    assert.throws ->
      erdos.map "arr", ->

  it "should throw an error if called with invalid number of arguments", ->
    assert.throws ->
      erdos.map [1, 2, 3]

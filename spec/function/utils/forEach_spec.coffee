assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "forEach", ->
  it "should iterate over all elements of the matrix", ->
    m = erdos.matrix([1, 2, 3])
    output = []
    erdos.forEach m, (value) ->
      output.push value

    assert.deepEqual output, [1, 2, 3]

  it "should iterate deep over all elements in the array", ->
    arr = [1, 2, 3]
    output = []
    erdos.forEach arr, (value) ->
      output.push value

    assert.deepEqual output, [1, 2, 3]

  it "should invoke callback with parameters value, index, obj", ->
    arr = [[1, 2, 3], [4, 5, 6]]
    output = []
    erdos.forEach arr, (value, index, obj) ->
      output.push erdos.clone([value, index, obj is arr])

    assert.deepEqual output, [[1, [0, 0], true], [2, [0, 1], true], [3, [0, 2], true], [4, [1, 0], true], [5, [1, 1], true], [6, [1, 2], true]]

  it "should throw an error if called with unsupported type", ->
    assert.throws ->
      erdos.forEach 1, ->

    assert.throws ->
      erdos.forEach "arr", ->

  it "should throw an error if called with invalid number of arguments", ->
    assert.throws ->
      erdos.forEach [1, 2, 3]

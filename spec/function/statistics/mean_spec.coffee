assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

bignumber = erdos.bignumber
mean = erdos.mean

describe "mean", ->
  it "should return the mean value of some numbers", ->
    assert.equal mean(5), 5
    assert.equal mean(3, 1), 2
    assert.equal mean(0, 3), 1.5
    assert.equal mean(1, 3, 5, 2, -5), 1.2
    assert.equal mean(0, 0, 0, 0), 0

  it "should return the mean of big numbers", ->
    assert.deepEqual mean(bignumber(1), bignumber(3), bignumber(5), bignumber(2), bignumber(-5)), bignumber(1.2)

  it "should return the mean value for complex values", ->
    assert.deepEqual mean(erdos.complex(2, 3), erdos.complex(2, 1)), erdos.complex(2, 2)
    assert.deepEqual mean(erdos.complex(2, 3), erdos.complex(2, 5)), erdos.complex(2, 4)

  it "should return the mean value for mixed real and complex values", ->
    assert.deepEqual mean(erdos.complex(2, 4), 4), erdos.complex(3, 2)
    assert.deepEqual mean(4, erdos.complex(2, 4)), erdos.complex(3, 2)

  it "should return the mean value from a vector", ->
    assert.equal mean(erdos.matrix([1, 3, 5, 2, -5])), 1.2

  it "should return the mean for each vector on the last dimension", ->
    assert.deepEqual mean([[2, 4], [6, 8]]), 5
    assert.deepEqual mean(erdos.matrix([[2, 4], [6, 8]])), 5

  # this is a 4x3x2 matrix, full test coverage
  inputMatrix = [[[10, 20], [30, 40], [50, 60]], [[70, 80], [90, 100], [110, 120]], [[130, 140], [150, 160], [170, 180]], [[190, 200], [210, 220], [230, 240]]]
  it "should return the mean value along a dimension on a matrix", ->
    assert.deepEqual mean([[2, 6], [4, 10]], 1), [4, 7]
    assert.deepEqual mean([[2, 6], [4, 10]], 0), [3, 8]
    assert.deepEqual mean(inputMatrix, 0), [[100, 110], [120, 130], [140, 150]]
    assert.deepEqual mean(inputMatrix, 1), [[30, 40], [90, 100], [150, 160], [210, 220]]
    assert.deepEqual mean(inputMatrix, 2), [[15, 35, 55], [75, 95, 115], [135, 155, 175], [195, 215, 235]]

  it "should throw an error if called with invalid number of arguments", ->
    assert.throws ->
      mean()

  it "should throw an error if called with an empty array", ->
    assert.throws ->
      mean []

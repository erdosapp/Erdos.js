assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
cos = erdos.cos

describe "cos", ->
  it "should return the cosine of a boolean", ->
    approx.equal cos(true), 0.54030230586814
    approx.equal cos(false), 1

  it "should return the cosine of a number", ->
    approx.equal cos(0), 1
    approx.equal cos(pi * 1 / 4), 0.707106781186548
    approx.equal cos(pi * 1 / 8), 0.923879532511287
    approx.equal cos(pi * 2 / 4), 0
    approx.equal cos(pi * 3 / 4), -0.707106781186548
    approx.equal cos(pi * 4 / 4), -1
    approx.equal cos(pi * 5 / 4), -0.707106781186548
    approx.equal cos(pi * 6 / 4), 0
    approx.equal cos(pi * 7 / 4), 0.707106781186548
    approx.equal cos(pi * 8 / 4), 1
    approx.equal cos(pi / 4), erdos.sqrt(2) / 2

  it "should return the cosine of a bignumber (downgrades to number)", ->
    approx.equal cos(erdos.bignumber(1)), 0.54030230586814

  it "should return the cosine of a complex number", ->
    re = 4.18962569096881
    im = 9.10922789375534
    approx.deepEqual cos(complex("2+3i")), complex(-re, -im)
    approx.deepEqual cos(complex("2-3i")), complex(-re, im)
    approx.deepEqual cos(complex("-2+3i")), complex(-re, im)
    approx.deepEqual cos(complex("-2-3i")), complex(-re, -im)
    approx.deepEqual cos(complex("i")), complex(1.54308063481524, 0)
    approx.deepEqual cos(complex("1")), complex(0.540302305868140, 0)
    approx.deepEqual cos(complex("1+i")), complex(0.833730025131149, -0.988897705762865)

  it "should return the cosine of an angle", ->
    approx.equal cos(unit("45deg")), 0.707106781186548
    approx.equal cos(unit("-135deg")), -0.707106781186548

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      cos unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      cos "string"

  cos123 = [0.540302305868140, -0.41614683654714, -0.989992496600445]
  it "should return the cos of each element of a matrix", ->
    approx.deepEqual cos(matrix([1, 2, 3])), matrix(cos123)

  it "should return the cos of each element of an array", ->
    approx.deepEqual cos([1, 2, 3]), cos123

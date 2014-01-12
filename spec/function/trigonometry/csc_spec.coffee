assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
csc = erdos.csc

describe "csc", ->
  it "should return the cosecant of a boolean", ->
    approx.equal csc(true), 1.18839510577812
    approx.equal csc(false), Infinity

  it "should return the cosecant of a number", ->
    approx.equal 1 / csc(0), 0
    approx.equal 1 / csc(pi * 1 / 4), 0.707106781186548
    approx.equal 1 / csc(pi * 1 / 8), 0.382683432365090
    approx.equal 1 / csc(pi * 2 / 4), 1
    approx.equal 1 / csc(pi * 3 / 4), 0.707106781186548
    approx.equal 1 / csc(pi * 4 / 4), 0
    approx.equal 1 / csc(pi * 5 / 4), -0.707106781186548
    approx.equal 1 / csc(pi * 6 / 4), -1
    approx.equal 1 / csc(pi * 7 / 4), -0.707106781186548
    approx.equal 1 / csc(pi * 8 / 4), 0
    approx.equal 1 / csc(pi / 4), erdos.sqrt(2) / 2

  it "should return the cosecant of a bignumber (downgrades to number)", ->
    approx.equal csc(erdos.bignumber(1)), 1.18839510577812

  it "should return the cosecant of a complex number", ->
    re = 0.0904732097532074
    im = 0.0412009862885741
    approx.deepEqual csc(complex("2+3i")), complex(re, im)
    approx.deepEqual csc(complex("2-3i")), complex(re, -im)
    approx.deepEqual csc(complex("-2+3i")), complex(-re, im)
    approx.deepEqual csc(complex("-2-3i")), complex(-re, -im)
    approx.deepEqual csc(complex("i")), complex(0, -0.850918128239322)
    approx.deepEqual csc(complex("1")), complex(1.18839510577812, 0)
    approx.deepEqual csc(complex("1+i")), complex(0.621518017170428, -0.303931001628426)

  it "should return the cosecant of an angle", ->
    approx.equal csc(unit("45deg")), 1.41421356237310
    approx.equal csc(unit("-45deg")), -1.41421356237310

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      csc unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      csc "string"

  csc123 = [1.18839510577812, 1.09975017029462, 7.08616739573719]
  it "should return the cosecant of each element of an array", ->
    approx.deepEqual csc([1, 2, 3]), csc123

  it "should return the cosecant of each element of a matrix", ->
    approx.deepEqual csc(matrix([1, 2, 3])), matrix(csc123)

assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
sec = erdos.sec

describe "sec", ->
  it "should return the secant of a boolean", ->
    approx.equal sec(true), 1.85081571768093
    approx.equal sec(false), Infinity

  it "should return the secant of a number", ->
    approx.equal 1 / sec(0), 1
    approx.equal 1 / sec(pi * 1 / 4), 0.707106781186548
    approx.equal 1 / sec(pi * 1 / 8), 0.923879532511287
    approx.equal 1 / sec(pi * 2 / 4), 0
    approx.equal 1 / sec(pi * 3 / 4), -0.707106781186548
    approx.equal 1 / sec(pi * 4 / 4), -1
    approx.equal 1 / sec(pi * 5 / 4), -0.707106781186548
    approx.equal 1 / sec(pi * 6 / 4), 0
    approx.equal 1 / sec(pi * 7 / 4), 0.707106781186548
    approx.equal 1 / sec(pi * 8 / 4), 1
    approx.equal 1 / sec(pi / 4), erdos.sqrt(2) / 2
    approx.equal erdos.pow(sec(pi / 4), 2), 2
    approx.equal sec(0), 1
    approx.equal sec(pi), -1
    approx.equal sec(-pi), -1
    approx.equal erdos.pow(sec(-pi / 4), 2), 2
    approx.equal sec(2 * pi), 1
    approx.equal sec(-2 * pi), 1

  it "should return the secant of a bignumber (downgrades to number)", ->
    approx.equal sec(erdos.bignumber(1)), 1.85081571768093

  it "should return the secant of a complex number", ->
    re = 0.0416749644111443
    im = 0.0906111371962376
    approx.deepEqual sec(complex("2+3i")), complex(-re, im)
    approx.deepEqual sec(complex("2-3i")), complex(-re, -im)
    approx.deepEqual sec(complex("-2+3i")), complex(-re, -im)
    approx.deepEqual sec(complex("-2-3i")), complex(-re, im)
    approx.deepEqual sec(complex("i")), complex(0.648054273663885, 0)
    approx.deepEqual sec(complex("1")), complex(1.85081571768093, 0)
    approx.deepEqual sec(complex("1+i")), complex(0.498337030555187, 0.591083841721045)

  it "should return the secant of an angle", ->
    approx.equal sec(unit("45deg")), 1.41421356237310
    approx.equal sec(unit("-45deg")), 1.41421356237310

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      sec unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      sec "string"

  sec123 = [1.85081571768093, -2.40299796172238, -1.01010866590799]
  it "should return the secant of each element of an array", ->
    approx.deepEqual sec([1, 2, 3]), sec123

  it "should return the secant of each element of a matrix", ->
    approx.deepEqual sec(matrix([1, 2, 3])), matrix(sec123)

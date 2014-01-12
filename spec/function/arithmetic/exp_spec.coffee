# test exp
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
range = erdos.range
exp = erdos.exp

describe "exp", ->
  it "should exponentiate a boolean", ->
    approx.equal exp(true), 2.71828182845905
    approx.equal exp(false), 1

  it "should exponentiate a number", ->
    approx.equal exp(-3), 0.0497870683678639
    approx.equal exp(-2), 0.1353352832366127
    approx.equal exp(-1), 0.3678794411714423
    approx.equal exp(0), 1
    approx.equal exp(1), 2.71828182845905
    approx.equal exp(2), 7.38905609893065
    approx.equal exp(3), 20.0855369231877
    approx.equal exp(erdos.log(100)), 100

  it "should exponentiate a bignumber (downgrades to number)", ->
    approx.equal exp(erdos.bignumber(1)), 2.71828182845905

  it "should throw an error if there's wrong number of arguments", ->
    assert.throws (->
      exp()
    ), SyntaxError, "Wrong number of arguments in function exp (0 provided, 1 expected)"
    assert.throws (->
      exp 1, 2
    ), SyntaxError, "Wrong number of arguments in function exp (2 provided, 1 expected)"

  it "should exponentiate a complex number correctly", ->
    approx.deepEqual exp(erdos.i), complex("0.540302305868140 + 0.841470984807897i")
    approx.deepEqual exp(complex(0, -1)), complex("0.540302305868140 - 0.841470984807897i")
    approx.deepEqual exp(complex(1, 1)), complex("1.46869393991589 + 2.28735528717884i")
    approx.deepEqual exp(complex(1, -1)), complex("1.46869393991589 - 2.28735528717884i")
    approx.deepEqual exp(complex(-1, -1)), complex("0.198766110346413 - 0.309559875653112i")
    approx.deepEqual exp(complex(-1, 1)), complex("0.198766110346413 + 0.309559875653112i")
    approx.deepEqual exp(complex(1, 0)), complex("2.71828182845905")
    
    # test some logic identities
    multiply = erdos.multiply
    pi = erdos.pi
    i = erdos.i
    approx.deepEqual exp(multiply(0.5, multiply(pi, i))), complex(0, 1)
    approx.deepEqual exp(multiply(1, multiply(pi, i))), complex(-1, 0)
    approx.deepEqual exp(multiply(1.5, multiply(pi, i))), complex(0, -1)
    approx.deepEqual exp(multiply(2, multiply(pi, i))), complex(1, 0)
    approx.deepEqual exp(multiply(-0.5, multiply(pi, i))), complex(0, -1)
    approx.deepEqual exp(multiply(-1, multiply(pi, i))), complex(-1, 0)
    approx.deepEqual exp(multiply(-1.5, multiply(pi, i))), complex(0, 1)

  it "should throw an error on a unit", ->
    assert.throws ->
      exp unit("5cm")

  it "should throw an error with a string", ->
    assert.throws ->
      exp "text"

  it "should exponentiate matrices, arrays and ranges correctly", ->
    res = [1, 2.71828182845905, 7.38905609893065, 20.0855369231877]
    approx.deepEqual exp([0, 1, 2, 3]), res
    approx.deepEqual exp(matrix([0, 1, 2, 3])), matrix(res)
    approx.deepEqual exp(matrix([[0, 1], [2, 3]])), matrix([[1, 2.71828182845905], [7.38905609893065, 20.0855369231877]])

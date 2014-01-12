# test exp
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
range = erdos.range
pow = erdos.pow

describe "pow", ->
  it "should elevate a number to the given power", ->
    approx.deepEqual pow(2, 3), 8
    approx.deepEqual pow(2, 4), 16
    approx.deepEqual pow(-2, 2), 4
    approx.deepEqual pow(3, 3), 27
    approx.deepEqual pow(3, -2), 0.111111111111111
    approx.deepEqual pow(-3, -2), 0.111111111111111
    approx.deepEqual pow(3, -3), 0.0370370370370370
    approx.deepEqual pow(-3, -3), -0.0370370370370370
    approx.deepEqual pow(2, 1.5), 2.82842712474619
    approx.deepEqual pow(-2, 1.5), complex(0, -2.82842712474619)

  it "should elevate booleans to the given power", ->
    assert.equal pow(true, true), 1
    assert.equal pow(true, false), 1
    assert.equal pow(false, true), 0
    assert.equal pow(false, false), 1

  it "should add mixed numbers and booleans", ->
    assert.equal pow(2, true), 2
    assert.equal pow(2, false), 1
    assert.equal pow(true, 2), 1
    assert.equal pow(false, 2), 0

  it "should exponentiate bignumbers", ->
    assert.deepEqual pow(bignumber(2), bignumber(3)), bignumber(8)
    assert.deepEqual pow(bignumber(100), bignumber(500)), bignumber("1e1000")

  it "should exponentiate mixed numbers and bignumbers", ->
    assert.deepEqual pow(bignumber(2), 3), bignumber(8)
    assert.deepEqual pow(2, bignumber(3)), bignumber(8)
    approx.equal pow(1 / 3, bignumber(2)), 1 / 9
    approx.equal pow(bignumber(1), 1 / 3), 1

  it "should exponentiate mixed booleans and bignumbers", ->
    assert.deepEqual pow(bignumber(true), bignumber(3)), bignumber(1)
    assert.deepEqual pow(bignumber(3), bignumber(false)), bignumber(1)

  it "should throw an error if used with wrong number of arguments", ->
    assert.throws (->
      pow 1
    ), SyntaxError, "Wrong number of arguments in function pow (1 provided, 2 expected)"
    assert.throws (->
      pow 1, 2, 3
    ), SyntaxError, "Wrong number of arguments in function pow (3 provided, 2 expected)"


  it "should exponentiate a complex number to the given power", ->
    approx.deepEqual pow(complex(3, 0), 2), complex(9, 0)
    approx.deepEqual pow(complex(0, 2), 2), complex(-4, 0)
    approx.deepEqual pow(complex(-1, -1), complex(-1, -1)), complex("-0.0284750589322119 +  0.0606697332231795i")
    approx.deepEqual pow(complex(-1, -1), complex(-1, 1)), complex("-6.7536199239765713 +  3.1697803027015614i")
    approx.deepEqual pow(complex(-1, -1), complex(0, -1)), complex("0.0891447921553914 - 0.0321946742909677i")
    approx.deepEqual pow(complex(-1, -1), complex(0, 1)), complex("9.92340022667813 + 3.58383962127501i")
    approx.deepEqual pow(complex(-1, -1), complex(1, -1)), complex("-0.1213394664463591 -  0.0569501178644237i")
    approx.deepEqual pow(complex(-1, -1), complex(1, 1)), complex("-6.3395606054031211 - 13.5072398479531426i")
    approx.deepEqual pow(complex(-1, 1), complex(-1, -1)), complex("-6.7536199239765713 -  3.1697803027015614i")
    approx.deepEqual pow(complex(-1, 1), complex(-1, 1)), complex("-0.0284750589322119 -  0.0606697332231795i")
    approx.deepEqual pow(complex(-1, 1), complex(0, -1)), complex("9.92340022667813 - 3.58383962127501i")
    approx.deepEqual pow(complex(-1, 1), complex(0, 1)), complex("0.0891447921553914 + 0.0321946742909677i")
    approx.deepEqual pow(complex(-1, 1), complex(1, -1)), complex("-6.3395606054031211 + 13.5072398479531426i")
    approx.deepEqual pow(complex(-1, 1), complex(1, 1)), complex("-0.1213394664463591 +  0.0569501178644237i")
    approx.deepEqual pow(complex(0, -1), complex(-1, -1)), complex("0.000000000000000 + 0.207879576350762i")
    approx.deepEqual pow(complex(0, -1), complex(-1, 1)), complex("0.000000000000000 + 4.810477380965351i")
    approx.deepEqual pow(complex(0, -1), complex(1, -1)), complex("0.000000000000000 - 0.207879576350762i")
    approx.deepEqual pow(complex(0, -1), complex(1, 1)), complex("0.000000000000000 - 4.810477380965351i")
    approx.deepEqual pow(complex(0, 1), complex(-1, -1)), complex("0.000000000000000 - 4.810477380965351i")
    approx.deepEqual pow(complex(0, 1), complex(-1, 1)), complex("0.000000000000000 - 0.207879576350762i")
    approx.deepEqual pow(complex(0, 1), complex(1, -1)), complex("0.000000000000000 + 4.810477380965351i")
    approx.deepEqual pow(complex(0, 1), complex(1, 1)), complex("0.000000000000000 + 0.207879576350762i")
    approx.deepEqual pow(complex(1, -1), complex(-1, -1)), complex("0.2918503793793073 +  0.1369786269150605i")
    approx.deepEqual pow(complex(1, -1), complex(-1, 1)), complex("0.6589325864505904 +  1.4039396486303144i")
    approx.deepEqual pow(complex(1, -1), complex(0, -1)), complex("0.428829006294368 - 0.154871752464247i")
    approx.deepEqual pow(complex(1, -1), complex(0, 1)), complex("2.062872235080905 + 0.745007062179724i")
    approx.deepEqual pow(complex(1, -1), complex(1, -1)), complex("0.2739572538301211 -  0.5837007587586147i")
    approx.deepEqual pow(complex(1, -1), complex(1, 1)), complex("2.8078792972606288 -  1.3178651729011805i")
    approx.deepEqual pow(complex(1, 1), complex(-1, -1)), complex("0.6589325864505904 -  1.4039396486303144i")
    approx.deepEqual pow(complex(1, 1), complex(-1, 1)), complex("0.2918503793793073 -  0.1369786269150605i")
    approx.deepEqual pow(complex(1, 1), complex(0, -1)), complex("2.062872235080905 - 0.745007062179724i")
    approx.deepEqual pow(complex(1, 1), complex(0, 1)), complex("0.428829006294368 + 0.154871752464247i")
    approx.deepEqual pow(complex(1, 1), complex(1, -1)), complex("2.8078792972606288 +  1.3178651729011805i")
    approx.deepEqual pow(complex(1, 1), complex(1, 1)), complex("0.2739572538301211 +  0.5837007587586147i")

  it "should exponentiate a complex number to the given bignumber power", ->
    approx.deepEqual pow(complex(3, 0), erdos.bignumber(2)), complex(9, 0)
    approx.deepEqual pow(complex(0, 2), erdos.bignumber(2)), complex(-4, 0)

  it "should throw an error if used with a unit", ->
    assert.throws ->
      pow unit("5cm"), 2

    assert.throws ->
      pow 2, unit("5cm")

  it "should throw an error if used with a string", ->
    assert.throws ->
      pow "text", 2

    assert.throws ->
      pow 2, "text"

  it "should raise a square matrix to the power 2", ->
    a = [[1, 2], [3, 4]]
    res = [[7, 10], [15, 22]]
    approx.deepEqual pow(a, 2), res
    approx.deepEqual pow(matrix(a), 2), matrix(res)

  it "should throw an error when calculating the power of a non square matrix", ->
    assert.throws ->
      pow [1, 2, 3, 4], 2

    assert.throws ->
      pow [[1, 2, 3], [4, 5, 6]], 2

    assert.throws ->
      pow [[1, 2, 3], [4, 5, 6]], 2

  it "should throw an error when raising a matrix to a non-integer power", ->
    a = [[1, 2], [3, 4]]
    assert.throws ->
      pow a, 2.5

    assert.throws ->
      pow a, [2, 3]

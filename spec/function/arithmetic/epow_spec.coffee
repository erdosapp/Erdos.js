# test exp
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
range = erdos.range
epow = erdos.epow

describe "epow", ->
  it "should elevate a number to the given power", ->
    approx.deepEqual epow(2, 3), 8
    approx.deepEqual epow(2, 4), 16
    approx.deepEqual epow(-2, 2), 4
    approx.deepEqual epow(3, 3), 27
    approx.deepEqual epow(3, -2), 0.111111111111111
    approx.deepEqual epow(-3, -2), 0.111111111111111
    approx.deepEqual epow(3, -3), 0.0370370370370370
    approx.deepEqual epow(-3, -3), -0.0370370370370370
    approx.deepEqual epow(2, 1.5), 2.82842712474619
    approx.deepEqual epow(-2, 1.5), complex(0, -2.82842712474619)

  it "should elevate booleans to the given power", ->
    assert.equal epow(true, true), 1
    assert.equal epow(true, false), 1
    assert.equal epow(false, true), 0
    assert.equal epow(false, false), 1

  it "should add mixed numbers and booleans", ->
    assert.equal epow(2, true), 2
    assert.equal epow(2, false), 1
    assert.equal epow(true, 2), 1
    assert.equal epow(false, 2), 0

  it "should throw an error if invalid number of arguments", ->
    assert.throws (->
      epow 1
    ), SyntaxError, "Wrong number of arguments in function epow (1 provided, 2 expected)"
    assert.throws (->
      epow 1, 2, 3
    ), SyntaxError, "Wrong number of arguments in function epow (3 provided, 2 expected)"

  it "should elevate a complex number to the given power", ->
    approx.deepEqual epow(complex(-1, -1), complex(-1, -1)), complex("-0.0284750589322119 +  0.0606697332231795i")
    approx.deepEqual epow(complex(-1, -1), complex(-1, 1)), complex("-6.7536199239765713 +  3.1697803027015614i")
    approx.deepEqual epow(complex(-1, -1), complex(0, -1)), complex("0.0891447921553914 - 0.0321946742909677i")
    approx.deepEqual epow(complex(-1, -1), complex(0, 1)), complex("9.92340022667813 + 3.58383962127501i")
    approx.deepEqual epow(complex(-1, -1), complex(1, -1)), complex("-0.1213394664463591 -  0.0569501178644237i")
    approx.deepEqual epow(complex(-1, -1), complex(1, 1)), complex("-6.3395606054031211 - 13.5072398479531426i")
    approx.deepEqual epow(complex(-1, 1), complex(-1, -1)), complex("-6.7536199239765713 -  3.1697803027015614i")
    approx.deepEqual epow(complex(-1, 1), complex(-1, 1)), complex("-0.0284750589322119 -  0.0606697332231795i")
    approx.deepEqual epow(complex(-1, 1), complex(0, -1)), complex("9.92340022667813 - 3.58383962127501i")
    approx.deepEqual epow(complex(-1, 1), complex(0, 1)), complex("0.0891447921553914 + 0.0321946742909677i")
    approx.deepEqual epow(complex(-1, 1), complex(1, -1)), complex("-6.3395606054031211 + 13.5072398479531426i")
    approx.deepEqual epow(complex(-1, 1), complex(1, 1)), complex("-0.1213394664463591 +  0.0569501178644237i")
    approx.deepEqual epow(complex(0, -1), complex(-1, -1)), complex("0.000000000000000 + 0.207879576350762i")
    approx.deepEqual epow(complex(0, -1), complex(-1, 1)), complex("0.000000000000000 + 4.810477380965351i")
    approx.deepEqual epow(complex(0, -1), complex(1, -1)), complex("0.000000000000000 - 0.207879576350762i")
    approx.deepEqual epow(complex(0, -1), complex(1, 1)), complex("0.000000000000000 - 4.810477380965351i")
    approx.deepEqual epow(complex(0, 1), complex(-1, -1)), complex("0.000000000000000 - 4.810477380965351i")
    approx.deepEqual epow(complex(0, 1), complex(-1, 1)), complex("0.000000000000000 - 0.207879576350762i")
    approx.deepEqual epow(complex(0, 1), complex(1, -1)), complex("0.000000000000000 + 4.810477380965351i")
    approx.deepEqual epow(complex(0, 1), complex(1, 1)), complex("0.000000000000000 + 0.207879576350762i")
    approx.deepEqual epow(complex(1, -1), complex(-1, -1)), complex("0.2918503793793073 +  0.1369786269150605i")
    approx.deepEqual epow(complex(1, -1), complex(-1, 1)), complex("0.6589325864505904 +  1.4039396486303144i")
    approx.deepEqual epow(complex(1, -1), complex(0, -1)), complex("0.428829006294368 - 0.154871752464247i")
    approx.deepEqual epow(complex(1, -1), complex(0, 1)), complex("2.062872235080905 + 0.745007062179724i")
    approx.deepEqual epow(complex(1, -1), complex(1, -1)), complex("0.2739572538301211 -  0.5837007587586147i")
    approx.deepEqual epow(complex(1, -1), complex(1, 1)), complex("2.8078792972606288 -  1.3178651729011805i")
    approx.deepEqual epow(complex(1, 1), complex(-1, -1)), complex("0.6589325864505904 -  1.4039396486303144i")
    approx.deepEqual epow(complex(1, 1), complex(-1, 1)), complex("0.2918503793793073 -  0.1369786269150605i")
    approx.deepEqual epow(complex(1, 1), complex(0, -1)), complex("2.062872235080905 - 0.745007062179724i")
    approx.deepEqual epow(complex(1, 1), complex(0, 1)), complex("0.428829006294368 + 0.154871752464247i")
    approx.deepEqual epow(complex(1, 1), complex(1, -1)), complex("2.8078792972606288 +  1.3178651729011805i")
    approx.deepEqual epow(complex(1, 1), complex(1, 1)), complex("0.2739572538301211 +  0.5837007587586147i")

  it "should throw an error with units", ->
    assert.throws ->
      epow unit("5cm")

  it "should throw an error with strings", ->
    assert.throws ->
      epow "text"

  it "should elevate each element in a matrix to the given power", ->
    a = [[1, 2], [3, 4]]
    res = [[1, 4], [9, 16]]
    approx.deepEqual epow(a, 2), res
    approx.deepEqual epow(a, 2.5), [[1, 5.65685424949238], [15.58845726811990, 32]]
    approx.deepEqual epow(3, [2, 3]), [9, 27]
    approx.deepEqual epow(matrix(a), 2), matrix(res)
    approx.deepEqual epow([[1, 2, 3], [4, 5, 6]], 2), [[1, 4, 9], [16, 25, 36]]

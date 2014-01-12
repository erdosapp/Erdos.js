# test add
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
add       = erdos.add

describe "add", ->
  it "should add two numbers", ->
    assert.equal add(2, 3), 5
    assert.equal add(-2, 3), 1
    assert.equal add(2, -3), -1
    assert.equal add(-5, -3), -8

  it "should add booleans", ->
    assert.equal add(true, true), 2
    assert.equal add(true, false), 1
    assert.equal add(false, true), 1
    assert.equal add(false, false), 0

  it "should add mixed numbers and booleans", ->
    assert.equal add(2, true), 3
    assert.equal add(2, false), 2
    assert.equal add(true, 2), 3
    assert.equal add(false, 2), 2

  it "should add bignumbers", ->
    assert.deepEqual add(bignumber(0.1), bignumber(0.2)), bignumber(0.3)
    assert.deepEqual add(bignumber("2e5001"), bignumber("3e5000")), bignumber("2.3e5001")
    assert.deepEqual add(bignumber("9999999999999999999"), bignumber("1")), bignumber("1e19")

  it "should add mixed numbers and bignumbers", ->
    assert.deepEqual add(bignumber(0.1), 0.2), bignumber(0.3)
    assert.deepEqual add(0.1, bignumber(0.2)), bignumber(0.3)
    approx.equal add(1 / 3, bignumber(1)), 1.333333333333333
    approx.equal add(bignumber(1), 1 / 3), 1.333333333333333

  it "should add mixed booleans and bignumbers", ->
    assert.deepEqual add(bignumber(0.1), true), bignumber(1.1)
    assert.deepEqual add(false, bignumber(0.2)), bignumber(0.2)

  it "should add mixed complex numbers and bignumbers", ->
    assert.deepEqual add(erdos.complex(3, -4), bignumber(2)), erdos.complex(5, -4)
    assert.deepEqual add(bignumber(2), erdos.complex(3, -4)), erdos.complex(5, -4)

  it "should add two complex numbers", ->
    assert.equal add(erdos.complex(3, -4), erdos.complex(8, 2)), "11 - 2i"
    assert.equal add(erdos.complex(3, -4), 10), "13 - 4i"
    assert.equal add(10, erdos.complex(3, -4)), "13 - 4i"

  it "should add two measures of the same unit", ->
    approx.deepEqual add(erdos.unit(5, "km"), erdos.unit(100, "mile")), erdos.unit(165.93, "km")
  
  it "should throw an error for two measures of different units", ->
    assert.throws ->
      add erdos.unit(5, "km"), erdos.unit(100, "gram")

  it "should concatenate two strings", ->
    assert.equal add("hello ", "world"), "hello world"
    assert.equal add("str", 123), "str123"
    assert.equal add(123, "str"), "123str"

  it "should add matrices correctly", ->
    a2 = erdos.matrix([[1, 2], [3, 4]])
    a3 = erdos.matrix([[5, 6], [7, 8]])
    a4 = add(a2, a3)
    assert.ok a4 instanceof erdos.Matrix
    assert.deepEqual a4.size(), [2, 2]
    assert.deepEqual a4.valueOf(), [[6, 8], [10, 12]]

    a5 = erdos.pow(a2, 2)
    assert.ok a5 instanceof erdos.Matrix
    assert.deepEqual a5.size(), [2, 2]
    assert.deepEqual a5.valueOf(), [[7, 10], [15, 22]]

  it "should add a scalar and a matrix correctly", ->
    assert.deepEqual add(2, erdos.matrix([3, 4])), erdos.matrix([5, 6])
    assert.deepEqual add(erdos.matrix([3, 4]), 2), erdos.matrix([5, 6])

  it "should add a scalar and an array correctly", ->
    assert.deepEqual add(2, [3, 4]), [5, 6]
    assert.deepEqual add([3, 4], 2), [5, 6]

  it "should add a matrix and an array correctly", ->
    a = [1, 2, 3]
    b = erdos.matrix([3, 2, 1])
    c = add(a, b)
    assert.ok c instanceof erdos.Matrix
    assert.deepEqual c, erdos.matrix([4, 4, 4])

assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

range  = erdos.range
matrix = erdos.matrix

describe "range", ->
  it "should parse a valid string correctly", ->
    assert.deepEqual range("1:6"), matrix([1, 2, 3, 4, 5])
    assert.deepEqual range("0:2:10"), matrix([0, 2, 4, 6, 8])
    assert.deepEqual range("5:-1:0"), matrix([5, 4, 3, 2, 1])
    assert.deepEqual range("2:-2:-3"), matrix([2, 0, -2])
  
  it "should create a range start:1:end if called with 2 numbers", ->
    assert.deepEqual range(3, 6), matrix([3, 4, 5])
    assert.deepEqual range(1, 6), matrix([1, 2, 3, 4, 5])
    assert.deepEqual range(1, 6.1), matrix([1, 2, 3, 4, 5, 6])
    assert.deepEqual range(1, 5.9), matrix([1, 2, 3, 4, 5])
    assert.deepEqual range(6, 1), matrix([])
  
  it "should create a range start:step:end if called with 3 numbers", ->
    assert.deepEqual range(0, 10, 2), matrix([0, 2, 4, 6, 8])
    assert.deepEqual range(5, 0, -1), matrix([5, 4, 3, 2, 1])
    assert.deepEqual range(2, -4, -2), matrix([2, 0, -2])
  
  it "should output an array when setting matrix===\"array\"", ->
    erdos2 = erdosjs(matrix: "array")
    assert.deepEqual erdos2.range(0, 10, 2), [0, 2, 4, 6, 8]
    assert.deepEqual erdos2.range(5, 0, -1), [5, 4, 3, 2, 1]
  
  it.skip "should create a range with bignumbers", ->
    assert.deepEqual range(erdos.bignumber(1), erdos.bignumber(3)), matrix([erdos.bignumber(1), erdos.bignumber(2)])

  it "should create a range with mixed numbers and bignumbers", ->
    assert.deepEqual range(erdos.bignumber(1), 3), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(1, erdos.bignumber(3)), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(1, erdos.bignumber(3), erdos.bignumber(1)), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(erdos.bignumber(1), 3, erdos.bignumber(1)), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(erdos.bignumber(1), erdos.bignumber(3), 1), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(erdos.bignumber(1), 3, 1), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(1, erdos.bignumber(3), 1), matrix([erdos.bignumber(1), erdos.bignumber(2)])
    assert.deepEqual range(1, 3, erdos.bignumber(1)), matrix([erdos.bignumber(1), erdos.bignumber(2)])

  it "should parse a range with bignumbers", ->
    erdos = erdosjs(number: "bignumber")
    assert.deepEqual erdos.range("1:3"), matrix([erdos.bignumber(1), erdos.bignumber(2)])

  it "should throw an error if called with an invalid string", ->
    assert.throws (->
      range "invalid range"
    ), SyntaxError

  it "should throw an error if called with a single number", ->
    assert.throws (->
      range 2
    ), TypeError

  it "should throw an error if called with a unit", ->
    assert.throws (->
      range erdos.unit("5cm")
    ), TypeError

  it "should throw an error if called with a complex number", ->
    assert.throws (->
      range erdos.complex(2, 3)
    ), TypeError

  it "should throw an error if called with one invalid argument", ->
    assert.throws (->
      range 2, "string"
    ), TypeError
    assert.throws (->
      range erdos.unit("5cm"), 2
    ), TypeError
    assert.throws (->
      range 2, erdos.complex(2, 3)
    ), TypeError
    assert.throws (->
      range 2, "string", 3
    ), TypeError
    assert.throws (->
      range 2, 1, erdos.unit("5cm")
    ), TypeError
    assert.throws (->
      range erdos.complex(2, 3), 1, 3
    ), TypeError

  it "should throw an error if called with an invalid number of arguments", ->
    assert.throws (->
      range()
    ), SyntaxError
    assert.throws (->
      range 1, 2, 3, 4
    ), SyntaxError
  
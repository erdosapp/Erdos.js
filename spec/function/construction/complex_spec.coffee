assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

complex = erdos.complex

describe "complex", ->
  it "should return 0 + 0i if called with no argument", ->
    assert.deepEqual complex(), new erdos.Complex(0, 0)
    assert.ok complex() instanceof erdos.Complex

  it "should parse a valid string and create the complex number accordingly", ->
    assert.deepEqual complex("2+3i"), new erdos.Complex(2, 3)
    assert.deepEqual complex("2-3i"), new erdos.Complex(2, -3)
    assert.ok complex("2+3i") instanceof erdos.Complex

  it "should convert a real number into a complex value", ->
    assert.deepEqual complex(123), new erdos.Complex(123, 0)

  it "should convert a big number into a complex value (downgrades to number", ->
    assert.deepEqual complex(erdos.bignumber(123)), new erdos.Complex(123, 0)
    assert.deepEqual complex(erdos.bignumber(2), erdos.bignumber(3)), new erdos.Complex(2, 3)

  it "should clone a complex value", ->
    b = complex(complex(2, 3))
    assert.deepEqual b, new erdos.Complex(2, 3)

  it "should convert the elements of a matrix or array to complex values", ->
    result = [new erdos.Complex(2, 0), new erdos.Complex(1, 0), new erdos.Complex(2, 3)]
    assert.deepEqual complex(erdos.matrix([2, 1, complex(2, 3)])), new erdos.Matrix(result)
    assert.deepEqual complex([2, 1, complex(2, 3)]), result

  it "should throw an error if called with a string", ->
    assert.throws (->
      complex "no valid complex number"
    ), SyntaxError, 'String "no valid complex number" is no valid complex number'

  it "should throw an error if called with a boolean", ->
    assert.throws (->
      complex false
    ), TypeError

  it "should throw an error if called with a unit", ->
    assert.throws (->
      complex erdos.unit("5cm")
    ), TypeError

  it "should accept two numbers as arguments", ->
    assert.deepEqual complex(2, 3), new erdos.Complex(2, 3)
    assert.deepEqual complex(2, -3), new erdos.Complex(2, -3)
    assert.deepEqual complex(-2, 3), new erdos.Complex(-2, 3)
    assert.ok complex(2, 3) instanceof erdos.Complex

  it "should throw an error if passed two argument, one is invalid", ->
    assert.throws (->
      complex true, 2
    ), TypeError
    assert.throws (->
      complex 2, false
    ), TypeError
    assert.throws (->
      complex "string", 2
    ), TypeError
    assert.throws (->
      complex 2, "string"
    ), TypeError

  it "should throw an error if called with more than 2 arguments", ->
    assert.throws (->
      complex 2, 3, 4
    ), SyntaxError

assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

unit = erdos.unit

describe "unit", ->
  it "should construct a unit", ->
    # TODO: test construction of a unit

  it "should parse a valid string to a unit", ->
    assert.deepEqual unit("5 cm").toString(), "50 mm"
    assert.deepEqual unit("5000 cm").toString(), "50 m"
    assert.deepEqual unit("10 kg").toString(), "10 kg"

  it "should clone a unit", ->
    a = erdos.unit("5cm")
    b = erdos.unit(a)
    assert.deepEqual b.toString(), "50 mm"

  it "should create units from all elements in an array", ->
    assert.deepEqual erdos.unit(["5 cm", "3kg"]), [erdos.unit("5cm"), erdos.unit("3kg")]

  it "should create units from all elements in an array", ->
    assert.deepEqual erdos.unit(erdos.matrix(["5 cm", "3kg"])), erdos.matrix([erdos.unit("5cm"), erdos.unit("3kg")])

  it "should throw an error if called with an invalid string", ->
    assert.throws (->
      unit "invalid unit"
    ), SyntaxError

  it "should throw an error if called with a number", ->
    assert.throws (->
      unit 2
    ), TypeError

  it "should throw an error if called with a complex", ->
    assert.throws (->
      unit erdos.complex(2, 3)
    ), TypeError

  it "should take a number as the quantity and a string as the unit", ->
    assert.deepEqual unit(5, "cm").toString(), "50 mm"
    assert.deepEqual unit(10, "kg").toString(), "10 kg"

  it "should take a bignumber as the quantity and a string as the unit (downgrades to number)", ->
    assert.deepEqual unit(erdos.bignumber(5), "cm").toString(), "50 mm"

  it "should throw an error if called with 2 strings", ->
    assert.throws (->
      unit "2", "cm"
    ), TypeError

  it "should throw an error if called with one invalid argument", ->
    assert.throws (->
      unit 2, erdos.complex(2, 3)
    ), TypeError
    assert.throws (->
      unit true, "cm"
    ), TypeError

  it "should throw an error if called with no argument", ->
    assert.throws (->
      unit()
    ), SyntaxError

  it "should throw an error if called with an invalid number of arguments", ->
    assert.throws (->
      unit 1, 2, 3
    ), SyntaxError

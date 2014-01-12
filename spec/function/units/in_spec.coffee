assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

unit = erdos.unit

describe "in", ->
  it "should perform the given unit conversion", ->
    
    # TODO: improve these tests
    a = erdos.unit("500 cm")
    a.fixPrefix = true
    approx.deepEqual erdos.in(unit("5m"), unit("cm")), a
    b = erdos.unit("1 foot")
    b.fixPrefix = true
    approx.deepEqual erdos.in(unit("12 inch"), unit("foot")), b
    c = erdos.unit("1 inch")
    c.fixPrefix = true
    approx.deepEqual erdos.in(unit("2.54 cm"), unit("inch")), c
    d = erdos.unit("68 fahrenheit")
    d.fixPrefix = true
    approx.deepEqual erdos.in(unit("20 celsius"), unit("fahrenheit")), d
    e = erdos.unit("0.002 m3")
    e.fixPrefix = true
    approx.deepEqual erdos.in(unit("2 litre"), unit("m3")), e

  it "should perform the given unit conversion on each element of an array", ->
    
    # TODO: do not use erdos.format here
    assert.deepEqual erdos.format(erdos.in([unit("1cm"), unit("2 inch"), unit("2km")], unit("foot")), 5), "[0.032808 foot, 0.16667 foot, 6561.7 foot]"

  it "should perform the given unit conversion on each element of a matrix", ->
    a = erdos.matrix([[unit("1cm"), unit("2cm")], [unit("3cm"), unit("4cm")]])
    b = erdos.in(a, unit("mm"))
    assert.ok b instanceof erdos.Matrix
    
    # TODO: do not use erdos.format here
    assert.equal erdos.format(b), "[[10 mm, 20 mm], [30 mm, 40 mm]]"

  it "should throw an error if converting between incompatible units", ->
    assert.throws ->
      erdos.in unit("20 kg"), unit("cm")

    assert.throws ->
      erdos.in unit("20 celsius"), unit("litre")

    assert.throws ->
      erdos.in unit("5 cm"), unit("2 m")

  it "should throw an error if called with a wrong number of arguments", ->
    assert.throws ->
      erdos.in unit("20 kg")

    assert.throws ->
      erdos.in unit("20 kg"), unit("m"), unit("cm")

  it "should throw an error if called with a non-plain unit", ->
    assert.throws ->
      erdos.unit(5000, "cm").in "5mm"

  it "should throw an error if called with a number", ->
    assert.throws (->
      erdos.in 5, unit("m")
    ), erdos.UnsupportedTypeError

    assert.throws (->
      erdos.in unit("5cm"), 2
    ), erdos.UnsupportedTypeError

	it "should throw an error if called with a string", ->
	  assert.throws (->
	    erdos.in "5cm", unit("cm")
	  ), erdos.UnsupportedTypeError

assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

describe "unit", ->
  describe "constructor", ->
    it "should create unit correctly", ->
      unit1 = erdos.unit(5000, "cm")
      assert.equal unit1.value, 50
      assert.equal unit1.unit.name, "m"
      unit1 = erdos.unit(5, "kg")
      assert.equal unit1.value, 5
      assert.equal unit1.unit.name, "g"
      unit1 = erdos.unit(null, "kg")
      assert.equal unit1.value, null
      assert.equal unit1.unit.name, "g"

    it "should create square meter correctly", ->
      unit1 = erdos.unit(0.000001, "km2")
      assert.equal unit1.value, 1
      assert.equal unit1.unit.name, "m2"

    it "should create cubic meter correctly", ->
      unit1 = erdos.unit(0.000000001, "km3")
      assert.equal unit1.value, 1
      assert.equal unit1.unit.name, "m3"

    it "should throw an error if called with wrong arguments", ->
      assert.throws ->
        Unit 2, "inch"

      assert.throws ->
        new Unit("24", "inch")

      assert.throws ->
        new Unit(0, "bla")

      assert.throws ->
        new Unit(0, 3)

  describe "isPlainUnit", ->
    it "should return true if the string is a plain unit", ->
      assert.equal erdos.Unit.isPlainUnit("cm"), true
      assert.equal erdos.Unit.isPlainUnit("inch"), true
      assert.equal erdos.Unit.isPlainUnit("kb"), true

    it "should return false if the unit is not a plain unit", ->
      assert.equal erdos.Unit.isPlainUnit("bla"), false
      assert.equal erdos.Unit.isPlainUnit("5cm"), false

  describe "toNumber", ->
    it "convert a unit to a number", ->
      u = erdos.unit(5000, "cm")
      approx.equal u.toNumber("mm"), 50000
      approx.equal erdos.unit("5.08 cm").toNumber("inch"), 2


  describe "toString", ->
    it "should convert to string properly", ->
      assert.equal erdos.unit(5000, "cm").toString(), "50 m"
      assert.equal erdos.unit(5, "kg").toString(), "5 kg"
      assert.equal erdos.unit(2 / 3, "m").toString(), "0.6666666666666666 m"

    it "should render with the best prefix", ->
      assert.equal erdos.unit("0.001m").toString(), "1 mm"
      assert.equal erdos.unit("0.01m").toString(), "10 mm"
      assert.equal erdos.unit("0.1m").toString(), "100 mm"
      assert.equal erdos.unit("0.5m").toString(), "500 mm"
      assert.equal erdos.unit("0.6m").toString(), "0.6 m"
      assert.equal erdos.unit("1m").toString(), "1 m"
      assert.equal erdos.unit("10m").toString(), "10 m"
      assert.equal erdos.unit("100m").toString(), "100 m"
      assert.equal erdos.unit("300m").toString(), "300 m"
      assert.equal erdos.unit("500m").toString(), "500 m"
      assert.equal erdos.unit("600m").toString(), "0.6 km"
      assert.equal erdos.unit("1000m").toString(), "1 km"

  describe "format", ->
    it "should format units with given precision", ->
      assert.equal erdos.unit(2 / 3, "m").format(3), "0.667 m"
      assert.equal erdos.unit(2 / 3, "m").format(4), "0.6667 m"
      assert.equal erdos.unit(2 / 3, "m").format(), "0.6666666666666666 m"

  describe "parse", ->
    it "should parse units correctly", ->
      unit1 = undefined
      unit1 = erdos.unit("5kg")
      assert.equal unit1.value, 5
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit("5 kg")
      assert.equal unit1.value, 5
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit(" 5 kg ")
      assert.equal unit1.value, 5
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit("5e-3kg")
      assert.equal unit1.value, 0.005
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit("5e+3kg")
      assert.equal unit1.value, 5000
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit("-5kg")
      assert.equal unit1.value, -5
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "k"
      unit1 = erdos.unit("-5mg")
      assert.equal unit1.value, -0.000005
      assert.equal unit1.unit.name, "g"
      assert.equal unit1.prefix.name, "m"

# TODO: extensively test Unit

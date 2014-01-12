# test format
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "format", ->
  it "should format numbers", ->
    assert.equal erdos.format(2 / 7), "0.2857142857142857"
    assert.equal erdos.format(0.10400), "0.104"
    assert.equal erdos.format(2.3), "2.3"
    assert.equal erdos.format(2.3e6), "2.3e+6"

  it "should format strings", ->
    assert.equal erdos.format("hello"), "\"hello\""

  it "should format arrays", ->
    assert.equal erdos.format([[1, 2], [3, 4]]), "[[1, 2], [3, 4]]"
    array = [[erdos.unit(2 / 3, "m"), 2 / 7], ["hi", erdos.complex(2, 1 / 3)]]
    assert.equal erdos.format(array, 5), "[[0.66667 m, 0.28571], [\"hi\", 2 + 0.33333i]]"

  it "should format complex values", ->
    assert.equal erdos.format(erdos.divide(erdos.complex(2, 5), 3)), "0.6666666666666666 + 1.6666666666666667i"
    assert.equal erdos.format(erdos.divide(erdos.complex(2, 5), 3), 5), "0.66667 + 1.6667i"
    assert.equal erdos.format(erdos.divide(erdos.complex(2, 5), 3),
      notation: "fixed"
    ), "1 + 2i"
    assert.equal erdos.format(erdos.divide(erdos.complex(2, 5), 3),
      notation: "fixed"
      precision: 1
    ), "0.7 + 1.7i"

  describe "precision", ->
    it "should format numbers with given precision", ->
      assert.equal erdos.format(1 / 3), "0.3333333333333333"
      assert.equal erdos.format(1 / 3, 3), "0.333"
      assert.equal erdos.format(1 / 3, 4), "0.3333"
      assert.equal erdos.format(1 / 3, 5), "0.33333"
      assert.equal erdos.format(erdos.complex(1 / 3, 2), 3), "0.333 + 2i"

    it "should format complex numbers with given precision", ->
      assert.equal erdos.format(erdos.complex(1 / 3, 1 / 3), 3), "0.333 + 0.333i"
      assert.equal erdos.format(erdos.complex(1 / 3, 1 / 3), 4), "0.3333 + 0.3333i"

    it "should format matrices with given precision", ->
      assert.equal erdos.format([1 / 3, 1 / 3], 3), "[0.333, 0.333]"
      assert.equal erdos.format([1 / 3, 1 / 3], 4), "[0.3333, 0.3333]"
      assert.equal erdos.format(erdos.matrix([1 / 3, 1 / 3]), 4), "[0.3333, 0.3333]"

    it "should format units with given precision", ->
      assert.equal erdos.format(erdos.unit(2 / 3, "m"), 3), "0.667 m"
      assert.equal erdos.format(erdos.unit(2 / 3, "m"), 4), "0.6667 m"

    it "should format ranges with given precision", ->
      assert.equal erdos.format(new erdos.Range(1 / 3, 4 / 3, 2 / 3), 3), "0.333:0.667:1.33"

  describe "bignumber", ->
    before ->
      erdos.BigNumber.config 20 # ensure the precision is 20 digits, the default

    it "should format big numbers", ->
      assert.equal erdos.format(erdos.bignumber(2).dividedBy(7)), "0.28571428571428571429"
      assert.equal erdos.format(erdos.bignumber(0.10400)), "0.104"
      assert.equal erdos.format(erdos.bignumber(2.3)), "2.3"
      assert.equal erdos.format(erdos.bignumber(2.3e6)), "2.3e+6"

    it "should format big numbers with given precision", ->
      oneThird = erdos.bignumber(1).div(3)
      assert.equal erdos.format(oneThird), "0.33333333333333333333" # default, 20
      assert.equal erdos.format(oneThird, 3), "0.333"
      assert.equal erdos.format(oneThird, 4), "0.3333"
      assert.equal erdos.format(oneThird, 5), "0.33333"
      assert.equal erdos.format(oneThird, 18), "0.333333333333333333"

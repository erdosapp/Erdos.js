# test data type Complex
assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

describe "Complex", ->
  assertComplex = (complex, re, im) ->
    assert.equal complex.re, re
    assert.equal complex.im, im

  describe "constructor", ->
    it "should create a complex number correctly", ->
      complex1 = erdos.complex(3, -4)
      assertComplex complex1, 3, -4
      assertComplex complex1, 3, -4
      assertComplex erdos.complex(2), 2, 0

    it "should throw an error if called with wrong arguments", ->
      assert.throws ->
        erdos.complex 3, -4, 5

      assert.throws ->
        erdos.complex 1, 2, 3

      assert.throws ->
        erdos.complex 1, true

  describe "toString", ->
    it "should render to <re> +/- <im>i", ->
      assert.equal erdos.complex(3, -4).toString(), "3 - 4i"
      assert.equal erdos.complex().toString(), "0"
      assert.equal erdos.complex(2, 3).toString(), "2 + 3i"
      assert.equal erdos.complex(2, 0).toString(), "2"
      assert.equal erdos.complex(0, 3).toString(), "3i"
      assert.equal erdos.complex().toString(), "0"
      assert.equal erdos.complex(0, 2).toString(), "2i"
      assert.equal erdos.complex(1, 1).toString(), "1 + i"
      assert.equal erdos.complex(1, 2).toString(), "1 + 2i"
      assert.equal erdos.complex(1, -1).toString(), "1 - i"
      assert.equal erdos.complex(1, -2).toString(), "1 - 2i"
      assert.equal erdos.complex(1, 0).toString(), "1"
      assert.equal erdos.complex(-1, 2).toString(), "-1 + 2i"
      assert.equal erdos.complex(-1, 1).toString(), "-1 + i"

    it "should not round off digits", ->
      assert.equal erdos.complex(1 / 3, 1 / 3).toString(), "0.3333333333333333 + 0.3333333333333333i"

  describe "format", ->
    it " should render to <re> +/- <im>i with custom precision", ->
      assert.equal erdos.complex(1 / 3, 1 / 3).format(3), "0.333 + 0.333i"
      assert.equal erdos.complex(1 / 3, 1 / 3).format(4), "0.3333 + 0.3333i"
      assert.equal erdos.complex(1 / 3, 1 / 3).format(), "0.3333333333333333 + 0.3333333333333333i"

  describe "parse", ->
    it "should parse rightly", ->
      assertComplex erdos.complex("2 + 3i"), 2, 3
      assertComplex erdos.complex("2 +3i"), 2, 3
      assertComplex erdos.complex("2+3i"), 2, 3
      assertComplex erdos.complex(" 2+3i "), 2, 3
      assertComplex erdos.complex("2-3i"), 2, -3
      assertComplex erdos.complex("2 + i"), 2, 1
      assertComplex erdos.complex("-2-3i"), -2, -3
      assertComplex erdos.complex("-2+3i"), -2, 3
      assertComplex erdos.complex("-2+-3i"), -2, -3
      assertComplex erdos.complex("-2-+3i"), -2, -3
      assertComplex erdos.complex("+2-+3i"), 2, -3
      assertComplex erdos.complex("+2-+3i"), 2, -3
      assertComplex erdos.complex("2 + 3i"), 2, 3
      assertComplex erdos.complex("2 - -3i"), 2, 3
      assertComplex erdos.complex(" 2 + 3i "), 2, 3
      assertComplex erdos.complex("2 + i"), 2, 1
      assertComplex erdos.complex("2 - i"), 2, -1
      assertComplex erdos.complex("2 + -i"), 2, -1
      assertComplex erdos.complex("-2+3e-1i"), -2, 0.3
      assertComplex erdos.complex("-2+3e+1i"), -2, 30
      assertComplex erdos.complex("2+3e2i"), 2, 300
      assertComplex erdos.complex("2.2e-1-3.2e-1i"), 0.22, -0.32
      assertComplex erdos.complex("2.2e-1-+3.2e-1i"), 0.22, -0.32
      assertComplex erdos.complex("2"), 2, 0
      assertComplex erdos.complex("i"), 0, 1
      assertComplex erdos.complex(" i "), 0, 1
      assertComplex erdos.complex("-i"), 0, -1
      assertComplex erdos.complex(" -i "), 0, -1
      assertComplex erdos.complex("+i"), 0, 1
      assertComplex erdos.complex(" +i "), 0, 1
      assertComplex erdos.complex("-2"), -2, 0
      assertComplex erdos.complex("3I"), 0, 3
      assertComplex erdos.complex("-3i"), 0, -3

    it "should throw an error if called with an invalid string", ->
      assert.throws ->
        erdos.complex "str", 2

      assert.throws ->
        erdos.complex ""

      assert.throws ->
        erdos.complex "2r"

      assert.throws ->
        erdos.complex "str"

      assert.throws ->
        erdos.complex "2i+3i"

      assert.throws ->
        erdos.complex "2ia"

      assert.throws ->
        erdos.complex "3+4"

      assert.throws ->
        erdos.complex "3i+4"

      assert.throws ->
        erdos.complex "3e + 4i"

      assert.throws ->
        erdos.complex "3e1.2 + 4i"

      assert.throws ->
        erdos.complex "3e1.2i"

      assert.throws ->
        erdos.complex "3e1.2i"

      assert.throws ->
        erdos.complex "- i"

      assert.throws ->
        erdos.complex "+ i"

  describe "clone", ->
    it "should clone the complex properly", ->
      complex1 = erdos.complex(3, -4)
      clone = complex1.clone()
      clone.re = 100
      clone.im = 200
      assert.notEqual complex1, clone
      assert.equal complex1.re, 3
      assert.equal complex1.im, -4
      assert.equal clone.re, 100
      assert.equal clone.im, 200

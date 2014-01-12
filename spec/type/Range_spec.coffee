assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

Range = erdos.Range

describe "range", ->
  describe "create", ->
    it "should create a range", ->
      r = new Range(2, 6)
      assert.deepEqual r.toArray(), [2, 3, 4, 5]
      assert.equal r.size(), 4

    it "should create a range with custom step", ->
      r = new Range(10, 4, -1)
      assert.deepEqual r.toArray(), [10, 9, 8, 7, 6, 5]
      assert.equal r.size(), 6

    it "should create a range with floating points", ->
      r = new Range(1, 5.5, 1.5)
      assert.deepEqual r.toArray(), [1, 2.5, 4]
      assert.equal r.size(), 3

    it "should create an empty range", ->
      r = new Range()
      assert.deepEqual r.toArray(), []

    it "should create a range with only one value", ->
      r = new Range(0, 1)
      assert.deepEqual r.toArray(), [0]
      assert.equal r.size(), 1

    it "should create an empty range because of wrong step size", ->
      r = new Range(0, 10, 0)
      assert.deepEqual r.toArray(), []
      assert.equal r.size(), 0
      r = new Range(0, 10, -1)
      assert.deepEqual r.toArray(), []
      assert.equal r.size(), 0

  describe "parse", ->
    it "should create a range from a string", ->
      r = Range.parse("10:-1:4")
      assert.deepEqual r.toArray(), [10, 9, 8, 7, 6, 5]
      assert.equal r.size(), 6
      r = Range.parse("2 : 6")
      assert.deepEqual r.toArray(), [2, 3, 4, 5]
      assert.equal r.size(), 4

    it "should return null when parsing an invalid string", ->
      assert.equal Range.parse("a:4"), null
      assert.equal Range.parse("3"), null
      assert.equal Range.parse(""), null

  describe "size", ->
    it "should calculate the size of a range", ->
      assert.deepEqual new Range(0, 0).size(), [0]
      assert.deepEqual new Range(0, 0, -1).size(), [0]
      assert.deepEqual new Range(0, 4).size(), [4]
      assert.deepEqual new Range(2, 4).size(), [2]
      assert.deepEqual new Range(0, 8, 2).size(), [4]
      assert.deepEqual new Range(0, 8.1, 2).size(), [5]
      assert.deepEqual new Range(0, 7.9, 2).size(), [4]
      assert.deepEqual new Range(0, 7, 2).size(), [4]
      assert.deepEqual new Range(3, -1, -1).size(), [4]
      assert.deepEqual new Range(3, -1.1, -1).size(), [5]
      assert.deepEqual new Range(3, -0.9, -1).size(), [4]
      assert.deepEqual new Range(3, -1, -2).size(), [2]
      assert.deepEqual new Range(3, -0.9, -2).size(), [2]
      assert.deepEqual new Range(3, -1.1, -2).size(), [3]
      assert.deepEqual new Range(3, 0.1, -2).size(), [2]

  describe "min", ->
    it "should calculate the minimum value of a range", ->
      assert.strictEqual new Range(0, 0).min(), undefined
      assert.strictEqual new Range(0, 0, -1).min(), undefined
      assert.strictEqual new Range(0, 4).min(), 0
      assert.strictEqual new Range(2, 4).min(), 2
      assert.strictEqual new Range(0, 8, 2).min(), 0
      assert.strictEqual new Range(0, 8.1, 2).min(), 0
      assert.strictEqual new Range(0, 7.9, 2).min(), 0
      assert.strictEqual new Range(0, 7, 2).min(), 0
      assert.strictEqual new Range(3, -1, -1).min(), 0
      assert.strictEqual new Range(3, -1.1, -1).min(), -1
      assert.strictEqual new Range(3, -0.9, -1).min(), 0
      assert.strictEqual new Range(3, -1, -2).min(), 1
      assert.strictEqual new Range(3, -0.9, -2).min(), 1
      assert.strictEqual new Range(3, -1.1, -2).min(), -1
      assert.strictEqual new Range(3, 0.1, -2).min(), 1

  describe "max", ->
    it "should calculate the maximum value of a range", ->
      assert.strictEqual new Range(0, 0).max(), undefined
      assert.strictEqual new Range(0, 0, -1).max(), undefined
      assert.strictEqual new Range(2, 4).max(), 3
      assert.strictEqual new Range(0, 8, 2).max(), 6
      assert.strictEqual new Range(0, 8.1, 2).max(), 8
      assert.strictEqual new Range(0, 7.9, 2).max(), 6
      assert.strictEqual new Range(0, 7, 2).max(), 6
      assert.strictEqual new Range(3, -1, -1).max(), 3
      assert.strictEqual new Range(3, -1.1, -1).max(), 3
      assert.strictEqual new Range(3, -0.9, -1).max(), 3
      assert.strictEqual new Range(3, -1, -2).max(), 3
      assert.strictEqual new Range(3, -0.9, -2).max(), 3
      assert.strictEqual new Range(3, -1.1, -2).max(), 3
      assert.strictEqual new Range(3, 0.1, -2).max(), 3

  describe "toString", ->
    it "should stringify a range to format start:step:end", ->
      assert.equal new erdos.Range(0, 10).toString(), "0:10"
      assert.equal new erdos.Range(0, 10, 2).toString(), "0:2:10"

    it "should stringify a range to format start:step:end with given precision", ->
      assert.equal new erdos.Range(1 / 3, 4 / 3, 2 / 3).format(3), "0.333:0.667:1.33"
      assert.equal new erdos.Range(1 / 3, 4 / 3, 2 / 3).format(4), "0.3333:0.6667:1.333"
      assert.equal new erdos.Range(1 / 3, 4 / 3, 2 / 3).format(), "0.3333333333333333:0.6666666666666666:1.3333333333333333"

# TODO: test clone
# TODO: test forEach
# TODO: test format
# TODO: test map
# TODO: test isRange
# TODO: test toArray
# TODO: test valueOf

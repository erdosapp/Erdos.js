# test object utils
assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

object = require("../../lib/util/object")

describe "object", ->
  describe "clone", ->
    it "should clone undefined", ->
      assert.strictEqual object.clone(undefined), undefined

    it "should clone null", ->
      assert.strictEqual object.clone(null), null

    it "should clone booleans", ->
      assert.strictEqual object.clone(true), true
      assert.strictEqual object.clone(false), false
      assert.ok object.clone(new Boolean(true)) instanceof Boolean
      assert.equal object.clone(new Boolean(true)), true
      assert.equal object.clone(new Boolean(false)), false

    it "should clone numbers", ->
      assert.strictEqual object.clone(2.3), 2.3
      assert.ok object.clone(new Number(2.3)) instanceof Number
      assert.equal object.clone(new Number(2.3)), 2.3

    it "should clone strings", ->
      assert.strictEqual object.clone("hello"), "hello"
      assert.ok object.clone(new String("hello")) instanceof String
      assert.equal object.clone(new String("hello")), "hello"
  
  # TODO: clone objects, arrays, etc
  it "extend", ->
    it "should extend an object with all properties of an other object", ->
      o1 =
        a: 2
        b: 3

      o2 =
        a: 4
        b: null
        c: undefined
        d: 5

      o3 = object.extend(o1, o2)
      assert.strictEqual o1, o3
      assert.deepEqual o3,
        a: 4
        b: null
        c: undefined
        d: 5

      assert.deepEqual o2, # should be unchanged
        a: 4
        b: null
        c: undefined
        d: 5

  it "deepExtend", ->
    # TODO

  it "deepEqual", ->
    # TODO

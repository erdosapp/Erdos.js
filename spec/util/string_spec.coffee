# test string utils
assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

string = require("../../lib/util/string")

describe "string", ->
  it "isString", ->
    assert.equal string.isString("hi"), true
    assert.equal string.isString(String("hi")), true
    assert.equal string.isString(new String("hi")), true
    assert.equal string.isString(23), false
    assert.equal string.isString(true), false
    assert.equal string.isString(new Date()), false

  it "endsWith", ->
    assert.equal string.endsWith("hello", "hello"), true
    assert.equal string.endsWith("hello", "lo"), true
    assert.equal string.endsWith("hello", ""), true
    assert.equal string.endsWith("hello!", "lo"), false
    assert.equal string.endsWith("hello", "LO"), false
    assert.equal string.endsWith("hello", "hellohello"), false

  describe "format", ->
    it "should format a number", ->
      assert.equal string.format(2.3), "2.3"

    it "should format a number with configuration", ->
      assert.equal string.format(1.23456, 3), "1.23"
      assert.equal string.format(1.23456,
        precision: 3
      ), "1.23"

    it "should format an array", ->
      assert.equal string.format([1, 2, 3]), "[1, 2, 3]"
      assert.equal string.format([[1, 2], [3, 4]]), "[[1, 2], [3, 4]]"

    it "should format a string", ->
      assert.equal string.format("string"), "\"string\""

    it "should format an object with its own format function", ->
      obj = format: (options) ->
        str = "obj"
        str += " " + JSON.stringify(options)  if options isnt undefined
        str

      assert.equal string.format(obj), "obj"
      assert.equal string.format(obj, 4), "obj 4"
      assert.equal string.format(obj,
        precision: 4
      ), "obj {\"precision\":4}"

    it "should format a function", ->
      assert.equal string.format((a, b) ->
        a + b
      ), "function"
      f = (a, b) ->
        a + b

      f.syntax = "f(x, y)"
      assert.equal string.format(f), "f(x, y)"

    it "should format unknown objects by converting them to string", ->
      assert.equal string.format({}), "[object Object]"

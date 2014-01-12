assert   = require("assert")
approx   = require("../../tools/approx")
erdos    = require("../../lib/erdos")()
Matrix   = require('../../lib/type/Matrix')
Selector = erdos.chaining.Selector
UnsupportedTypeError = erdos.error.UnsupportedTypeError

describe "select", ->
  it "should chain operations with numbers", ->
    assert.equal new Selector(3).add(4).subtract(2).done(), 5
    assert.equal new Selector(0).add(3).done(), 3

  it "should chain operations with bignumbers", ->
    result = new Selector(erdos.bignumber(3)).add(4).subtract(erdos.bignumber(2)).done()
    assert.deepEqual result, erdos.bignumber(5)

  it "should chain operations with constants", ->
    approx.equal new Selector().pi.done(), Math.PI
    approx.deepEqual new Selector().i.multiply(2).add(3).done(), erdos.complex(3, 2)
    approx.equal new Selector().pi.divide(4).sin().pow(2).done(), 0.5

  it "should chain operations with matrices", ->
    assert.deepEqual new Selector(erdos.matrix([[1, 2], [3, 4]])).subset(erdos.index(0, 0), 8).multiply(3).done(), erdos.matrix([[24, 6], [9, 12]])

  it "should get string representation", ->
    assert.equal new Selector(5.2).toString(), "5.2"

  it "should get selectors value via valueOf", ->
    assert.equal new Selector(5.2).valueOf(), 5.2
    assert.equal new Selector(5.2) + 2, 7.2

  it "should create a selector from a selector", ->
    a = new Selector(2.3)
    b = new Selector(a)
    assert.equal a.done(), 2.3
    assert.equal b.done(), 2.3

  it "should not break with null as value", ->
    assert.equal new Selector(null).add("").done(), "null"

  it "should throw an error if called with wrong input", ->
    assert.throws (->
      new Selector().add(2).done()
    ), UnsupportedTypeError, "Function add(undefined, number) not supported"

    assert.throws (->
      new Selector(null).add(2).done()
    ), UnsupportedTypeError, "Function add(null, number) not supported"

  it "should throw an error if constructed without new keyword", ->
    assert.throws (->
      Selector()
    ), SyntaxError
  
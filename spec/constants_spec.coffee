assert = require("assert")
erdos  = require("../lib/erdos")()
approx = require("../tools/approx")

describe "constants", ->
  it "should have PI", ->
    approx.equal erdos.pi, 3.14159265358979
    approx.equal erdos.sin(erdos.pi / 2), 1
    approx.equal erdos.PI, erdos.pi
    approx.equal erdos.eval("pi"), 3.14159265358979

  it "should have tau", ->
    approx.equal erdos.tau, 6.28318530717959
    approx.equal erdos.eval("tau"), 6.28318530717959

  it "should have euler constant", ->
    approx.equal erdos.e, 2.71828182845905
    approx.equal erdos.eval("e"), 2.71828182845905
    assert.equal erdos.round(erdos.add(1, erdos.pow(erdos.e, erdos.multiply(erdos.pi, erdos.i))), 5), 0
    assert.equal erdos.round(erdos.eval("1+e^(pi*i)"), 5), 0

  it "should have i", ->
    assert.equal erdos.i.re, 0
    assert.equal erdos.i.im, 1
    assert.deepEqual erdos.i, erdos.complex(0, 1)
    assert.deepEqual erdos.sqrt(-1), erdos.i
    assert.deepEqual erdos.eval("i"), erdos.complex(0, 1)

  it "should have true and false", ->
    assert.strictEqual erdos.eval("true"), true
    assert.strictEqual erdos.eval("false"), false

  it "should have Infinity", ->
    assert.strictEqual erdos.Infinity, Infinity

  it "should have NaN", ->
    assert.ok isNaN(erdos.NaN)
  
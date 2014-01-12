assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "clone", ->
  it "should clone a number", ->
    a = 1
    b = erdos.clone(a)
    a = 2
    assert.strictEqual b, 1

  it "should clone a bignumber", ->
    a = erdos.bignumber("2.3e500")
    b = erdos.clone(a)
    assert.deepEqual a, b
    assert.notStrictEqual a, b

  it "should clone a string", ->
    a = "hello world"
    b = erdos.clone(a)
    a = "bye!"
    assert.strictEqual b, "hello world"

  it "should clone a complex number", ->
    a = erdos.complex(2, 3)
    b = erdos.clone(a)
    assert.notEqual a, b
    a.re = 5
    assert.strictEqual a.toString(), "5 + 3i"
    assert.strictEqual b.toString(), "2 + 3i"

  it "should clone a unit", ->
    a = erdos.unit("5mm")
    b = erdos.clone(a)
    a.value = 10
    assert.equal a.toString(), "10 m"
    assert.equal b.toString(), "5 mm"

  it "should clone an array", ->
    a = [1, 2, [3, 4]]
    b = erdos.clone(a)
    a[2][1] = 5
    assert.equal b[2][1], 4

  it "should clone a matrix", ->
    a = erdos.matrix([[1, 2], [3, 4]])
    b = erdos.clone(a)
    a.valueOf()[0][0] = 5
    assert.equal b.valueOf()[0][0], 1
    a = erdos.matrix([1, 2, new erdos.complex(2, 3), 4])
    b = erdos.clone(a)
    a.valueOf()[2].re = 5
    assert.equal b.valueOf()[2].re, 2

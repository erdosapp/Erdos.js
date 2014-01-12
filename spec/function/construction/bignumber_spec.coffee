# test parser
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()
BigNumber = require("bignumber.js")
bignumber = erdos.bignumber

describe "bignumber", ->
  it "should create a bignumber", ->
    # from number
    a = bignumber(0.1)
    assert.ok a instanceof BigNumber
    assert.equal a.valueOf(), "0.1"
    
    # from string
    b = bignumber("0.1")
    assert.ok b instanceof BigNumber
    assert.equal b.valueOf(), "0.1"
    
    # from boolean
    c = bignumber(true)
    assert.ok c instanceof BigNumber
    assert.equal c.valueOf(), "1"
    
    # from array
    d = bignumber([0.1, 0.2, "0.3"])
    assert.ok Array.isArray(d)
    assert.equal d.length, 3
    assert.ok d[0] instanceof BigNumber
    assert.ok d[1] instanceof BigNumber
    assert.ok d[2] instanceof BigNumber
    assert.equal d[0].valueOf(), "0.1"
    assert.equal d[1].valueOf(), "0.2"
    assert.equal d[2].valueOf(), "0.3"
    
    # from matrix
    e = bignumber(erdos.matrix([0.1, 0.2]))
    assert.ok e instanceof erdos.Matrix
    assert.deepEqual e.size(), [2]
    assert.ok e.get([0]) instanceof BigNumber
    assert.ok e.get([1]) instanceof BigNumber
    assert.equal e.get([0]).valueOf(), "0.1"
    assert.equal e.get([1]).valueOf(), "0.2"
    
    # really big
    f = bignumber("1.2e500")
    assert.equal f.valueOf(), "1.2e+500"

  it "should apply precision setting to bignumbers", ->
    erdos = erdosjs(decimals: 32)
    a = erdos.bignumber(1).dividedBy(3)
    assert.equal a.toString(), "0.33333333333333333333333333333333"
    
    # restore default precision
    erdos.config decimals: 20

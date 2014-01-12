# test index construction
assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "index", ->
  it "should create an index", ->
    index = erdos.index([2, 6])
    assert.ok index instanceof erdos.Index

    assert.deepEqual index._ranges, [ 
      start: 2
      end: 6
      step: 1
    ]

    index2 = erdos.index([0, 4], [5, 2, -1])
    assert.ok index2 instanceof erdos.Index
    assert.deepEqual index2._ranges, [
      start: 0
      end: 4
      step: 1
    ,
      start: 5
      end: 2
      step: -1
    ]

  it "should create an index from bignumbers (downgrades to numbers)", ->
    index = erdos.index([erdos.bignumber(2), erdos.bignumber(6)], erdos.bignumber(3))
    assert.ok index instanceof erdos.Index
    assert.deepEqual index._ranges, [
      start: 2
      end: 6
      step: 1
    ,
      start: 3
      end: 4
      step: 1
    ]
  
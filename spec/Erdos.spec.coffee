Erdos = require('../lib/erdos')
assert = require('chai').assert

describe "factory", ->
  it "should create an instance of erdos.js with default configuration", ->
    erdos = erdosjs()
    assert.strictEqual typeof erdos, "object"
    assert.deepEqual erdos.config(),
      matrix: "matrix"
      number: "number"
      decimals: 20

  it "should create an instance of erdos.js with custom configuration", ->
    erdos = erdosjs(
      matrix: "array"
      number: "bignumber"
    )
    assert.strictEqual typeof erdos, "object"
    assert.deepEqual erdos.config(),
      matrix: "array"
      number: "bignumber"
      decimals: 20

  it "two instances of erdos.js should be isolated from each other", ->
    erdos1 = erdosjs()
    erdos2 = erdosjs(matrix: "array")
    assert.notStrictEqual erdos1, erdos2
    assert.notDeepEqual erdos1.config(), erdos2.config()
    assert.strictEqual typeof erdos1.sqrt, "function"
    assert.strictEqual typeof erdos2.sqrt, "function"
    assert.notStrictEqual erdos1.sqrt, erdos2.sqrt

  it "should apply configuration using the config function", ->
    erdos = erdosjs()
    config = erdos.config()
    assert.deepEqual config,
      matrix: "matrix"
      number: "number"
      decimals: 20

    erdos.config
      matrix: "array"
      number: "bignumber"
      decimals: 32

    assert.deepEqual erdos.config(),
      matrix: "array"
      number: "bignumber"
      decimals: 32

    
    # restore the original config
    erdos.config config

# test approx itself...
assert   = require("chai").assert
approx   = require("../tools/approx")
erdosjs  = require("../lib/erdos")
erdos    = erdosjs()
Parser   = require("../lib/core/MathLineParser")(erdos, erdos.settings)

describe "MathLineParser", ->
  it "should turn stuff into stuff that can be evaluated", ->
    parser = new Parser("10% of 200")
    assert.equal parser.go().toString(), "200 * 0.1"

    parser = new Parser("$2.50 for the bus * 2 trips", parser.eparser)
    assert.equal parser.go().toString(), "2.50 * 2"
    assert.equal parser.eval(), "5"

    parser.eparser.scope.set('x', 30)
    parser = new Parser("x + 20", parser.eparser)
    assert.equal parser.eval(), "50"

    parser = new Parser("$3.50 for the bus * 2 trips")
    assert.equal parser.go().toString(), "3.50 * 2"
    assert.equal parser.eval(), "7"

    parser = new Parser("$3.20 for the coffee + $4.50 for the muffin", parser.eparser)
    assert.equal parser.go().toString(), "3.20 + 4.50"
    assert.equal parser.eval(), "7.7"

    parser = new Parser("$25 for lunch + 10% sales tax", parser.eparser)
    assert.equal parser.go().toString(), "25 + (25 * 0.1)"
    assert.equal parser.eval(), "27.5"

## TODO
    # parser = new Parser("3.23% of 2257", parser.eparser)
    # assert.equal parser.go().toString(), "2257 * 3.23"
    # assert.equal parser.eval(), "72.9"
# 
    # parser = new Parser("$39.95 - 20%", parser.eparser)
    # assert.equal parser.go().toString(), "39.95 - (39.95 * 0.2)"
    # assert.equal parser.eval(), "31.96"
# 
    # parser = new Parser("20% off $39.95", parser.eparser)
    # assert.equal parser.go().toString(), "39.95 - (39.95 * 0.2)"
    # assert.equal parser.eval(), "31.96"
    # 
    # parser = new Parser("20% off $39.95", parser.eparser)
    # assert.equal parser.go().toString(), "39.95 - (39.95 * 0.2)"
    # assert.equal parser.eval(), "31# 
# test import
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "import", ->
  beforeEach ->
    erdos.import
      myvalue: 42
      hello: (name) ->
        "hello, " + name + "!"
    ,
      override: true

  afterEach ->
    # TODO forget the members added in beforeEach

  it "should import a custom member", ->
    assert.equal erdos.myvalue * 2, 84
    assert.equal erdos.hello("user"), "hello, user!"

  it "should not override existing functions", ->
    erdos.import myvalue: 10
    approx.equal erdos.myvalue, 42

  it "should override existing functions if forced", ->
    erdos.import
      myvalue: 10
    ,
      override: true

    approx.equal erdos.myvalue, 10

  it "should parse the user defined members", ->
    if erdos.parser
      parser = erdos.parser()
      erdos.add erdos.myvalue, 10
      parser.eval "myvalue + 10" # 52
      parser.eval "hello(\"user\")" # 'hello, user!'

  getSize = (array) ->
    array.length

  it "should wrap the custom functions automatically", ->
    erdos.import getSizeWrapped: getSize
    assert.equal erdos.getSizeWrapped([1, 2, 3]), 3
    assert.equal erdos.getSizeWrapped(erdos.matrix([1, 2, 3])), 3

  it "shouldn't wrap the custom functions if wrap = false", ->
    erdos.import
      getSizeNotWrapped: getSize
    ,
      wrap: false

    assert.equal erdos.getSizeNotWrapped([1, 2, 3]), 3
    assert.equal erdos.getSizeNotWrapped(erdos.matrix([1, 2, 3])), undefined

  it "should extend erdos with numbers", ->
    # extend erdos.js with numbers.js
    # examples copied from https://github.com/sjkaliski/numbers.js/blob/master/examples/statistic.js
    erdos.import "numbers"
    assert.equal erdos.fibonacci(7), 13
    
    # Consider a data representing total follower count of a
    # variety of users.
    followers = erdos.matrix([100, 50, 1000, 39, 283, 634, 3, 6123])
    
    # We can generate a report of summary statistics
    # which includes the mean, 1st and 3rd quartiles,
    # and standard deviation.
    report = erdos.report(followers)
    approx.deepEqual report,
      mean: 1029
      firstQuartile: 44.5
      median: 191.5
      thirdQuartile: 817
      standardDev: 1953.0897316815733

    # Maybe we decide to become a bit more curious about
    # trends in follower count, so we start conjecturing about
    # our ability to "predict" trends.
    # Let's consider the number of tweets those users have.
    tweets = erdos.matrix([100, 10, 400, 5, 123, 24, 302, 2000])
    
    # Let's calculate the correlation.
    correlation = erdos.correlation(tweets, followers)
    approx.equal correlation, 0.98054753183666
    
    # Now let's create a linear regression.
    linReg = erdos.linearRegression(tweets, followers)
    
    # linReg is actually a function we can use to map tweets
    # onto followers. We'll see that around 1422 followers
    # are expected if a user tweets 500 times.
    estFollowers = linReg(500)
    approx.equal estFollowers, 1422.431464053916

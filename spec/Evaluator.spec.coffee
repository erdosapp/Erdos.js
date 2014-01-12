# test eval
assert = require("assert")
approx = require("../../../tools/approx")
Erdos = require("../Erdos")()
Complex = erdos.Complex
Matrix = erdos.Matrix
Unit = erdos.Unit

describe "eval", ->
  it "should evaluate expressions", ->
    approx.equal erdos.eval("(2+3)/4"), 1.25
    assert.deepEqual erdos.eval("sqrt(-4)"), new Complex(0, 2)

  it "should eval a list of expressions", ->
    assert.deepEqual erdos.eval(["1+2", "3+4", "5+6"]), [3, 7, 11]
    assert.deepEqual erdos.eval(["a=3", "b=4", "a*b"]), [3, 4, 12]
    assert.deepEqual erdos.eval(new Matrix(["a=3", "b=4", "a*b"])), new Matrix([3, 4, 12])
    assert.deepEqual erdos.eval(["a=3", "b=4", "a*b"]), [3, 4, 12]

  it "should eval a series of expressions", ->
    assert.deepEqual erdos.eval("a=3\nb=4\na*b"), [3, 4, 12]
    assert.deepEqual erdos.eval("function f(x) = a * x; a=2; f(4)"), [8]
    assert.deepEqual erdos.eval("b = 43; b * 4"), [172]

  it "should throw an error if wrong number of arguments", ->
    assert.throws (->
      erdos.eval()
    ), SyntaxError
    assert.throws (->
      erdos.eval 1, 2, 3
    ), SyntaxError

  it "should throw an error with a number", ->
    assert.throws (->
      erdos.eval 23
    ), TypeError

  it "should throw an error with a unit", ->
    assert.throws (->
      erdos.eval new Unit(5, "cm")
    ), TypeError

  it "should throw an error with a complex number", ->
    assert.throws (->
      erdos.eval new Complex(2, 3)
    ), TypeError

  it "should throw an error with a boolean", ->
    assert.throws (->
      erdos.eval true
    ), TypeError

  it "should handle the given scope", ->
    scope =
      a: 3
      b: 4

    assert.deepEqual erdos.eval("a*b", scope), 12
    assert.deepEqual erdos.eval("c=5", scope), 5
    assert.deepEqual erdos.format(erdos.eval("function f(x) = x^a", scope)), "f(x)"
    assert.deepEqual Object.keys(scope).length, 5
    assert.deepEqual scope.a, 3
    assert.deepEqual scope.b, 4
    assert.deepEqual scope.c, 5
    assert.deepEqual typeof scope.f, "function"
    assert.deepEqual typeof scope.ans, "function"
    assert.strictEqual scope.ans, scope.f
    assert.equal scope.f(3), 27
    scope.a = 2
    assert.equal scope.f(3), 9
    scope.hello = (name) ->
      "hello, " + name + "!"

    assert.deepEqual erdos.eval("hello(\"jos\")", scope), "hello, jos!"

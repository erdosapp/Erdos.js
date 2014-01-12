# test parse
Erdos = require("../Erdos")()
BigNumber = erdos.BigNumber
Complex = erdos.Complex
Matrix = erdos.Matrix
Unit = erdos.Unit

###
# Helper function to parse an expression and immediately evaluate its results
# @param {String} expr
# @param {Object} [scope]
# @return {*} result
###
parseAndEval = (expr, scope) ->
  node = erdos.parse(expr, scope)
  node.eval()

###
# Helper function to create an Array containing uninitialized values
# Example: arr(uninit, uninit, 2);    // [ , , 2 ]
###
arr = ->
  array = []
  array.length = arguments.length
  i = 0

  while i < arguments.length
    value = arguments[i]
    array[i] = value  if value isnt uninit
    i++
  array
uninit = {}

describe "parse", ->
  it "should parse a single expression", ->
    approx.equal erdos.parse("2 + 6 / 3").eval(), 4

  it "should parse a series of expressions", ->
    assert.deepEqual erdos.parse(["a=3", "b=4", "a*b"]).map((node) ->
      node.eval()
    ), [3, 4, 12]
    assert.deepEqual erdos.parse(new Matrix(["a=3", "b=4", "a*b"])).map((node) ->
      node.eval()
    ), new Matrix([3, 4, 12])

  it "should parse multiline expressions", ->
    assert.deepEqual erdos.parse("a=3\nb=4\na*b").eval(), [3, 4, 12]
    assert.deepEqual erdos.parse("b = 43; b * 4").eval(), [172]

  it "should throw an error if called with wrong number of arguments", ->
    assert.throws (->
      erdos.parse()
    ), SyntaxError
    assert.throws (->
      erdos.parse 1, 2, 3
    ), SyntaxError

  it "should throw an error if called with a wrong type of argument", ->
    assert.throws (->
      erdos.parse 23
    ), TypeError
    assert.throws (->
      erdos.parse erdos.unit("5cm")
    ), TypeError
    assert.throws (->
      erdos.parse new Complex(2, 3)
    ), TypeError
    assert.throws (->
      erdos.parse true
    ), TypeError

  
  # TODO: parse comments
  describe "number", ->
    it "should parse valid numbers", ->
      assert.equal parseAndEval("0"), 0
      assert.equal parseAndEval("3"), 3
      assert.equal parseAndEval("3.2"), 3.2
      assert.equal parseAndEval("003.2"), 3.2
      assert.equal parseAndEval("003.200"), 3.2
      assert.equal parseAndEval(".2"), 0.2
      assert.equal parseAndEval("2."), 2
      assert.equal parseAndEval("3e2"), 300
      assert.equal parseAndEval("300e2"), 30000
      assert.equal parseAndEval("300e+2"), 30000
      assert.equal parseAndEval("300e-2"), 3
      assert.equal parseAndEval("300E-2"), 3
      assert.equal parseAndEval("3.2e2"), 320

    it "should throw an error with invalid numbers", ->
      assert.throws (->
        parseAndEval "."
      ), SyntaxError
      assert.throws (->
        parseAndEval "3.2.2"
      ), SyntaxError
      assert.throws (->
        parseAndEval "3.2e2.2"
      ), SyntaxError
      assert.throws (->
        parseAndEval "32e"
      ), SyntaxError
      assert.throws (->
        parseAndEval "3abc"
      ), TypeError


  describe "bignumber", ->
    it "should parse bignumbers", ->
      assert.deepEqual parseAndEval("bignumber(0.1)"), erdos.bignumber(0.1)
      assert.deepEqual parseAndEval("bignumber(\"1.2e500\")"), erdos.bignumber("1.2e500")

    it "should output bignumbers if default number type is bignumber", ->
      erdos = erdosjs(number: "bignumber")
      assert.deepEqual erdos.parse("0.1").eval(), erdos.bignumber(0.1)
      assert.deepEqual erdos.parse("1.2e5000").eval(), erdos.bignumber("1.2e5000")


  describe "string", ->
    it "should parse a string", ->
      assert.deepEqual parseAndEval("\"hello\""), "hello"
      assert.deepEqual parseAndEval("   \"hi\" "), "hi"

    it "should throw an error with invalid strings", ->
      assert.throws (->
        parseAndEval "\"hi"
      ), SyntaxError
      assert.throws (->
        parseAndEval " hi\" "
      ), Error

    it "should get a string subset", ->
      scope = {}
      assert.deepEqual parseAndEval("c=\"hello\"", scope), "hello"
      assert.deepEqual parseAndEval("c(2:4)", scope), "ell"
      assert.deepEqual parseAndEval("c(5:-1:1)", scope), "olleh"
      assert.deepEqual parseAndEval("c(end-2:-1:1)", scope), "leh"

    it "should set a string subset", ->
      scope = {}
      assert.deepEqual parseAndEval("c=\"hello\"", scope), "hello"
      assert.deepEqual parseAndEval("c(1) = \"H\"", scope), "Hello"
      assert.deepEqual parseAndEval("c", scope), "Hello"
      assert.deepEqual parseAndEval("c(6:11) = \" world\"", scope), "Hello world"
      assert.deepEqual parseAndEval("c", scope), "Hello world"
      assert.deepEqual scope.c, "Hello world"


  describe "unit", ->
    it "should parse units", ->
      assert.deepEqual parseAndEval("5cm"), new Unit(5, "cm")
      assert.ok parseAndEval("5cm") instanceof Unit

    it "should correctly parse negative temperatures", ->
      approx.deepEqual parseAndEval("-6 celsius"), new Unit(-6, "celsius")
      approx.deepEqual parseAndEval("--6 celsius"), new Unit(6, "celsius")
      approx.deepEqual parseAndEval("-6 celsius in fahrenheit"), new Unit(21.2, "fahrenheit").inn("fahrenheit")

    it "should convert units", ->
      scope = {}
      approx.deepEqual parseAndEval("(5.08 cm * 1000) in inch", scope), erdos.unit(2000, "inch").inn("inch")
      approx.deepEqual parseAndEval("(5.08 cm * 1000) in mm", scope), erdos.unit(50800, "mm").inn("mm")
      approx.deepEqual parseAndEval("ans in inch", scope), erdos.unit(2000, "inch").inn("inch")
      approx.deepEqual parseAndEval("10 celsius in fahrenheit"), erdos.unit(50, "fahrenheit").inn("fahrenheit")
      approx.deepEqual parseAndEval("20 celsius in fahrenheit"), erdos.unit(68, "fahrenheit").inn("fahrenheit")
      approx.deepEqual parseAndEval("50 fahrenheit in celsius"), erdos.unit(10, "celsius").inn("celsius")

    it "should evaluate operator \"in\" with correct precedence ", ->
      approx.equal parseAndEval("5.08 cm * 1000 in inch").toNumber("inch"), new Unit(2000, "inch").toNumber("inch")

  describe "complex", ->
    it "should parse complex values", ->
      assert.deepEqual parseAndEval("i"), new Complex(0, 1)
      assert.deepEqual parseAndEval("2+3i"), new Complex(2, 3)
      assert.deepEqual parseAndEval("2+3*i"), new Complex(2, 3)

  describe "matrix", ->
    it "should parse a matrix", ->
      assert.ok parseAndEval("[1,2;3,4]") new Matrix
      m = parseAndEval("[1,2,3;4,5,6]")
      assert.deepEqual m.size(), [2, 3]
      assert.deepEqual m, new Matrix([[1, 2, 3], [4, 5, 6]])
      b = parseAndEval("[5, 6; 1, 1]")
      assert.deepEqual b.size(), [2, 2]
      assert.deepEqual b, new Matrix([[5, 6], [1, 1]])
      
      # from 1 to n dimensions
      assert.deepEqual parseAndEval("[ ]"), new Matrix([])
      assert.deepEqual parseAndEval("[1,2,3]"), new Matrix([1, 2, 3])
      assert.deepEqual parseAndEval("[1;2;3]"), new Matrix([[1], [2], [3]])
      assert.deepEqual parseAndEval("[[1,2],[3,4]]"), new Matrix([[1, 2], [3, 4]])
      assert.deepEqual parseAndEval("[[[1],[2]],[[3],[4]]]"), new Matrix([[[1], [2]], [[3], [4]]])

    it "should get a matrix subset", ->
      scope = a: new Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      assert.deepEqual parseAndEval("a(2, :)", scope), new Matrix([4, 5, 6])
      assert.deepEqual parseAndEval("a(2, :2)", scope), new Matrix([4, 5])
      assert.deepEqual parseAndEval("a(2, :end-1)", scope), new Matrix([4, 5])
      assert.deepEqual parseAndEval("a(2, 2:)", scope), new Matrix([5, 6])
      assert.deepEqual parseAndEval("a(2, 2:3)", scope), new Matrix([5, 6])
      assert.deepEqual parseAndEval("a(2, 1:2:3)", scope), new Matrix([4, 6])
      assert.deepEqual parseAndEval("a(:, 2)", scope), new Matrix([[2], [5], [8]])
      assert.deepEqual parseAndEval("a(:2, 2)", scope), new Matrix([[2], [5]])
      assert.deepEqual parseAndEval("a(:end-1, 2)", scope), new Matrix([[2], [5]])
      assert.deepEqual parseAndEval("a(2:, 2)", scope), new Matrix([[5], [8]])
      assert.deepEqual parseAndEval("a(2:3, 2)", scope), new Matrix([[5], [8]])
      assert.deepEqual parseAndEval("a(1:2:3, 2)", scope), new Matrix([[2], [8]])

    it "should parse matrix resizings", ->
      scope = {}
      assert.deepEqual parseAndEval("a = []", scope), new Matrix([])
      assert.deepEqual parseAndEval("a(1:3,1) = [1;2;3]", scope), new Matrix([[1], [2], [3]])
      assert.deepEqual parseAndEval("a(:,2) = [4;5;6]", scope), new Matrix([[1, 4], [2, 5], [3, 6]])
      assert.deepEqual parseAndEval("a = []", scope), new Matrix([])
      assert.deepEqual parseAndEval("a(1,3) = 3", scope), new Matrix([arr(uninit, uninit, 3)])
      assert.deepEqual parseAndEval("a(2,:) = [[4,5,6]]", scope), new Matrix([arr(uninit, uninit, 3), [4, 5, 6]])
      assert.deepEqual parseAndEval("a = []", scope), new Matrix([])
      assert.deepEqual parseAndEval("a(3,1) = 3", scope), new Matrix([arr(uninit), arr(uninit), [3]])
      assert.deepEqual parseAndEval("a(:,2) = [4;5;6]", scope), new Matrix([arr(uninit, 4), arr(uninit, 5), [3, 6]])
      assert.deepEqual parseAndEval("a = []", scope), new Matrix([])
      assert.deepEqual parseAndEval("a(1,1:3) = [[1,2,3]]", scope), new Matrix([[1, 2, 3]])
      assert.deepEqual parseAndEval("a(2,:) = [[4,5,6]]", scope), new Matrix([[1, 2, 3], [4, 5, 6]])

    it "should get/set the matrix correctly", ->
      scope = {}
      parseAndEval "a=[1,2;3,4]", scope
      parseAndEval "a(1,1) = 100", scope
      assert.deepEqual scope.a.size(), [2, 2]
      assert.deepEqual scope.a, new Matrix([[100, 2], [3, 4]])
      parseAndEval "a(2:3,2:3) = [10,11;12,13]", scope
      assert.deepEqual scope.a.size(), [3, 3]
      assert.deepEqual scope.a, new Matrix([arr(100, 2, uninit), [3, 10, 11], arr(uninit, 12, 13)])
      a = scope.a
      
      # note: after getting subset, uninitialized elements are replaced by elements with an undefined value
      assert.deepEqual a.subset(erdos.index([0, 3], [0, 2])), new Matrix([[100, 2], [3, 10], [undefined, 12]])
      assert.deepEqual parseAndEval("a(1:3,1:2)", scope), new Matrix([[100, 2], [3, 10], [undefined, 12]])
      scope.b = [[1, 2], [3, 4]]
      assert.deepEqual parseAndEval("b(1,:)", scope), [1, 2]

    it "should get/set the matrix correctly for 3d matrices", ->
      scope = {}
      assert.deepEqual parseAndEval("f=[1,2;3,4]", scope), new Matrix([[1, 2], [3, 4]])
      assert.deepEqual parseAndEval("size(f)", scope), new Matrix([2, 2])
      
      # TODO: doesn't work correctly
      #       assert.deepEqual(parseAndEval('f(:,:,1)=[5,6;7,8]', scope), new Matrix([
      #       [
      #       [1,2],
      #       [3,4]
      #       ],
      #       [
      #       [5,6],
      #       [7,8]
      #       ]
      #       ]));
      #       
      scope.f = new Matrix([[[1, 5], [2, 6]], [[3, 7], [4, 8]]])
      assert.deepEqual parseAndEval("size(f)", scope), new Matrix([2, 2, 2])
      assert.deepEqual parseAndEval("f(:,:,1)", scope), new Matrix([[[1], [2]], [[3], [4]]])
      assert.deepEqual parseAndEval("f(:,:,2)", scope), new Matrix([[[5], [6]], [[7], [8]]])
      assert.deepEqual parseAndEval("f(:,2,:)", scope), new Matrix([[[2, 6]], [[4, 8]]])
      assert.deepEqual parseAndEval("f(2,:,:)", scope), new Matrix([[3, 7], [4, 8]])
      parseAndEval "a=diag([1,2,3,4])", scope
      assert.deepEqual parseAndEval("a(3:end, 3:end)", scope), new Matrix([[3, 0], [0, 4]])
      assert.deepEqual parseAndEval("a(3:end, 2:end)=9*ones(2,3)", scope), new Matrix([[1, 0, 0, 0], [0, 2, 0, 0], [0, 9, 9, 9], [0, 9, 9, 9]])
      assert.deepEqual parseAndEval("a(2:end-1, 2:end-1)", scope), new Matrix([[2, 0], [9, 9]])

    it "should merge nested matrices", ->
      scope = {}
      parseAndEval "a=[1,2;3,4]", scope

    it "should parse matrix concatenations", ->
      scope = {}
      parseAndEval "a=[1,2;3,4]", scope
      parseAndEval "b=[5,6;7,8]", scope
      assert.deepEqual parseAndEval("c=concat(a,b)", scope), new Matrix([[1, 2, 5, 6], [3, 4, 7, 8]])
      assert.deepEqual parseAndEval("c=concat(a,b,0)", scope), new Matrix([[1, 2], [3, 4], [5, 6], [7, 8]])
      assert.deepEqual parseAndEval("c=concat(concat(a,b), concat(b,a), 0)", scope), new Matrix([[1, 2, 5, 6], [3, 4, 7, 8], [5, 6, 1, 2], [7, 8, 3, 4]])
      assert.deepEqual parseAndEval("c=concat([[1,2]], [[3,4]], 0)", scope), new Matrix([[1, 2], [3, 4]])
      assert.deepEqual parseAndEval("c=concat([[1]], [2;3], 0)", scope), new Matrix([[1], [2], [3]])
      assert.deepEqual parseAndEval("d=1:3", scope), new Matrix([1, 2, 3])
      assert.deepEqual parseAndEval("concat(d,d)", scope), new Matrix([1, 2, 3, 1, 2, 3])
      assert.deepEqual parseAndEval("e=1+d", scope), new Matrix([2, 3, 4])
      assert.deepEqual parseAndEval("size(e)", scope), new Matrix([3])
      assert.deepEqual parseAndEval("concat(e,e)", scope), new Matrix([2, 3, 4, 2, 3, 4])
      assert.deepEqual parseAndEval("[[],[]]", scope), new Matrix([[], []])
      assert.deepEqual parseAndEval("[[],[]]", scope).size(), [2, 0]
      assert.deepEqual parseAndEval("size([[],[]])", scope), new Matrix([2, 0])

    it "should throw an error for invalid matrix concatenations", ->
      scope = {}
      assert.throws ->
        parseAndEval "c=concat(a, [1,2,3])", scope

  describe "boolean", ->
    it "should parse boolean values", ->
      assert.equal parseAndEval("true"), true
      assert.equal parseAndEval("false"), false

  describe "constants", ->
    it "should parse constants", ->
      assert.deepEqual parseAndEval("i"), new Complex(0, 1)
      approx.equal parseAndEval("pi"), Math.PI
      approx.equal parseAndEval("e"), Math.E

  describe "variables", ->
    it "should parse valid variable assignments", ->
      scope = {}
      assert.equal parseAndEval("a = 0.75", scope), 0.75
      assert.equal parseAndEval("a + 2", scope), 2.75
      assert.equal parseAndEval("a = 2", scope), 2
      assert.equal parseAndEval("a + 2", scope), 4
      approx.equal parseAndEval("pi * 2", scope), 6.283185307179586

    it "should throw an error on undefined symbol", ->
      assert.throws ->
        parseAndEval "qqq + 2"

    it "should throw an error on invalid assignments", ->    
      #assert.throws(function () {parseAndEval('sin(2) = 0.75')}, SyntaxError); // TODO: should this throw an exception?
      assert.throws (->
        parseAndEval "sin + 2 = 3"
      ), SyntaxError

    it "should parse nested assignments", ->
      scope = []
      assert.equal parseAndEval("c = d = (e = 4.5)", scope), 4.5
      assert.equal scope.c, 4.5
      assert.equal scope.d, 4.5
      assert.equal scope.e, 4.5
      assert.deepEqual parseAndEval("a = [1,2,f=3]", scope), new Matrix([1, 2, 3])
      assert.equal scope.f, 3
      assert.equal parseAndEval("2 + (g = 3 + 4)", scope), 9
      assert.equal scope.g, 7

    it "should throw an error for invalid nested assignments", ->
      assert.throws (->
        parseAndEval "a(j = 3)", {}
      ), SyntaxError

  describe "functions", ->
    it "should parse functions", ->
      assert.equal parseAndEval("sqrt(4)"), 2
      assert.equal parseAndEval("sqrt(6+3)"), 3
      assert.equal parseAndEval("atan2(2,2)"), 0.7853981633974483
      assert.deepEqual parseAndEval("sqrt(-4)"), new Complex(0, 2)
      assert.equal parseAndEval("abs(-4.2)"), 4.2
      assert.equal parseAndEval("add(2, 3)"), 5
      approx.deepEqual parseAndEval("1+exp(pi*i)"), new Complex(0, 0)
      assert.equal parseAndEval("unequal(2, 3)"), true

    it "should parse function assignments", ->
      scope = {}
      parseAndEval "x=100", scope # for testing scoping of the function variables
      assert.equal parseAndEval("function f(x) = x^2", scope).syntax, "f(x)"
      assert.equal parseAndEval("f(3)", scope), 9
      assert.equal scope.f(3), 9
      assert.equal scope.x, 100
      assert.equal parseAndEval("function g(x, y) = x^y", scope).syntax, "g(x, y)"
      assert.equal parseAndEval("g(4,5)", scope), 1024
      assert.equal scope.g(4, 5), 1024

    it "should correctly evaluate variables in assigned functions", ->
      scope = {}
      assert.equal parseAndEval("a = 3", scope), 3
      assert.equal parseAndEval("function f(x) = a * x", scope).syntax, "f(x)"
      assert.equal parseAndEval("f(2)", scope), 6
      assert.equal parseAndEval("a = 5", scope), 5
      assert.equal parseAndEval("f(2)", scope), 10
      assert.equal parseAndEval("function g(x) = x^q", scope).syntax, "g(x)"
      assert.equal parseAndEval("q = 4/2", scope), 2
      assert.equal parseAndEval("g(3)", scope), 9

    it "should throw an error for undefined variables in an assigned function", ->
      scope = {}
      assert.equal parseAndEval("function g(x) = x^q", scope).syntax, "g(x)"
      assert.throws (->
        parseAndEval "g(3)", scope
      ), (err) ->
        (err instanceof Error) and (err.toString() is "Error: Undefined symbol q")



  describe "parentheses", ->
    it "should parse parentheses overriding the default precedence", ->
      approx.equal parseAndEval("2 - (2 - 2)"), 2
      approx.equal parseAndEval("2 - ((2 - 2) - 2)"), 4
      approx.equal parseAndEval("3 * (2 + 3)"), 15
      approx.equal parseAndEval("(2 + 3) * 3"), 15


  describe "operators", ->
    it "should parse operations", ->
      approx.equal parseAndEval("(2+3)/4"), 1.25
      approx.equal parseAndEval("2+3/4"), 2.75
      assert.equal erdos.parse("0 + 2").toString(), "ans = 0 + 2"

    it "should parse +", ->
      assert.equal parseAndEval("2 + 3"), 5
      assert.equal parseAndEval("2 + 3 + 4"), 9

    it "should parse /", ->
      assert.equal parseAndEval("4 / 2"), 2
      assert.equal parseAndEval("8 / 2 / 2"), 2

    it "should parse ./", ->
      assert.equal parseAndEval("4./2"), 2
      assert.equal parseAndEval("4 ./ 2"), 2
      assert.equal parseAndEval("8 ./ 2 / 2"), 2
      assert.deepEqual parseAndEval("[1,2,3] ./ [1,2,3]"), new Matrix([1, 1, 1])

    it "should parse .*", ->
      approx.deepEqual parseAndEval("2.*3"), 6
      approx.deepEqual parseAndEval("2 .* 3"), 6
      approx.deepEqual parseAndEval("2. * 3"), 6
      approx.deepEqual parseAndEval("4 .* 2"), 8
      approx.deepEqual parseAndEval("8 .* 2 .* 2"), 32
      assert.deepEqual parseAndEval("a=3; a.*4"), [12]
      assert.deepEqual parseAndEval("[1,2,3] .* [1,2,3]"), new Matrix([1, 4, 9])

    it "should parse .^", ->
      approx.deepEqual parseAndEval("2.^3"), 8
      approx.deepEqual parseAndEval("2 .^ 3"), 8
      assert.deepEqual parseAndEval("2. ^ 3"), 8
      approx.deepEqual parseAndEval("-2.^2"), -4 # -(2^2)
      approx.deepEqual parseAndEval("2.^3.^4"), 2.41785163922926e+24 # 2^(3^4)
      assert.deepEqual parseAndEval("[2,3] .^ [2,3]"), new Matrix([4, 27])

    it "should parse ==", ->
      assert.equal parseAndEval("2 == 3"), false
      assert.equal parseAndEval("2 == 2"), true

    it "should parse >", ->
      assert.equal parseAndEval("2 > 3"), false
      assert.equal parseAndEval("2 > 2"), false
      assert.equal parseAndEval("2 > 1"), true

    it "should parse >=", ->
      assert.equal parseAndEval("2 >= 3"), false
      assert.equal parseAndEval("2 >= 2"), true
      assert.equal parseAndEval("2 >= 1"), true

    it "should parse %", ->
      approx.equal parseAndEval("8 % 3"), 2

    it "should parse mod", ->
      approx.equal parseAndEval("8 mod 3"), 2

    it "should parse *", ->
      approx.equal parseAndEval("4 * 2"), 8
      approx.equal parseAndEval("8 * 2 * 2"), 32

    it "should parse ^", ->
      approx.equal parseAndEval("2^3"), 8
      approx.equal parseAndEval("-2^2"), -4 # -(2^2)
      approx.equal parseAndEval("2^3^4"), 2.41785163922926e+24 # 2^(3^4)

    it "should parse <", ->
      assert.equal parseAndEval("2 < 3"), true
      assert.equal parseAndEval("2 < 2"), false
      assert.equal parseAndEval("2 < 1"), false

    it "should parse <=", ->
      assert.equal parseAndEval("2 <= 3"), true
      assert.equal parseAndEval("2 <= 2"), true
      assert.equal parseAndEval("2 <= 1"), false

    it "should parse -", ->
      assert.equal parseAndEval("4 - 2"), 2
      assert.equal parseAndEval("8 - 2 - 2"), 4

    it "should parse unary -", ->
      assert.equal parseAndEval("-2"), -2
      assert.equal parseAndEval("4*-2"), -8
      assert.equal parseAndEval("4 * -2"), -8
      assert.equal parseAndEval("4+-2"), 2
      assert.equal parseAndEval("4 + -2"), 2
      assert.equal parseAndEval("4--2"), 6
      assert.equal parseAndEval("4 - -2"), 6
      assert.equal parseAndEval("5-3"), 2
      assert.equal parseAndEval("5--3"), 8
      assert.equal parseAndEval("5---3"), 2
      assert.equal parseAndEval("5+---3"), 2
      assert.equal parseAndEval("5----3"), 8
      assert.equal parseAndEval("5+--(2+1)"), 8

    it "should parse unary !=", ->
      assert.equal parseAndEval("2 != 3"), true
      assert.equal parseAndEval("2 != 2"), false

    it "should parse : (range)", ->
      assert.ok parseAndEval("2:5") new Matrix
      assert.deepEqual parseAndEval("2:5"), new Matrix([2, 3, 4, 5])
      assert.deepEqual parseAndEval("10:-2:0"), new Matrix([10, 8, 6, 4, 2, 0])
      assert.deepEqual parseAndEval("2:4.0"), new Matrix([2, 3, 4])
      assert.deepEqual parseAndEval("2:4.5"), new Matrix([2, 3, 4])
      assert.deepEqual parseAndEval("2:4.1"), new Matrix([2, 3, 4])
      assert.deepEqual parseAndEval("2:3.9"), new Matrix([2, 3])
      assert.deepEqual parseAndEval("2:3.5"), new Matrix([2, 3])
      assert.deepEqual parseAndEval("3:-1:0.5"), new Matrix([3, 2, 1])
      assert.deepEqual parseAndEval("3:-1:0.5"), new Matrix([3, 2, 1])
      assert.deepEqual parseAndEval("3:-1:0.1"), new Matrix([3, 2, 1])
      assert.deepEqual parseAndEval("3:-1:-0.1"), new Matrix([3, 2, 1, 0])

    it "should parse in", ->
      approx.deepEqual parseAndEval("2.54 cm in inch"), erdos.unit(1, "inch").inn("inch")
      approx.deepEqual parseAndEval("2.54 cm + 2 inch in foot"), erdos.unit(0.25, "foot").inn("foot")

    it "should parse ' (transpose)", ->
      assert.deepEqual parseAndEval("23'"), 23
      assert.deepEqual parseAndEval("[1,2,3;4,5,6]'"), new Matrix([[1, 4], [2, 5], [3, 6]])
      assert.ok parseAndEval("[1,2,3;4,5,6]'") new Matrix
      assert.deepEqual parseAndEval("[1:5]"), new Matrix([[1, 2, 3, 4, 5]])
      assert.deepEqual parseAndEval("[1:5]'"), new Matrix([[1], [2], [3], [4], [5]])
      assert.deepEqual parseAndEval("size([1:5])"), new Matrix([1, 5])
      assert.deepEqual parseAndEval("[1,2;3,4]'"), new Matrix([[1, 3], [2, 4]])

    it "should respect operator precedence", ->
      assert.equal parseAndEval("4-2+3"), 5
      assert.equal parseAndEval("4-(2+3)"), -1
      assert.equal parseAndEval("4-2-3"), -1
      assert.equal parseAndEval("4-(2-3)"), 5
      assert.equal parseAndEval("2+3*4"), 14
      assert.equal parseAndEval("2*3+4"), 10
      assert.equal parseAndEval("2*3^2"), 18
      assert.equal parseAndEval("2^3"), 8
      assert.equal parseAndEval("2^3^4"), Math.pow(2, Math.pow(3, 4))
      assert.equal parseAndEval("1.5^1.5^1.5"), parseAndEval("1.5^(1.5^1.5)")
      assert.equal parseAndEval("1.5^1.5^1.5^1.5"), parseAndEval("1.5^(1.5^(1.5^1.5))")
      assert.equal parseAndEval("-3^2"), -9
      assert.equal parseAndEval("(-3)^2"), 9
      assert.equal parseAndEval("2^3!"), 64
      assert.equal parseAndEval("2^(3!)"), 64
      assert.equal parseAndEval("-4!"), -24
      assert.equal parseAndEval("3!+2"), 8


  
  # TODO: extensively test operator precedence
  describe "functions", ->
    describe "functions", ->
      it "should evaluate function \"mod\"", ->
        approx.equal parseAndEval("mod(8, 3)"), 2

      it "should evaluate function \"in\" ", ->
        approx.deepEqual parseAndEval("in(5.08 cm * 1000, inch)"), erdos.unit(2000, "inch").inn("inch")



  describe "bignumber", ->
    bigerdos = erdosjs(number: "bignumber")
    it "should parse numbers as bignumber", ->
      assert.deepEqual bigerdos.eval("2.3"), new BigNumber("2.3")
      assert.deepEqual bigerdos.eval("2.3e+500"), new BigNumber("2.3e+500")

    it "should evaluate functions supporting bignumbers", ->
      assert.deepEqual bigerdos.eval("0.1 + 0.2"), new BigNumber("0.3")

    it "should evaluate functions supporting bignumbers", ->
      assert.deepEqual bigerdos.eval("add(0.1, 0.2)"), new BigNumber("0.3")

    it "should work with mixed numbers and bignumbers", ->
      approx.equal bigerdos.eval("pi + 1"), 4.141592653589793

    it "should evaluate functions not supporting bignumbers", ->
      approx.equal bigerdos.eval("sin(0.1)"), 0.09983341664682815

    it "should create a range from bignumbers (downgrades to numbers)", ->
      assert.deepEqual bigerdos.eval("4:6"), bigerdos.matrix([4, 5, 6])
      assert.deepEqual bigerdos.eval("0:2:4"), bigerdos.matrix([0, 2, 4])

    it "should create a matrix with bignumbers", ->
      assert.deepEqual bigerdos.eval("[0.1, 0.2]"), bigerdos.matrix([new BigNumber(0.1), new BigNumber(0.2)])

    it "should get a elements from a matrix with bignumbers", ->
      scope = {}
      assert.deepEqual bigerdos.eval("a=[0.1, 0.2]", scope), bigerdos.matrix([new BigNumber(0.1), new BigNumber(0.2)])
      assert.deepEqual bigerdos.eval("a(1)", scope), new BigNumber(0.1)
      assert.deepEqual bigerdos.eval("a(:)", scope), bigerdos.matrix([new BigNumber(0.1), new BigNumber(0.2)])
      assert.deepEqual bigerdos.eval("a(1:2)", scope), bigerdos.matrix([new BigNumber(0.1), new BigNumber(0.2)])

    it "should replace elements in a matrix with bignumbers", ->
      scope = {}
      assert.deepEqual bigerdos.eval("a=[0.1, 0.2]", scope), bigerdos.matrix([new BigNumber(0.1), new BigNumber(0.2)])
      assert.deepEqual bigerdos.eval("a(1) = 0.3", scope), bigerdos.matrix([new BigNumber(0.3), new BigNumber(0.2)])
      assert.deepEqual bigerdos.eval("a(:) = [0.5, 0.6]", scope), bigerdos.matrix([new BigNumber(0.5), new BigNumber(0.6)])
      assert.deepEqual bigerdos.eval("a(1:2) = [0.7, 0.8]", scope), bigerdos.matrix([new BigNumber(0.7), new BigNumber(0.8)])

    it "should work with complex numbers (downgrades bignumbers to number)", ->
      assert.deepEqual bigerdos.eval("3i"), new Complex(0, 3)
      assert.deepEqual bigerdos.eval("2 + 3i"), new Complex(2, 3)
      assert.deepEqual bigerdos.eval("2 * i"), new Complex(0, 2)

    it "should work with units (downgrades bignumbers to number)", ->
      assert.deepEqual bigerdos.eval("2 cm"), new Unit(2, "cm")


  describe "scope", ->
    it "should use a given scope for assignments", ->
      scope =
        a: 3
        b: 4

      assert.deepEqual erdos.parse("a*b", scope).eval(), 12
      assert.deepEqual erdos.parse("c=5", scope).eval(), 5
      assert.deepEqual erdos.parse("function f(x) = x^a", scope).eval().syntax, "f(x)"
      assert.deepEqual Object.keys(scope).length, 5
      assert.deepEqual scope.a, 3
      assert.deepEqual scope.b, 4
      assert.deepEqual scope.c, 5
      assert.deepEqual typeof scope.f, "function"
      assert.deepEqual typeof scope.ans, "function"
      assert.strictEqual scope.f, scope.ans
      assert.equal scope.f(3), 27
      scope.a = 2
      assert.equal scope.f(3), 9
      scope.hello = (name) ->
        "hello, " + name + "!"

      assert.deepEqual erdos.parse("hello(\"jos\")", scope).eval(), "hello, jos!"

    it "should parse undefined symbols, defining symbols, and removing symbols", ->
      scope = {}
      n = erdos.parse("q", scope)
      assert.throws ->
        n.eval()

      erdos.parse("q=33", scope).eval()
      assert.equal n.eval(), 33
      delete scope.q

      assert.throws ->
        n.eval()

      n = erdos.parse("qq(1,1)=33", scope)
      assert.throws ->
        n.eval()

      erdos.parse("qq=[1,2;3,4]", scope).eval()
      assert.deepEqual n.eval(), new Matrix([[33, 2], [3, 4]])
      erdos.parse("qq=[4]", scope).eval()
      assert.deepEqual n.eval(), new Matrix([[33]])
      delete scope.qq

      assert.throws ->
        n.eval()

  describe "node tree", ->
    
    # TODO: test parsing into a node tree
    it "should correctly stringify a node tree", ->
      assert.equal erdos.parse("0").toString(), "ans = 0"
      assert.equal erdos.parse("\"hello\"").toString(), "ans = \"hello\""
      assert.equal erdos.parse("[1, 2 + 3i, 4]").toString(), "ans = [1, 2 + 3i, 4]"

    it "should support custom node handlers", ->
      CustomNode = (params, paramScopes) ->
        @params = params
        @paramScopes = paramScopes
      CustomNode:: = new expression.node.Node()
      CustomNode::toString = ->
        "CustomNode"

      CustomNode::eval = ->
        strParams = []
        @params.forEach (param) ->
          strParams.push param.toString()

        "CustomNode(" + strParams.join(", ") + ")"

      erdos.expression.node.handlers["custom"] = CustomNode
      node = erdos.parse("custom(x, (2+x), sin(x))")
      assert.equal node.eval(), "CustomNode(x, 2 + x, sin(x))"

assert   = require("assert")
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

Matrix = erdos.Matrix
index = erdos.index

describe "matrix", ->
  describe "constructor", ->
    it "should build an emtpy if called with no argument", ->
      m = new Matrix()
      assert.deepEqual m.toArray(), []

  describe "size", ->
    it "should return the expected size", ->
      assert.deepEqual new Matrix().size(), [0]
      assert.deepEqual new Matrix([[23]]).size(), [1, 1]
      assert.deepEqual new Matrix([[1, 2, 3], [4, 5, 6]]).size(), [2, 3]
      assert.deepEqual new Matrix([1, 2, 3]).size(), [3]
      assert.deepEqual new Matrix([[1], [2], [3]]).size(), [3, 1]
      assert.deepEqual new Matrix([[[1], [2], [3]]]).size(), [1, 3, 1]
      assert.deepEqual new Matrix([[[3]]]).size(), [1, 1, 1]
      assert.deepEqual new Matrix([[]]).size(), [1, 0]

  it "toString", ->
    assert.equal new Matrix([[1, 2], [3, 4]]).toString(), "[[1, 2], [3, 4]]"
    assert.equal new Matrix([[1, 2], [3, 1 / 3]]).toString(), "[[1, 2], [3, 0.3333333333333333]]"

  it "format", ->
    assert.equal new Matrix([[1, 2], [3, 1 / 3]]).format(), "[[1, 2], [3, 0.3333333333333333]]"
    assert.equal new Matrix([[1, 2], [3, 1 / 3]]).format(3), "[[1, 2], [3, 0.333]]"
    assert.equal new Matrix([[1, 2], [3, 1 / 3]]).format(4), "[[1, 2], [3, 0.3333]]"

  describe "resize", ->
    it "should resize the matrix correctly", ->
      m = new Matrix([[1, 2, 3], [4, 5, 6]])
      m.resize [1, 2]
      assert.deepEqual m.valueOf(), [[1, 2]]

      m.resize [1, 2, 2], 8
      assert.deepEqual m.valueOf(), [[[1, 2], [8, 8]]]
      m.resize [2, 3], 9
      assert.deepEqual m.valueOf(), [[1, 2, 9], [8, 8, 9]]

      m = new Matrix()
      m.resize [3, 3, 3], 6
      assert.deepEqual m.valueOf(), [[[6, 6, 6], [6, 6, 6], [6, 6, 6]], [[6, 6, 6], [6, 6, 6], [6, 6, 6]], [[6, 6, 6], [6, 6, 6], [6, 6, 6]]]
      m.resize [2, 2]
      assert.deepEqual m.valueOf(), [[6, 6], [6, 6]]
      m.resize [0]
      assert.deepEqual m.valueOf(), []

  describe "get", ->
    m = new Matrix([[0, 1], [2, 3]])
    it "should get a value from the matrix", ->
      assert.equal m.get([1, 0]), 2
      assert.equal m.get([0, 1]), 1

    it "should throw an error when getting a value out of range", ->
      assert.throws ->
        m.get [3, 0]

      assert.throws ->
        m.get [1, 5]

      assert.throws ->
        m.get [1]

      assert.throws ->
        m.get []


    it "should throw an error when getting a value given a invalid index", ->
      assert.throws ->
        m.get [1.2, 2]

      assert.throws ->
        m.get [1, -2]

      assert.throws ->
        m.get 1, 1

      assert.throws ->
        m.get erdos.index(1, 1)

      assert.throws ->
        m.get [[1, 1]]

  describe "set", ->
    it "should set a value in a matrix", ->
      m = new Matrix([[0, 0], [0, 0]])
      m.set [1, 0], 5
      assert.deepEqual m, new Matrix([[0, 0], [5, 0]])
      m.set [0, 2], 4
      assert.deepEqual m, new Matrix([[0, 0, 4], arr(5, 0, uninit)])
      m.set [1, 0, 0], 3
      assert.deepEqual m, new Matrix([[[0, 0, 4], arr(5, 0, uninit)], [arr(3, uninit, uninit), arr(uninit, uninit, uninit)]])

    it "should set a value in a matrix with defaultValue for new elements", ->
      m = new Matrix()
      defaultValue = 0
      m.set [2], 4, defaultValue
      assert.deepEqual m, new Matrix([0, 0, 4])

    it "should throw an error when setting a value given a invalid index", ->
      m = new Matrix([[0, 0], [0, 0]])
      assert.throws ->
        m.set [2.5, 0], 5

      assert.throws ->
        m.set [1], 5

      assert.throws ->
        m.set [-1, 1], 5

      assert.throws ->
        m.set erdos.index([0, 0]), 5

  # TODO: replace all assert.deepEqual(a.valueOf(), [...]) with assert.deepEqual(a, new Matrix([...]))
  describe "get subset", ->
    it "should get the right subset of the matrix", ->
      m = undefined
      
      # get 1-dimensional
      m = new Matrix(erdos.range(0, 10))
      assert.deepEqual m.size(), [10]
      assert.deepEqual m.subset(index([2, 5])).valueOf(), [2, 3, 4]
      
      # get 2-dimensional
      m = new Matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
      assert.deepEqual m.size(), [3, 3]
      assert.deepEqual m.subset(index(1, 1)), 5
      assert.deepEqual m.subset(index([0, 2], [0, 2])).valueOf(), [[1, 2], [4, 5]]
      assert.deepEqual m.subset(index(1, [1, 3])).valueOf(), [5, 6]
      assert.deepEqual m.subset(index(0, [1, 3])).valueOf(), [2, 3]
      assert.deepEqual m.subset(index([1, 3], 1)).valueOf(), [[5], [8]]
      assert.deepEqual m.subset(index([1, 3], 2)).valueOf(), [[6], [9]]
      
      # get n-dimensional
      m = new Matrix([[[1, 2], [3, 4]], [[5, 6], [7, 8]]])
      assert.deepEqual m.size(), [2, 2, 2]
      assert.deepEqual m.subset(index([0, 2], [0, 2], [0, 2])).valueOf(), m.valueOf()
      assert.deepEqual m.subset(index(0, 0, 0)), 1
      assert.deepEqual m.subset(index(1, 1, 1)).valueOf(), 8
      assert.deepEqual m.subset(index(1, 1, [0, 2])).valueOf(), [7, 8]
      assert.deepEqual m.subset(index(1, [0, 2], 1)).valueOf(), [[6], [8]]

    it "should throw an error if the given subset is invalid", ->
      m = new Matrix()
      assert.throws ->
        m.subset [-1]

      m = new Matrix([[1, 2, 3], [4, 5, 6]])
      assert.throws ->
        m.subset [1, 2, 3]

      assert.throws ->
        m.subset [3, 0]

      assert.throws ->
        m.subset [1]

  describe "set subset", ->
    it "should set the given subset", ->
      
      # set 1-dimensional
      m = new Matrix(erdos.range(0, 7))
      m.subset index([2, 4]), [20, 30]
      assert.deepEqual m, new Matrix([0, 1, 20, 30, 4, 5, 6])
      m.subset index(4), 40
      assert.deepEqual m, new Matrix([0, 1, 20, 30, 40, 5, 6])
      
      # set 2-dimensional
      m = new Matrix()
      m.resize [3, 3]
      assert.deepEqual m, new Matrix([arr(uninit, uninit, uninit), arr(uninit, uninit, uninit), arr(uninit, uninit, uninit)])
      m.subset index([1, 3], [1, 3]), [[1, 2], [3, 4]]
      assert.deepEqual m, new Matrix([arr(uninit, uninit, uninit), arr(uninit, 1, 2), arr(uninit, 3, 4)])
      m.subset index(0, [0, 3]), [5, 6, 7] # unsqueezes the submatrix
      assert.deepEqual m, new Matrix([[5, 6, 7], arr(uninit, 1, 2), arr(uninit, 3, 4)])

    it "should set the given subset with defaultValue for new elements", ->
      
      # multiple values
      m = new Matrix()
      defaultValue = 0
      m.subset index([3, 5]), [3, 4], defaultValue
      assert.deepEqual m, new Matrix([0, 0, 0, 3, 4])
      defaultValue = 1
      m.subset index(1, [3, 5]), [5, 6], defaultValue
      assert.deepEqual m, new Matrix([[0, 0, 0, 3, 4], [1, 1, 1, 5, 6]])
      defaultValue = 2
      m.subset index(2, [3, 5]), [7, 8], defaultValue
      assert.deepEqual m, new Matrix([[0, 0, 0, 3, 4], [1, 1, 1, 5, 6], [2, 2, 2, 7, 8]])
      
      # a single value
      i = erdos.matrix()
      defaultValue = 0
      i.subset erdos.index(2, 1), 6, defaultValue
      assert.deepEqual i, new Matrix([[0, 0], [0, 0], [0, 6]])

    it "should resize the matrix if the replacement subset is different size than selected subset", ->
      
      # set 2-dimensional with resize
      m = new Matrix([[123]])
      m.subset index([1, 3], [1, 3]), [[1, 2], [3, 4]]
      assert.deepEqual m, new Matrix([arr(123, uninit, uninit), arr(uninit, 1, 2), arr(uninit, 3, 4)])
      
      # set resize dimensions
      m = new Matrix([123])
      assert.deepEqual m.size(), [1]
      m.subset index([1, 3], [1, 3]), [[1, 2], [3, 4]]
      assert.deepEqual m, new Matrix([arr(123, uninit, uninit), arr(uninit, 1, 2), arr(uninit, 3, 4)])
      m.subset index([0, 2], [0, 2]), [[55, 55], [55, 55]]
      assert.deepEqual m, new Matrix([arr(55, 55, uninit), [55, 55, 2], arr(uninit, 3, 4)])
      m = new Matrix()
      m.subset index([1, 3], [1, 3], [1, 3]), [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
      res = new Matrix([[arr(uninit, uninit, uninit), arr(uninit, uninit, uninit), arr(uninit, uninit, uninit)], [arr(uninit, uninit, uninit), arr(uninit, 1, 2), arr(uninit, 3, 4)], [arr(uninit, uninit, uninit), arr(uninit, 5, 6), arr(uninit, 7, 8)]])
      assert.deepEqual m, res

  describe "map", ->
    it "should apply the given function to all elements in the matrix", ->
      m = undefined
      m2 = undefined
      m = new Matrix([[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]], [[13, 14], [15, 16]]])
      m2 = m.map((value) ->
        value * 2
      )
      assert.deepEqual m2.valueOf(), [[[2, 4], [6, 8]], [[10, 12], [14, 16]], [[18, 20], [22, 24]], [[26, 28], [30, 32]]]
      m = new Matrix([1])
      m2 = m.map((value) ->
        value * 2
      )
      assert.deepEqual m2.valueOf(), [2]
      m = new Matrix([1, 2, 3])
      m2 = m.map((value) ->
        value * 2
      )
      assert.deepEqual m2.valueOf(), [2, 4, 6]

    it "should work on empty matrices", ->
      m = undefined
      m2 = undefined
      m = new Matrix([])
      m2 = m.map((value) ->
        value * 2
      )
      assert.deepEqual m2.valueOf(), []

    it "should invoke callback with parameters value, index, obj", ->
      m = new Matrix([[1, 2, 3], [4, 5, 6]])
      assert.deepEqual m.map((value, index, obj) ->
        erdos.clone [value, index, obj is m]
      ).valueOf(), [[[1, [0, 0], true], [2, [0, 1], true], [3, [0, 2], true]], [[4, [1, 0], true], [5, [1, 1], true], [6, [1, 2], true]]]

  describe "forEach", ->
    it "should run on all elements of the matrix, last dimension first", ->
      m = undefined
      output = undefined
      m = new Matrix([[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]], [[13, 14], [15, 16]]])
      output = []
      m.forEach (value) ->
        output.push value

      assert.deepEqual output, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
      m = new Matrix([1])
      output = []
      m.forEach (value) ->
        output.push value

      assert.deepEqual output, [1]
      m = new Matrix([1, 2, 3])
      output = []
      m.forEach (value) ->
        output.push value

      assert.deepEqual output, [1, 2, 3]

    it "should work on empty matrices", ->
      m = new Matrix([])
      output = []
      m.forEach (value) ->
        output.push value

      assert.deepEqual output, []

    it "should invoke callback with parameters value, index, obj", ->
      m = new Matrix([[1, 2, 3], [4, 5, 6]])
      output = []
      m.forEach (value, index, obj) ->
        output.push erdos.clone([value, index, obj is m])

      assert.deepEqual output, [[1, [0, 0], true], [2, [0, 1], true], [3, [0, 2], true], [4, [1, 0], true], [5, [1, 1], true], [6, [1, 2], true]]

  describe "clone", ->
    it "should clone the matrix properly", ->
      m = new Matrix([[1, 2, 3], [4, 5, 6]])
      m4 = m.clone()
      assert.deepEqual m4.size(), [2, 3]
      assert.deepEqual m4.valueOf(), [[1, 2, 3], [4, 5, 6]]

###
# Helper function to create an Array containing uninitialized values
# Example: arr(uninit, uninit, 2);    // [ , , 2 ]
###
uninit = {}
arr = ->
  array = []
  array.length = arguments.length
  i = 0

  while i < arguments.length
    value = arguments[i]
    array[i] = value  if value isnt uninit
    i++
  array

assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

array  = require("../../lib/util/array")
resize = array.resize
size   = array.size

describe "util.Array", ->
  describe "size", ->
    it "should calculate the size of a scalar", ->
      assert.deepEqual size(2), []
      assert.deepEqual size("string"), []

    it "should calculate the size of a 1-dimensional array", ->
      assert.deepEqual size([]), [0]
      assert.deepEqual size([1]), [1]
      assert.deepEqual size([1, 2, 3]), [3]

    it "should calculate the size of a 2-dimensional array", ->
      assert.deepEqual size([[]]), [1, 0]
      assert.deepEqual size([[], []]), [2, 0]
      assert.deepEqual size([[1, 2], [3, 4]]), [2, 2]
      assert.deepEqual size([[1, 2, 3], [4, 5, 6]]), [2, 3]

    it "should calculate the size of a 3-dimensional array", ->
      assert.deepEqual size([[[]]]), [1, 1, 0]
      assert.deepEqual size([[[], []]]), [1, 2, 0]
      assert.deepEqual size([[[], []], [[], []]]), [2, 2, 0]
      assert.deepEqual size([[[1], [2]], [[3], [4]]]), [2, 2, 1]
      assert.deepEqual size([[[1, 2], [3, 4]], [[5, 6], [7, 8]]]), [2, 2, 2]
      assert.deepEqual size([[[1, 2, 3, 4], [5, 6, 7, 8]], [[1, 2, 3, 4], [5, 6, 7, 8]], [[1, 2, 3, 4], [5, 6, 7, 8]]]), [3, 2, 4]

  describe "resize", ->
    it "should resize a 1 dimensional array", ->
      a = []
      
      # resize with default value
      a = resize(a, [3], 100)
      assert.deepEqual a, [100, 100, 100]
      
      # resize without default value
      a = resize(a, [5])
      assert.deepEqual a, arr(100, 100, 100, uninit, uninit)
      a = resize(a, [2])
      assert.deepEqual a, [100, 100]

    it "should resize a 2 dimensional array", ->
      a = [[0, 1], [2, 3]]
      a = resize(a, [2, 4])
      assert.deepEqual a, [arr(0, 1, uninit, uninit), arr(2, 3, uninit, uninit)]
      a = resize(a, [4, 4])
      assert.deepEqual a, [arr(0, 1, uninit, uninit), arr(2, 3, uninit, uninit), arr(uninit, uninit, uninit, uninit), arr(uninit, uninit, uninit, uninit)]
      a = resize(a, [4, 2])
      assert.deepEqual a, [[0, 1], [2, 3], arr(uninit, uninit), arr(uninit, uninit)]
      a = resize(a, [2, 2])
      assert.deepEqual a, [[0, 1], [2, 3]]
      a = resize(a, [1, 1])
      assert.deepEqual a, [[0]]

    it "should resize a 2 dimensional array with default value", ->
      a = [[0, 1], [2, 3]]
      a = resize(a, [2, 4], 100)
      assert.deepEqual a, [[0, 1, 100, 100], [2, 3, 100, 100]]
      a = resize(a, [4, 4], 100)
      assert.deepEqual a, [[0, 1, 100, 100], [2, 3, 100, 100], [100, 100, 100, 100], [100, 100, 100, 100]]
      a = resize(a, [4, 2])
      assert.deepEqual a, [[0, 1], [2, 3], [100, 100], [100, 100]]
      a = resize(a, [2, 2])
      assert.deepEqual a, [[0, 1], [2, 3]]
      a = resize(a, [1, 1])
      assert.deepEqual a, [[0]]

    it "should resize a 1 dimensional array to 2 dimensional", ->
      a = [0, 0]
      a = resize(a, [4])
      assert.deepEqual a, arr(0, 0, uninit, uninit)
      a = resize(a, [2, 4])
      assert.deepEqual a, [arr(0, 0, uninit, uninit), arr(uninit, uninit, uninit, uninit)]
      b = [0, 0]
      b = resize(b, [4])
      assert.deepEqual b, arr(0, 0, uninit, uninit)
      b = resize(b, [2, 5], 8) # with a default value
      assert.deepEqual b, [arr(0, 0, uninit, uninit, 8), arr(8, 8, 8, 8, 8)]

    it "should resize a 2 dimensional array to 1 dimensional", ->
      a = [[1, 2, 3, 4], [5, 6, 7, 8]]
      a = resize(a, [6])
      assert.deepEqual a, arr(1, 2, 3, 4, uninit, uninit)
      b = [[], []]
      b = resize(b, [2], 8)
      assert.deepEqual b, [8, 8]

    it "should resize a 3 dimensional array", ->
      a = []
      a = resize(a, [2, 3], 5)
      assert.deepEqual a, [[5, 5, 5], [5, 5, 5]]
      a = resize(a, [2, 2, 3], 7)
      assert.deepEqual a, [[[5, 5, 5], [5, 5, 5]], [[7, 7, 7], [7, 7, 7]]]
      a = resize(a, [3, 2], 9)
      assert.deepEqual a, [[5, 5], [5, 5], [9, 9]]

    it "should resize to an empty array", ->
      a = []
      a = resize(a, [2, 3], 5)
      assert.deepEqual a, [[5, 5, 5], [5, 5, 5]]
      a = resize(a, [0])
      assert.deepEqual a, []
      assert.throws ->
        a = resize(a, [])

# TODO: test validate

# TODO: test validateIndex

# TODO: test isArray

# TODO: test squeeze

# TODO: test unsqueeze

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

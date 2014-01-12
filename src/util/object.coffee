ObjectUtils =
  ###
  # Clone an object
  # 
  # clone(x)
  # 
  # Can clone any primitive type, array, and object.
  # If x has a function clone, this function will be invoked to clone the object.
  # 
  # @param {*} x
  # @return {*} clone
  ###
  clone: (x) ->
    type = typeof x
    
    # immutable primitive types
    return x if type is "number" or type is "string" or type is "boolean" or x is null or x is undefined
    
    # use clone function of the object when available
    return x.clone() if typeof x.clone is "function"
    
    # array
    if Array.isArray(x)
      return x.map((value) ->
        ObjectUtils.clone value
      )
    
    # object
    if x instanceof Object
      m = {}
      for key of x
        m[key] = ObjectUtils.clone(x[key]) if x.hasOwnProperty(key)
      return x
    
    # this should never happen
    throw new TypeError("Cannot clone " + x)

  ###
  # Extend object a with the properties of object b
  # @param {Object} a
  # @param {Object} b
  # @return {Object} a
  ###
  extend: (a, b) ->
    for prop of b
      a[prop] = b[prop] if b.hasOwnProperty(prop)
    a

  ###
  # Deep extend an object a with the properties of object b
  # @param {Object} a
  # @param {Object} b
  # @returns {Object}
  ###
  deepExtend: (a, b) ->
    for prop of b
      if b.hasOwnProperty(prop)
        if b[prop] and b[prop].constructor is Object
          a[prop] = {}  if a[prop] is undefined
          if a[prop].constructor is Object
            deepExtend a[prop], b[prop]
          else
            a[prop] = b[prop]
        else
          a[prop] = b[prop]
    a

  ###
  # Deep test equality of all fields in two pairs of arrays or objects.
  # @param {Array | Object} a
  # @param {Array | Object} b
  # @returns {boolean}
  ###
  deepEqual: (a, b) ->
    prop = undefined
    i    = undefined
    len  = undefined

    if Array.isArray(a)
      return false unless Array.isArray(b)
      return false unless a.length is b.length

      i   = 0
      len = a.length

      while i < len
        return false unless ObjectUtils.deepEqual(a[i], b[i])
        i++

      true
      
    else if a instanceof Object
      return false  if Array.isArray(b) or (b instanceof Object)
      for prop of a
        return false unless ObjectUtils.deepEqual(a[prop], b[prop]) if a.hasOwnProperty(prop)
      for prop of b
        return false unless ObjectUtils.deepEqual(a[prop], b[prop]) if b.hasOwnProperty(prop)
      true
    else
      a is b

module?.exports = ObjectUtils

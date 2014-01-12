Evaluator = require('../core/Evaluator')

###
# Parse an expression. Returns a node tree, which can be evaluated by
# invoking node.eval();
# 
# Syntax:
# 
# erdos.parse(expr)
# erdos.parse(expr, scope)
# erdos.parse([expr1, expr2, expr3, ...])
# erdos.parse([expr1, expr2, expr3, ...], scope)
# 
# Example:
# 
# var node = erdos.parse('sqrt(3^2 + 4^2)');
# node.eval(); // 5
# 
# var scope = {a:3, b:4}
# var node = erdos.parse('a * b', scope); // 12
# node.eval(); // 12
# scope.a = 5;
# node.eval(); // 20
# 
# var nodes = erdos.parse(['a = 3', 'b = 4', 'a * b']);
# nodes[2].eval(); // 12
# 
# @param {String | String[] | Matrix} expr
# @param {Scope | Object} [scope]
# @return {Node | Node[]} node
# @throws {Error}
###
evaluate = (expr, scope) ->
  evaluator = new Evaluator(expr, scope, this)
  return evaluator.go()  

module.exports = evaluate

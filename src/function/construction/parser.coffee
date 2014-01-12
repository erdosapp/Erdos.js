module.exports = (erdos, settings) ->
	Parser = require('../../core/Parser')
	
	erdos.parser = (exp="") ->
		new Parser(exp)
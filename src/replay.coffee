((root, ns, factory) ->

	# CommonJS
	if typeof exports is 'object' and typeof module is 'object'
		module.exports = factory()

	# AMD
	else if typeof define is 'function' and define.amd
		define factory

	# Browser
	else
		root[ns] = factory()

) (if typeof window is 'object' then window else @), 'ReplayJS', ->
	new class ReplayJS
		num: 0
		recordings: {}
		recorder: ->
			@recordings[@num] = []
			fn = => @recordings[arguments.callee.num].push arguments
			fn.num = @num++
			fn.replay = @
			fn

		play: (recorder, targetFn, targetScope = null) ->
			arr = @recordings[recorder?.num]
			
			throw {
				message: 'Given recorder unknown'
			} if typeof arr is 'undefined'

			throw {
				message: 'Given recorder from different ReplayJS'
			} if recorder.replay isnt @

			throw {
				message: 'Given target function is not a function'
			} unless typeof targetFn is 'function'

			while (args = arr.shift())
				targetFn?.apply targetScope, args
			return
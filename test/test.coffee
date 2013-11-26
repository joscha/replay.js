chai = require 'chai'
assert = chai.assert
expect = chai.expect
should = chai.should()

ReplayJS = require '../src/replay'

describe 'replay.js', ->
	describe '#recorder()', ->
		it 'should return a recorder function', ->
			expect(ReplayJS.recorder()).to.be.a 'function'

		it 'should return different recorders', ->
			expect(ReplayJS.recorder()).to.be.not.equal ReplayJS.recorder()

	describe '#play()', ->
		it 'should throw an error if the passed recorder is not a proper one', ->
			fn = ->
				ReplayJS.play null
			expect(fn).to.throw /Given recorder unknown/

		it 'should throw an error if the passed recorder is not from the current ReplayJS', ->
			recorderFrom2 = ReplayJS.recorder()
			recorderFrom2.replay = {}
			fn = ->
				ReplayJS.play recorderFrom2
			expect(fn).to.throw /Given recorder from different ReplayJS/

		it 'should throw an error if the passed callback is not a proper one', ->
			recorder = ReplayJS.recorder()
			fn = ->
				ReplayJS.play recorder, null
			expect(fn).to.throw /Given target function is not a function/

		it 'should replay the recorded call', (cb) ->
			recorder = ReplayJS.recorder()
			recorded = {}
			recorder recorded
			ReplayJS.play recorder, (x) ->
				expect(x).to.equal recorded
				cb()

		it 'should replay the recorded calls', ->
			recorder = ReplayJS.recorder()
			recorded1 = {}
			recorder recorded1
			recorded2 = {}
			recorder recorded2
			recorded3 = {}
			recorder recorded3
			arr = []
			ReplayJS.play recorder, (x) -> arr.push x
			expect(arr).to.eql [recorded1, recorded2, recorded3]

		it 'should replay with a given target', ->
			recorder = ReplayJS.recorder()
			recorded = {}
			recorder recorded
			arr = []
			ReplayJS.play recorder, Array::push, arr
			expect(arr).to.eql [recorded]

		it 'should replay with different recorders', ->
			recorder1 = ReplayJS.recorder()
			recorder2 = ReplayJS.recorder()

			recorder1 1
			recorder2 2
			recorder1 3
			recorder2 4
			recorder1 5
			recorder2 6

			arr1 = []
			ReplayJS.play recorder1, Array::push, arr1

			arr2 = []
			ReplayJS.play recorder2, Array::push, arr2

			expect(arr1).to.eql [1,3,5]
			expect(arr2).to.eql [2,4,6]

		it 'should be possible to reuse the recorder', ->
			recorder = ReplayJS.recorder()
			recorder 1
			recorder 2
			arr = []
			ReplayJS.play recorder, Array::push, arr
			recorder 3
			ReplayJS.play recorder, Array::push, arr
			expect(arr).to.eql [1,2,3]
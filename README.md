replay.js
=========

A simple recorder/proxy generator for JavaScript, that allows you to capture method calls and replay them onto a given function/scope at a later point in time.

[![Build Status](https://travis-ci.org/joscha/replay.js.png)](https://travis-ci.org/joscha/replay.js)
[![NPM version](https://badge.fury.io/js/replay.js.png)](http://badge.fury.io/js/replay.js)
[![Dependency Status](https://david-dm.org/joscha/replay.js.png)](https://david-dm.org/joscha/replay.js)

## Test

`grunt test` or for dev mode `grunt watch:test`

## Installation
`npm install replay.js` or just load within a browser (works with CommonJS, AMD and Vanilla JS)

## Versions
* **0.0.1**: Initial version

## Usage

The following example records calls to the recorder and then replays them onto the `console`.

```JavaScript
var ReplayJS = require('replay.js');

var recorder = ReplayJS.recorder();

recorder('Hello', 'World');
recorder('Hello', 'you');

ReplayJS.play(recorder, console.log, console);
// Hello World
// Hello you
```

```JavaScript
var ReplayJS = require('replay.js');

var recorder = ReplayJS.recorder();

recorder(1);
recorder(2);
recorder(3);

var arr = [];
ReplayJS.play(recorder, Array.prototype.push, arr);
// arr = [1,2,3]
```

## License
MIT (see LICENSE file)
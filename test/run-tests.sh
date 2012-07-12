#!/bin/bash

cd `dirname $0`

node <<END

var util = require('util');
var assert = require('assert');

window = {};
require('../zxcvbn.js');

var test = function(password, expected, detail) {
	var result = window.zxcvbn(password);
	var summary = [];
	for (var i = 0; i < result.match_sequence.length; i++) {
		var match = result.match_sequence[i];
		summary.push(match.pattern);
		summary.push(':');
		summary.push(match.j + 1 - match.i);
		summary.push(':');
		if (detail) util.debug(match.entropy);
	}
	summary.push(result.entropy);
	summary = summary.join('');
	assert.equal(summary, expected, 'Discrepancy on ' + password + '; expected ' + expected + '; got ' + summary);
};


util.log('Beginning tests');

// The tests included as examples in index.html.
// TODO Use a code coverage tool to check what isn't tested.
test('zxcvbn', 'dictionary:6:6.845');
test('qwER43@!', 'spatial:8:26.44');
test('Tr0ub4dour&3', 'dictionary:10:bruteforce:2:30.435');
test('correcthorsebatterystaple', 'dictionary:7:dictionary:5:dictionary:7:dictionary:6:45.212');
test('coRrecth0rseba++ery9.23.2007staple\$', 'dictionary:7:dictionary:5:dictionary:7:date:9:dictionary:7:66.018');
test('D0g..................', 'dictionary:3:repeat:18:20.678');
test('abcdefghijk987654321', 'sequence:11:sequence:9:11.951');
test('neverforget13/3/1997', 'dictionary:5:dictionary:6:date:9:32.628');
test('1qaz2wsx3edc', 'dictionary:8:spatial:4:19.314');
test('temppass22', 'dictionary:8:bruteforce:2:22.179');
test('briansmith', 'dictionary:5:dictionary:5:4.322');
test('briansmith4mayor', 'dictionary:5:dictionary:5:dictionary:1:dictionary:5:18.64');
test('password1', 'dictionary:8:dictionary:1:2');
test('viking', 'dictionary:6:7.531');
test('thx1138', 'dictionary:7:7.426');
test('ScoRpi0ns', 'dictionary:8:bruteforce:1:20.621');
test('do you know', 'dictionary:2:bruteforce:1:dictionary:3:bruteforce:1:dictionary:4:20.257');
test('ryanhunter2000', 'dictionary:4:dictionary:6:dictionary:4:14.506');
test('rianhunter2000', 'bruteforce:1:dictionary:1:dictionary:2:dictionary:6:dictionary:4:21.734');
test('asdfghju7654rewq', 'spatial:16:29.782');
test('AOEUIDHG&*()LS_', 'spatial:15:33.254');
test('12345678', 'dictionary:8:1.585');
test('defghi6789', 'sequence:6:sequence:4:12.607');
test('rosebud', 'dictionary:7:7.937');
test('Rosebud', 'dictionary:7:8.937');
test('ROSEBUD', 'dictionary:7:8.937');
test('rosebuD', 'dictionary:7:8.937');
test('ros3bud99', 'dictionary:7:bruteforce:2:19.276');
test('r0s3bud99', 'dictionary:7:bruteforce:2:19.276');
test('R0\$38uD99', 'dictionary:7:bruteforce:2:25.076');
test('verlineVANDERMARK', 'dictionary:7:dictionary:10:26.293');
test('eheuczkqyq', 'bruteforce:1:dictionary:2:bruteforce:7:42.813');
test('rWibMFACxAUGZmxhVncy', 'bruteforce:2:dictionary:1:bruteforce:3:dictionary:1:bruteforce:2:dictionary:1:bruteforce:10:104.551');
test('Ba9ZyWABu99[BK#6MBgbH88Tofv)vs\$w', 'dictionary:3:bruteforce:3:dictionary:1:dictionary:4:bruteforce:6:spatial:4:bruteforce:2:dictionary:2:bruteforce:7:167.848');

util.log('All tests passed');

END

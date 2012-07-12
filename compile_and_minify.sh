#!/bin/bash
set -e

# execute as
#   ./compile_and_minify.sh test
# to compile for test/index.html

# the coffee compiler adds a function wrapper by default.
# i add one myself manually because zxcvbn.js is built from a mix of .cs and .js files.
function_wrap () {
    echo '(function () {' "$(cat /dev/stdin)" '})();'
}

echo 'compiling cs -> js'
coffee --compile --bare {matching,scoring,init}.coffee
if [ "x$1" = "xtest" ]
then
	sed 's%http://.*/zxcvbn.js%../zxcvbn.js%' async.coffee | coffee --compile --stdio >async.js
else
	coffee --compile async.coffee
fi

echo 'compiling js -> js'
# closure's simple optimizations ended up being about 200k better than whitespace-only.
# mostly from removing spaces and double quotes from the frequency lists, heh.
# advanced is only about 1k better than simple and adds complixity. skip it.
COMPILATION_LEVEL=SIMPLE_OPTIMIZATIONS
cat {matching,scoring,adjacency_graphs,frequency_lists,init}.js  | function_wrap > compiled.js
java -jar tools/closure.jar --compilation_level $COMPILATION_LEVEL --js compiled.js --js_output_file zxcvbn.js
java -jar tools/closure.jar --compilation_level $COMPILATION_LEVEL --js async.js    --js_output_file zxcvbn-async.js
rm -f compiled.js
echo 'done. produced zxcvbn.js and zxcvbn-async.js'

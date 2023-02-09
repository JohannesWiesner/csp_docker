docker run -ti --rm \
-v ${PWD}/testing/code:/home/csp/code \
-v ${PWD}/testing/data:/home/csp/data \
-v ${PWD}/testing/output:/home/csp/output \
-p 8888:8888 \
csp:test


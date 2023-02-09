docker run -ti --rm \
-v ${pwd}/testing/code:/home/csp/code \
-v ${pwd}/testing/data:/home/csp/data \
-v ${pwd}/testing/output:/home/csp/output \
-p 8888:8888 \
csp:test


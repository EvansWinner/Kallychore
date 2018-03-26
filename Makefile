all: clean test

test:
	./kallychore -m README.in > README.md
	./kallychore extra-tests.in > extra-tests.txt

clean:
	rm -f his* data.dat README.md extra-tests.txt

install:
	install -t /usr/local/bin kallychore

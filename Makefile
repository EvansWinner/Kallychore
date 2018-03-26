all:
	@echo "Kallychore is just a bash script, so it doesn't need"
	@echo "a make process to use."
	@echo ""
	@echo "Use 'make test' to built README.md and extra-tests.txt."
	@echo ""
	@echo "Use 'make install' to send a copy of kallychore to"
	@echo "/usr/local/bin"
	@echo ""
	@echo "That's about it, really."

test: clean
	./kallychore -m README.in > README.md
	./kallychore extra-tests.in > extra-tests.txt
	rm data.dat his*
clean:
	rm -f his* data.dat README.md extra-tests.txt

install:
	install -t /usr/local/bin kallychore

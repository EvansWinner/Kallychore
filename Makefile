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



test: clean extra-tests.txt README.md


README.md: README.kc
	./kallychore -m README.kc > README.md
	rm data.dat his*

extra-tests.txt: extra-tests.kc
	./kallychore extra-tests.kc > extra-tests.txt

clean:
	rm -f his* data.dat README.md extra-tests.txt

install:
	install -t /usr/local/bin kallychore

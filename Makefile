all:
	@echo "Kallychore is just a bash script, so it doesn't need"
	@echo "a make process to use."
	@echo ""
	@echo "Use 'make test' to built README.md and extra-tests.txt."
	@echo ""
	@echo "Use 'make install' to send a copy of kallychore to"
	@echo "${PREFIX}/bin"
	@echo ""
	@echo "That's about it, really."



test: clean extra-tests.txt README.md
     
check: 
	shellcheck -eSC2002 kallychore

README.md: README.kc
	./kallychore -m README.kc | bash > README.md
	rm data.dat his*

extra-tests.txt: extra-tests.kc
	./kallychore extra-tests.kc | bash > extra-tests.txt

clean:
	rm -f his* data.dat README.md extra-tests.txt

install:
	install -t ${PREFIX}/bin kallychore

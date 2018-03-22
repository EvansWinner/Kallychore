BEGIN {
    cellstartstr = "╭━━━━━Code cell start: ━━━";
    cellendstr   = "╰━━━━━━━━━━━━━━━━━━━━━━━━━  ↴";
    textstartstr = "cat <<kallychoreistehbombzers" # heredoc start
    textendstr = "kallychoreistehbombzers"	      # heredoc end
    code = 0;
    text = 0;
}

/^{{{/ {
    # print any previous text
    print textstartstr;
    if (a[1] != "") {
	for (i=1;i<text;i++) {
	    print a[i];
	}
    }
    print textendstr;

    # Get ready for code block
    text = 0;
    delete a;
    
    # start the cell
    print textstartstr;
    print cellstartstr;
    code++;
}

/}}}/ {
    # print all the code
    for (i=1;i<code;i++) {
	print "│  " a[i];
    }
    
    print cellendstr;
    print textendstr;
    # print all the output
    for (i=1;i<code;i++) {
	print a[i];
    }
    
    code = 0;			# reset for next cell
    text = 0;
    delete a;			# clear the array
}

!/^{{{|}}}/ {
    if (code == 0) {
	a[text] = $0;
	text++;
    }
    else {
	a[code] = $0;
	code++;
    }
}

END {
    if (text != 0) {
	print textstartstr;
	if (a[1] != "") {
	    for (i=1;i<text;i++) {
		print a[i];
	    }
	}
	print textendstr;
    }
}

 

# KALLYCHORE --- Gutter-punk plain-text code notebook processor

## Introduction

Kallychore is like Rmarkdown in Rstudio, or Jupyter, only really
dumb. Or, in any case, it is a bash shell script (mainly consisting of
an embedded awk program) which turns plain text mixed with shell
commands into plain text mixed with shell commands AND their
output. Cool, no?

This is an example of a file that uses Kallychore[1] for
processing. Although Kallychore is intended for plain text use, there
is nothing to say you can't write your plain text in Markdown and then
post-process it with something like Pandoc.

This file's source is README.in. Once it is processed with Kallychore,
it becomes README.md:

    $ kallychore -m README.in > README.md

It is a regular text file with shell commands surrounded with
tripple-curly-braces: \{\{\{ and \}\}\} each on a line by itself. Take
a look at README.in to see how it works. When the input file is
processed with Kallychore, lines which are normal text should be
simply echoed to standard output, but lines which are surrounded with
that tag will be echoed in a cute little ASCII art box, and then
executed by bash, their output going to standard output just like the
running text. For example, the next line is a call to 'wc' to list the
number of characters in the script file 'kallychore'. Well, not quite
the next line. After the next paragraph wherein I make various
disclaimers.

Since this is the README file for Kallychore, we are setting it up for
postprocessing as a Markdown file, so we're also going to pipe all our
commands to "sed -e 's/^/ /'". This is to add some spaces to command
output (not the text of the commands themselves -- that's handled
separately) so that Markdown renders them like code, in
monospace. This is not necessary if your output target is plain text,
which is the main purpose of Kallychore, after all. But, er, where was
I? Oh yeah a basic example --


     wc -m kallychore | sed -e 's/^/    /' 

    2803 kallychore


## Examples
--------

### Example 1

How many times bigger are all the files in this directory put together
than this file by itself? (An Earth-shaking question if ever there was
one.)

First, lets make a data file showing the character counts of all the
files in this directory.


     wc -c * | awk '{print $1}' | head -5 | awk 'BEGIN {i=1}; {print i " " $0; i++}' > data.dat


(Note: Since we redirected that to a file, there is no output here.)

Then, I don't know; plot it, I guess:


     gnuplot -e "set terminal dumb; plot 'data.dat' pt '*'" | sed -e 's/^/    /' 

                                                                                   
      7000 +-------------------------------------------------------------------+   
           |        +       +        +       +        +       +        +       |   
           |                                                'd*ta.dat'    *    |   
      6000 |-+                                                               +-|   
           |                                                                   |   
           |                                                                   |   
      5000 |-+                                                               +-|   
           |                                                                   |   
           |                                                                   |   
      4000 |-+                                                               +-|   
           |                                                                   |   
      3000 |-+                                                               +-|   
           |                *                                                  |   
           |                                                                   |   
      2000 |-+                                                               +-|   
           |                                                                   |   
           |                                                                   |   
      1000 |-+                                                               +-|   
           |                                                                   |   
           |        +       +        +       *        +       +        +       |   
         0 +-------------------------------------------------------------------+   
           1       1.5      2       2.5      3       3.5      4       4.5      5   
                                                                                   

Neet.


### Example 2

I am afraid the extra-tests.in file included with this git repository
may be full of words that are too long for all your chicken-fried
brains. Let me fire up an old exercise I once wrote to get a histogram
of word lengths in a file (Exercise 1-13 from ye olde K&R C book, as
it happens). Let's just compile the code, and then run it against
extra-tests.in:


     cc -x c -o hist.exe - <<'thisHereIsAHereDoc'
     #include <stdio.h>
     
     #define IN 1
     #define OUT 0
     #define MAX_WORD_LENGTH 20
     
     void make_it(int n) {
       int i;
       if (n > 50) n = 50;
       for (i = 0; i < n; ++i)
         printf("*");
       return;
     }
     
     int main() {
       int c, i, last = OUT, count = 0;
       int words[MAX_WORD_LENGTH];		/* histogram array */
       for (i = 0; i < MAX_WORD_LENGTH; ++i)	/* initialize it */
         words[i] = 0;
       /* Populate the array */
       while ((c = getchar()) != EOF) {
         if ((c == ' ') || (c == '\t') || (c == '\n')) {
           if (last == IN)
     	if (count <= MAX_WORD_LENGTH) words[count] = ++words[count];
             else words[MAX_WORD_LENGTH - 1] = ++words[MAX_WORD_LENGTH - 1];
           count = 0;
         }
         else {
           last = IN;
           count = ++count;
         }
       }
     
       if (last == IN)
         if (count <= MAX_WORD_LENGTH) words[count] = ++words[count];
         else words[MAX_WORD_LENGTH - 1] = ++words[MAX_WORD_LENGTH - 1];
     
       /* write the histogram */
       printf("\n    -- NUMBER OF WORDS OF GIVEN LENGTH IN INPUT FILE (MAX 50) --\n");
       printf("                          |10       |20       |30       |40       |>50\n");
       for (i = 0; i < MAX_WORD_LENGTH; ++i) {
         if (i == (MAX_WORD_LENGTH - 1)) printf(">=");
         else printf("  ");
         /* if (i < MAX_WORD_LENGTH) printf(" "); */
         if (i < 9) printf(" ");
         printf("%d ", i + 1);
         printf("character");
         if (i == 0) printf(":  ");
         else printf("s: ");
         /* do it */
         make_it(words[i]);
         printf("\n");
       }
       return 0;
     }
     thisHereIsAHereDoc
     cat extra-tests.in | ./hist.exe | sed -e 's/^/    /' 

    
        -- NUMBER OF WORDS OF GIVEN LENGTH IN INPUT FILE (MAX 50) --
                              |10       |20       |30       |40       |>50
       1 character:  ***
       2 characters: *****
       3 characters: *********
       4 characters: ***********
       5 characters: ******************
       6 characters: **
       7 characters: ***
       8 characters: **
       9 characters: *
      10 characters: *
      11 characters: 
      12 characters: *
      13 characters: 
      14 characters: 
      15 characters: 
      16 characters: 
      17 characters: 
      18 characters: 
      19 characters: 
    >=20 characters: 

No, doesn't look too bad after all. I think you'll all survive.


## Requirements

Kallychore requires bash, awk, and cat in your path. That should be
all. To use Kallychore to build this example file, you would also need
gnuplot, wc, gcc, sed, and --

So, if you're in to this whole "reproducible research" idea then you
will no doubt want a way to incorporate version numbers of all the
programs you used. If so, then try
[whatver](https://github.com/EvansWinner/whatver), which is a tiny
python 3 script that lets you do this:


     whatver SYSTEM python wc awk bash gnuplot cat cc whatver \
             tail sed head pic perl graph-easy kallychore  | sed -e 's/^/    /' 

     - CYGWIN_NT-10.0 2.10.0(0.325/5/3) 2018-02-02 15:16 x86_64 unknown unknown Cygwin
     - Python 2.7.14
     - wc (GNU coreutils) 8.26
     - GNU Awk 4.2.1, API: 2.0 (GNU MPFR 4.0.1, GNU MP 6.1.2)
     - GNU bash, version 4.4.12(3)-release (x86_64-unknown-cygwin)
     - gnuplot 5.2 patchlevel 2
     - cat (GNU coreutils) 8.26
     - cc (GCC) 6.4.0
     - whatver 1
     - tail (GNU coreutils) 8.26
     - sed (GNU sed) 4.4
     - head (GNU coreutils) 8.26
     - GNU pic (groff) version 1.22.3
     - perl 5, version 26, subversion 1 (v5.26.1) built for x86_64-cygwin-threads-multi
     - Graph::Easy v0.69  (c) by Tels 2004-2008.  Released under the GPL 2.0 or later.
     - kallychore 1


## Use

Use it like this:

    kallychore file.txt

Use whatever file extension you like for the input file. The results
will go to standard output, so redirect to a file if you want to save
it, like --

    kallychore inputfile > finalresult

Now we will be the envy of all those poor schlubs who are using
Rmarkdown and all that silly nonsense. Plain text forever!


## Notes

Don't use back-ticks. Or dollar signs. I don't know why. Just
don't. Or use them, but escape them in your source file. Or maybe
don't -- I don't think I've tested it recently. Everything you think
should just be an easy, quick little hack has to get complicated....
Maybe you should test it and fix it (if it needs fixing) and, you
know, all that stuff. I

You could write the plain text part of your document any way you
want. You could write it in Markdown, for instance, and pipe it into
some Markdown processor. Whatever. It's a free country.

Everything gets piped to a single instance of bash, so variables
should carry over from one "cell" to another; and multi-line things
should work.

This is a kind of a proof of concept. Tell me what doesn't work and
I'll think about fixing it.

## Footnotes

[1] Kallychore is an itty-bitty tiny moon of Jupyter.
    Get it?

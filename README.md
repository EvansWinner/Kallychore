# KALLYCHORE --- Gutter-punk plain-text code notebook processor

## Introduction

Kallychore is an "active code" processor for plain text and `bash`,
sort of like like Rmarkdown in Rstudio for Markdown and R code, or
`org-mode` with `org-babel`. It's point is to scratch its author's
itch to have something like Rmarkdown for the `bash` command line
which will allow for something like the "reproducable research" style
of creating documents. In any case, it is a bash shell script (mainly
consisting of an embedded awk program) which turns plain text mixed
with shell commands into plain text mixed with shell commands AND
their output. Cool, no?

This is an example of a file that uses Kallychore for
processing. Although Kallychore is intended for plain text use, there
is nothing to say you can't write your plain text in Markdown and then
post-process it with something like Pandoc. In fact, Kallychore has a
command line flag, "-m", which produces output better suited for use
in Github's Markdown or Pandoc's "backtick_code_blocks" extension.

This file's source is README.kc. Once it is processed with Kallychore,
it becomes README.md:

    $ kallychore -m README.kc > README.md

It is a regular text file with shell commands surrounded with
tripple-curly-braces: \{\{\{ and \}\}\} each on a line by itself. Take
a look at README.kc to see how it works. When the input file is
processed with Kallychore, lines which are normal text should be
simply echoed to standard output, but lines which are surrounded with
that tag will be echoed in a cute little ASCII art box, and then
executed by bash, their output going to standard output just like the
running text. For example, the next line is a call to 'wc' to list the
number of characters in the script file 'kallychore'. 

```bash
#### Code Cell Start ##########
wc -m kallychore
###############################
```
~~~~~
3844 kallychore
~~~~~


## Examples
--------

[This](https://www.linkedin.com/pulse/group-long-hand-written-numbers-smaller-sub-units-better-evans-winner/)
article in LinkedIn, silly as it may be, was done with Kallychore.

### Example 1

How many times bigger are all the files in this directory put together
than this file by itself? (An Earth-shaking question if ever there was
one.)

First, lets make a data file showing the character counts of all the
files in this directory.

```bash
#### Code Cell Start ##########
wc -c * | awk '{print $1}' | head -5 | awk 'BEGIN {i=1}; {print i " " $0; i++}' > data.dat
###############################
```
~~~~~
~~~~~

(Note: Since we redirected that to a file, there is no output here.)

Then, I don't know; plot it, I guess:

```bash
#### Code Cell Start ##########
gnuplot -e "set terminal dumb; plot 'data.dat' pt '*'"
###############################
```
~~~~~
                                                                               
                                                                               
  7000 +-+------+-------+--------+-------+--------+-------+--------+-----+-+   
       +        +       +        +       +        +       +        +       +   
       |                                                'data.dat'    *    *   
  6000 +-+                                                               +-+   
       |                                                                   |   
  5000 +-+                                                               +-+   
       |                                                                   |   
       |                                                                   |   
  4000 +-+                                                               +-+   
       |                                 *                                 |   
       |                                                                   |   
  3000 +-+                                                               +-+   
       |                                                                   |   
       |                                                                   |   
  2000 +-+                                                               +-+   
       |                                                                   |   
  1000 +-+                                                               +-+   
       |                                                  *                |   
       *        +       *        +       +        +       +        +       +   
     0 +-+------+-------+--------+-------+--------+-------+--------+-----+-+   
       1       1.5      2       2.5      3       3.5      4       4.5      5   
                                                                               
~~~~~

Neet.


### Example 2

I am afraid the extra-tests.kc file included with this git repository
may be full of words that are too long for all your chicken-fried
brains. Let me fire up an old exercise I once wrote to get a histogram
of word lengths in a file (Exercise 1-13 from ye olde K&R C book, as
it happens). Let's just compile the code, and then run it against
extra-tests.kc:
 
```bash
#### Code Cell Start ##########
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
cat extra-tests.kc | ./hist.exe
###############################
```
~~~~~

    -- NUMBER OF WORDS OF GIVEN LENGTH IN INPUT FILE (MAX 50) --
                          |10       |20       |30       |40       |>50
   1 character:  ***
   2 characters: ****
   3 characters: *****
   4 characters: **********
   5 characters: ***************
   6 characters: *
   7 characters: **
   8 characters: *
   9 characters: *
  10 characters: 
  11 characters: 
  12 characters: **
  13 characters: 
  14 characters: 
  15 characters: 
  16 characters: 
  17 characters: 
  18 characters: 
  19 characters: 
>=20 characters: 
~~~~~

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

```bash
#### Code Cell Start ##########
whatver SYSTEM python wc awk bash gnuplot cat cc whatver \
        tail sed head pic perl kallychore
###############################
```
~~~~~
Linux 4.13.0-37-generic #42-Ubuntu SMP Wed Mar 7 14:13:23 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
Python 2.7.14
wc (GNU coreutils) 8.26
GNU Awk 4.1.4, API: 1.1 (GNU MPFR 3.1.6, GNU MP 6.1.2)
GNU bash, version 4.4.12(1)-release (x86_64-pc-linux-gnu)
gnuplot 5.0 patchlevel 7
cat (GNU coreutils) 8.26
cc (Ubuntu 7.2.0-8ubuntu3.2) 7.2.0
whatver version (git revision) 19
tail (GNU coreutils) 8.26
sed (GNU sed) 4.4
head (GNU coreutils) 8.26
GNU pic (groff) version 1.22.3
perl 5, version 26, subversion 0 (v5.26.0) built for x86_64-linux-gnu-thread-multi
kallychore version (git revision) 23
~~~~~

```bash
#### Code Cell Start ##########
make_recipe README.md
###############################
```
~~~~~
The Makefile command line was:
make[1]: 'README.md' is up to date.
~~~~~

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
know, all that stuff.

Everything gets piped to a single instance of bash, so variables
should carry over from one "cell" to another; and multi-line things
should work.

This is a kind of a proof of concept. Tell me what doesn't work and
I'll think about fixing it.

## Footnotes

[1] Kallychore is an itty-bitty tiny moon of Jupyter.
    Get it?

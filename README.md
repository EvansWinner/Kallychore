# KALLYCHORE.SH 

kallychore.sh is a gutter-punk version of a data science notebook,
using bash for plain text command line use. It takes a plain text file
as input and sends it back to standard output, with lines beginning
with # evaluated in bash and replaced by their output. That's about
it. See example.in and example.out for more insight.


# TODO

 - Make real cells such that the code is automatically in the final
   product and the result below wrapped in some kind of ASCII art
   delimiter.
 - Make the delimiter be settable with a command-line switch.
 - Parse and validate the command line properly
 - Inline code eval without the code being visible in the result.
 - Command line option for how much to indent code output.

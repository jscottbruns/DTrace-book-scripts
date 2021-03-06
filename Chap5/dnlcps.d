#!/usr/sbin/dtrace -s
/*
 * dnlcps.d
 *
 * Example script from Chapter 5 of the book: DTrace: Dynamic Tracing in
 * Oracle Solaris, Mac OS X, and FreeBSD", by Brendan Gregg and Jim Mauro,
 * Prentice Hall, 2011. ISBN-10: 0132091518. http://dtracebook.com.
 * 
 * See the book for the script description and warnings. Many of these are
 * provided as example solutions, and will need changes to work on your OS.
 */

#pragma D option quiet

dtrace:::BEGIN
{
	printf("Tracing... Hit Ctrl-C to end.\n");
}

fbt::dnlc_lookup:return
{
	this->code = arg1 == 0 ? 0 : 1;
	@Result[execname, pid] = lquantize(this->code, 0, 1, 1);
}

dtrace:::END
{
	printa(" CMD: %-16s PID: %d\n%@d\n", @Result);
}

//dmd -i -J=. -main -run test.d 0

import std;
import mkydbg;
import folder.math;

void main(string[] s){
	loglvl!()=s[1].to!int;
	logln!1("hello world");
	foreach(f;[2.1,0,float.nan,-float.nan]){
	foreach(g;[2.1,0,float.nan,-float.nan]){
		auto h=safedivide(f,g);
		if(h>100||h<-100){
			logln!3("out of bounds");
		}
	}}
	logln("hello world again");
	logheader="testing debugln";
	int i=3;
	debugln(i++ + ++i);
	debugln!2( i++ + ++i );
	debugln!3(  i++ + ++i  );
	i++;debugln(i);i--;
	
}

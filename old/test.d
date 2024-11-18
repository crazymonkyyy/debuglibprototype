//dmd -i -J=. -main -run test.d 0

import std;
import mkydbg2;
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
	i.debugln;
	int j=1;
	//compareln!"<="(i,j); unmix needs to handle string templates first
	//compareln!">="(i,j);
	//compareln!"<="(j,i);
	//compareln!">="(j,i);
	warnlt(i,j);
	warnlt(j,i);
	j+=7;
	warnlt(j,i);
	i.warnlt(j);
	j+=2;
	warnlt(j,i);
	i.warnlt(j);
}

import std;
template unmix(string file=__FILE__,int line=__LINE__){
	import std;
	enum string unmix=import(file).split('\n').drop(line-1).front;
}
unittest{
	import std;
	int i=3;
	writeln(i++ + ++i,unmix!());
}

string matchparn(string s){//todo more genertic
	assert(s[0]=='(');
	int i=1;
	int count=1;
	while(i<s.length){
		if(s[i]==')'){count--;}
		if(s[i]=='('){count++;}
		if(count==0){return s[1..i];}
		i++;
	}
	assert(0,"mismatched");
}
unittest{
	"((()))foo".matchparn.writeln;
	"()".matchparn.writeln;
	"(bar)".matchparn.writeln;
	//"(      ()()()".matchparn.writeln;
}

unittest{
	softtab("foobar",123.to!string).writeln;
	softtab("foo",123.to!string).writeln;
	softtab("bar--",123.to!string).writeln;
	softtab("longstringg       ;",123.to!string).writeln;
	softtab("longstringg       two;",123.to!string).writeln;
	softtab!80("longstringg       ;","12345789012345678901234567890123456789012345678901234578901234567890").writeln;
}

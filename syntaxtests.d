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
void unixexcape(int i){
	version(Windows) return;//TODO
	("\033["~i.to!string~"m").write;
}
void reset()=>unixexcape(0);
void underline()=>unixexcape(4);
void unixcolor(int i)=>unixexcape(30+i%8);
void warncolor(int i)=>unixcolor([7,4,5,3,6,1][max(i,0)%6]);//god why is the order of unix colors so strange
unittest{
	unixexcape(35);
	"hello".writeln;
	unixexcape(4);
	"world".writeln;
	unixexcape(0);
	"what".writeln;
	foreach(i;0..15){
		warncolor(i);i.writeln;
	}
}
auto softtab(int max=120,R1,R2)(R1 r1,R2 r2)=>//todo consider fixing miscounting bugs
	chain(
		r1.filter!(a=>a!='\t'),
		(r1.length+r2.length<max)?"\t":"",
		r2.filter!(a=>a!='\t')
	).detabber(8);

unittest{
	softtab("foobar",123.to!string).writeln;
	softtab("foo",123.to!string).writeln;
	softtab("bar--",123.to!string).writeln;
	softtab("longstringg       ;",123.to!string).writeln;
	softtab("longstringg       two;",123.to!string).writeln;
	softtab!80("longstringg       ;","12345789012345678901234567890123456789012345678901234578901234567890").writeln;
}
template innate(T,T startingvalue=T.init,alias discrim=void){//todo double check if this header works correctly
	T innate=startingvalue;
}
alias foo=innate!int;
unittest{
	foo=1;
}

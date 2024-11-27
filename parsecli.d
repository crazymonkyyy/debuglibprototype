// I think part of the problem of std.conv being a mess is that strings are hard and theres some trade offs to make that should just be seperate, maybe three functions .to, .parse, .serialize
import belonginstd;
string parse(T:string)(string s)=>s;
nullable!int parse(T:int)(string s){
	reset:
	if(s.length==0){return nullable!int();}
	if(s.length>6){return nullable!int();}//LAZY:"probaly to big", I only care about single digit ints as Im writting this, a real implimation would need to be careful about it in the loop
	if(s[0]==' '){s=s[1..$]; goto reset;}
	int sign=1;
	int store;
	if(s[0]=='-'){s=s[1..$]; sign=-1;}
	foreach(c;s){
		if(c==' '|| c==','){continue;}
		if(c<'0'|| c>'9'){return nullable!int();}
		store*=10;
		store+=cast(int)(c-'0')*sign;
	}
	return nullable!int(store);
}
unittest{
	assert("1".parse!int==1);
	assert("-69".parse!int==-69);
	assert("foo".parse!int.isNull);
}

mixin template parsecli(data...){
	void parsecli_(string[] args){
		import std;
		foreach(s;args){
			if(s.length==0 || s[0]!='-'){continue;}
			auto i=s.countUntil('=');
			if(i==-1){continue;}
			static foreach(arg;data){
				if(arg.stringof==s[1..i]){
					arg=s[i+1..$].parse!(typeof(arg)).replacenull(arg);
}}}}}

void main(string[] s){
	import std.stdio;
	int foo;
	string bar;
	mixin parsecli!(foo,bar);
	parsecli_(s);
	foo.writeln;
	bar.writeln;
}

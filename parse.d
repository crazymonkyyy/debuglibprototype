//lazy minium implimtations to just make my one usecase work, api is roughly what I want tho
import std.conv;
struct nullable(T){
	T get; alias get this;
	bool isNull=true;
	this(T t){
		get=t;
		isNull=false;
	}
}
nullable!int parse(T:int)(string s){
	if(s.length==0){return nullable!int();}
	string s_=s;
	if(s[0]=='-'){s_=s[1..$];}
	foreach(c;s_){
		if(c!=' '&&(c<'0'||c>'9')){return nullable!int();}
	}
	return nullable!int(s.to!int);
}
string parse(T:string)(string s)=>s;

unittest{
	assert("1".parse!int==1);
	assert("-1".parse!int==-1);
	assert("foo".parse!int.isnull==true);
	assert("foo".parse!string=="foo");
}
void dummynullablefunction(T)(T t){
	bool b=t.isNull;
}
enum isNullable(T)=__traits(compiles,dummynullablefunction!T);
auto replacenull(S,T)(S t,T t_) if(isNullable!(S)) => t.isNull?t_:t;
auto replacenull(T)(T t,T t_)=>t;
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
				}
			}
		}
	}
}

void main(string[] s){
	import std.stdio;
	int foo;
	string bar;
	mixin parsecli!(foo,bar);
	parsecli_(s);
	foo.writeln;
	bar.writeln;
}

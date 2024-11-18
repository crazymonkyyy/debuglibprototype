/**
Holding file for a bunch of gists of stuff that belongs in an std, but at the minium viable produt for my debug lib

@grim, if your still working on making an opend std of some sort this would be my suggestions
*/
//meta

/******
* My current take on std.meta; I dont know how much I will be working on std replacements or the file stucture of such a project
* 
* There are no good docs for template hell but I suggest this: https://github.com/PhilippeSigaud/D-templates-tutorial
*/

/** the most important line of code here, shorter name then AliasSeq; THE alias, creates sliceable list of overload sets, theres lots of syntax sugar for a `T...` read the template book*/
alias seq(T...)=T;
unittest{
	alias foo=seq!(int,float);
	static assert(foo[0].stringof=="int");
}

/** creates a value of type T that is well namespaced, only allocated on (compiled) use, and effectively accessable everywhere, may cause quantium spokiness however for example if you use the same innate value in two unittests it would be trivail to have the order of running the unit tests to effect outcomes.

Use this as a release valve on api designs, or when you want a c-like golbal.

To have several seperate values(such as inside a static foreach), simply add whatever data your looping over into "discrimination"
*/

template innate(T,T startingvalue=T.init,discrimination...){
	T innate=startingvalue;
}
// unittests for innate should remain commented out
/*
import std;
unittest{
	alias foo=innate!int;
	foo.writeln;
	foo=3;
	foo.writeln;
}
unittest{
	alias bar=innate!int;
	bar.writeln;
	alias foobar=innate!(int,15,"foobar");
	foobar.writeln;
	bar.writeln;
}
unittest{
	alias s=innate!string;
	s.writeln;
	alias t=innate!(string,"foo");
	t.writeln;
	alias u=innate!string;
	u.writeln;
	s="bar";
	u.writeln;
}
*/

/** a weak symbol, if the type offer doesnt match will, void itself out, this is useful for templated defualted arguments*/
auto ref weak(T,alias A)(){
	static if(is(T:typeof(A))){
		return A;
	} else {
		return T.init;
}}
auto ref weak(T,S)(auto ref S a){
	static if(is(T:S)){
		return a;
	} else {
		return T.init;
}}


struct nullable(T){//temp should have opOverloads
	T get; alias get this;
	bool isNull=true;
	this(T t){
		get=t;
		isNull=false;
	}
}

void dummyrangefunction(R)(R r){
	static assert( ! __traits(compiles,r.isNull));//why is phoboes.nullable a range?
	auto a=r.front;
	bool b=r.empty;
	r.popFront;
}
void dummytuplefunction(T)(T t){
	t.expand;
}
void dummynullablefunction(T)(T t){
	bool b=t.isNull;
}
void dummysumtypefunction(T)(T t){
	static assert(0);//todo
}

enum isRange(T)=__traits(compiles,dummyrangefunction!T);
enum isTuple(T)=__traits(compiles,dummytuplefunction!T);
enum isNullable(T)=__traits(compiles,dummynullablefunction!T);
enum isSumtype(T)=__traits(compiles,dummysumtypefunction!T);

enum notimportantstruct(T)= ! (isRange!T || isTuple!T || isNullable!T || isSumtype!T);

//type ops/traits
auto removeenum(T)(T t){
	import core.internal.traits;
	return OriginalType!T(t);
}
template Members(T){
	import std.traits;
	static if(is(T==enum)){
		alias Members=EnumMembers!T;
	} else {
		alias Members=T.tupleof;
}}

//trivail algoriums?
auto replacewhen(alias F,T)(T t,T t_)=>F(t)?t_:t;
unittest{
	assert(2.replacewhen!(a=>a>5)(3)==2);
	assert(10.replacewhen!(a=>a>5)(3)==3);
}
T replacewhen(S,T)(S t,T t_) if(isNullable!(S)) => t.isNull?t_:t;
auto replacenull(S,T)(S t,T t_) if(isNullable!(S)) => t.isNull?t_:t;
auto replacenull(T)(T t,T t_)=>t;
unittest{
	auto i=nullable!int();
	assert(i.replacewhen(6)==6);
	i.isNull=false;
	assert(i.replacewhen(6)==0);
}
unittest{
	nullable!int bar;
	assert(bar.replacenull(3)==3);
	assert(5.replacenull(3)==5);
}
//parse
// I think part of the problem of std.conv being a mess is that strings are hard and theres some trade offs to make that should just be seperate, maybe three functions .to, .parse, .serialize
//lazy minium implimtations
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
/*
dmd -run parse.d -foo=1 -bar=hi
dmd -run parse.d -foo=foobar -bar=hi
void main(string[] s){
	import std.stdio;
	int foo;
	string bar;
	mixin parsecli!(foo,bar);
	parsecli_(s);
	foo.writeln;
	bar.writeln;
}
*/
//stdio
void unixexcape(int i){
	version(Windows) return;//TODO
	("\033["~i.to!string~"m").write;
}
void reset()=>unixexcape(0);
void underline()=>unixexcape(4);
void unixcolor(int i)=>unixexcape(30+i%8);
void warncolor(int i)=>unixcolor([7,4,5,3,6,1][max(i,0)%6]);//god why is the order of unix colors so strange

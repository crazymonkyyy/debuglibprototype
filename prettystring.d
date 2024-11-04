import std.conv:phoboesto=to;
/*
wraping the "leafs" of phoboes.conv.to but controlling the template hell myself, for better or worse

attempts to make a string for human consumtion including truncating data, some tabs, a prefered length of string(i.e. terminal line length of 120)


*/

template Members(T){
	import std.traits;
	static if(is(T==enum)){
		alias Members=EnumMembers!T;
	} else {
		alias Members=T.tupleof;
}}
template toprettystring(string somearg="hi"){
	string toprettystring(T:void)(T* p)=>p==null ? "null":"void*";//for context pointers
	
	string toprettystring(T:float)(T f) if(!is(T == enum)) =>f.phoboesto!string;
	string toprettystring(T:int)(T i) if(!is(T == enum))   =>i.phoboesto!string;
	string toprettystring(T:bool)(T b) if(!is(T == enum))  =>b.phoboesto!string;
	string toprettystring(T:string)(T s) =>s;
	
	string toprettystring(T)(T t) if(is(T == struct)||is(T==class))=>"struct";
	string toprettystring(T)(T t) if(is(T == enum))=>t.phoboesto!string;
	string toprettystring(T)(T t) if(is(T == union))=>t.phoboesto!string;
	
	string toprettystring(T)(T* t) =>"pointer";
	string toprettystring(T)(T[] t) =>"slice";
	string toprettystring(T,size_t N)(T[N] t) =>"array";
	string toprettystring(T,S)(T[S] t)=>"aa";
}



unittest{
	assert(3.14.toprettystring=="3.14");
	assert(1337.toprettystring=="1337");
	assert(false.toprettystring=="false");
	assert((void*)().toprettystring=="null");
	assert("hello".toprettystring=="hello");
}
unittest{
	import std;
	struct vec2{int x,y;}
	vec2().toprettystring.writeln;
	enum foo{a,b,c};
	foo foo_=foo.a;
	foo.a.toprettystring.writeln;
	union bar{int x;float y;}
	bar().toprettystring.writeln;
	class c{}
	auto d=new c;
	d.toprettystring.writeln;
	
	import std.traits;
	
	Members!foo.stringof.writeln;
	Members!vec2.stringof.writeln;
	Members!bar.stringof.writeln;
	int i;
	struct vec4{
		vec2 x,y;
		void poke(){i++;}
	}
	//typeof(vec4.tupleof[2]).stringof.writeln;
	//vec4().tupleof[2].toprettystring.writeln;
	//int delegate(int) poke;
	//typeof(poke).tupleof.stringof.writeln;
}
unittest{
	import std;
	int[3] foo;
	foo.toprettystring.writeln;
	(&foo).toprettystring.writeln;
	foo[].toprettystring.writeln;
	int[float] bar;
	bar.toprettystring.writeln;
}

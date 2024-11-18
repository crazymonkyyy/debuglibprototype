/*

pattern for breaking down ANY type in dlang (hopefully) perfectly

*/
auto removeenum(T)(T t){
	import core.internal.traits;
	return OriginalType!T(t);
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

string whatthis(T:void)(T* p)=>p==null ? "null void*":"void*";
string whatthis(typeof(null))=>"null litteral";

string whatthis(T:float)(T f) if(!is(T == enum)) =>"float";
string whatthis(T:double)(T f) if(!is(T == enum)) =>"double";
string whatthis(T:real)(T f) if(!is(T == enum)) =>"real";
string whatthis(T:byte)(T i) if(!is(T == enum))=>"byte";
string whatthis(T:ubyte)(T i) if(!is(T == enum))=>"ubyte";
string whatthis(T:short)(T i) if(!is(T == enum))=>"short";
string whatthis(T:ushort)(T i) if(!is(T == enum))=>"ushort";
string whatthis(T:int)(T i) if(!is(T == enum))=>"int";
string whatthis(T:uint)(T i) if(!is(T == enum))=>"uint";
string whatthis(T:long)(T i) if(!is(T == enum))=>"long";
string whatthis(T:ulong)(T i) if(!is(T == enum))=>"ulong";
string whatthis(T:bool)(T b) if(!is(T == enum))=>"bool";
string whatthis(T:char)(T c) if(!is(T == enum))=>"char";
string whatthis(T:wchar)(T c) if(!is(T == enum))=>"wchar";
string whatthis(T:dchar)(T c) if(!is(T == enum))=>"dchar";
string whatthis(T:string)(T s) if(!is(T == enum))=>"string";
string whatthis(T:wstring)(T s) if(!is(T == enum))=>"wstring";
string whatthis(T:dstring)(T s) if(!is(T == enum))=>"dstring";

string whatthis(T)(T t) if((is(T == struct)||is(T==class)) && notimportantstruct!T)=>"struct";
string whatthis(T)(T t) if(is(T == enum))=>"enum of "~t.removeenum.whatthis;
string whatthis(T)(T t) if(is(T == union))=>"union";

string whatthis(T)(T* t) =>t==null?"null pointer":"pointer";
string whatthis(T)(T[] t) =>"slice";
string whatthis(T,size_t N)(T[N] t)=>"array";
string whatthis(T,S)(T[S] t)=>"aa";

string whatthis(T)(T t) if(isRange!T)=>"range";
string whatthis(T)(T t) if(isTuple!T)=>"tuple";
string whatthis(T)(T t) if(isNullable!T)=>"nullable";
string whatthis(T)(T t) if(isSumtype!T)=>"sumtype";

void whatln(T)(T t){
	import std;
	writeln(t,":",whatthis(t));
}
unittest{
	struct myint{int i;}
	enum foo{a=1,b=2};
	foo.a.whatln;
	null.whatln;
}
alias seq(T...)=T;
template Members(T){
	alias Members=__traits(allMembers, T);
	//alias memberstemp=seq!();
	//static if(is(T==enum)){
	//	memberstemp=__traits(allMembers, T);
	//} else {
	//	memberstemp=__traits(allMembers, T);
	//}
	//static foreach(S;memberstemp){
	//	Members=seq!(Members,__traits(getMember, T, S));
	//}
}
void nestedwhatln(T)(T t){
	import std;
	t.write(':');
	static foreach(s;Members!T){
		__traits(child,t,s).whatthis.write(',');
	}
	writeln;
}
unittest{
	import std;
	struct vec2{int x,y; bool isvalid()=>x>9;}

	enum foo{a,b,c};
	foo foo_=foo.a;

	union bar{int x;float y;}

	class c{}
	auto d=new c;

	
	import std.traits;
	foo.a.nestedwhatln;
	vec2().nestedwhatln;
	bar().nestedwhatln;
	[1,2,3].map!(a=>a*2).whatln;
}

unittest{
	import std;
	Nullable!int n;
	n.whatln;
}

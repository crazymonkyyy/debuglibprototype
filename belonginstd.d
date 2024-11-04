/**
Holding file for a bunch of gists of stuff that belongs in an std, but at the minium viable produt for my debug lib

@grim, if your still working on making an opend std of some sort this would be my suggestions
*/
//meta
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

import std;
alias seq=AliasSeq;
template isrange(alias R,string s){
	static if(__traits(compiles,mixin("isInputRange!(typeof(R."~s~"))"))){
		enum isrange=mixin("isInputRange!(typeof(R."~s~"))");
	} else {
		enum isrange=false;
}}
template childranges(R){
	alias store=seq!();
	static foreach(s;FieldNameTuple!R){
		static if(isrange!(R,s)){
			//store=seq!(store,__traits(getMember,R,s));
			store=seq!(store,s);
		}
	}
	//alias childranges=store;
	enum string[] childranges=[store];
}
//unittest{
//	auto foo=[1,2,3];
//	auto bar=foo.map!"a*2".filter!(a=>a!=4);
//	childranges!(typeof(bar)).length.writeln;
//}
auto dig(string func,R)(R r){
	static if(__traits(compiles,mixin("r."~func))){
		return mixin("r."~func);
	} else {
		alias childs=childranges!R;
		//pragma(msg,childs.stringof);
		static assert(childs.length==1);
		return mixin("r."~childs[0]~".dig!func");
		//return __traits(child,childs[0],r).dig!func;
	}
}
//unittest{
//	auto foo=[1,2,3];
//	auto bar=foo.map!"a*2".filter!(a=>a!=4).map!"a*2";
//	dig!"length"(bar).writeln;
//	bar.popFront;
//	dig!"length"(bar).writeln;
//}
auto capisity(R)(R r)=>r.dig!"length";

unittest{
	auto foo=[1,2,3,4,5];
	assert(foo.map!"a*2".filter!"false".map!"a*2".dig!"length"<=5);
	assert(foo.map!"a*2".capisity==5);
}

auto torange(T)(T[] arr){
	struct range{
		T[] arr;
		int key;
		auto front()=>arr[key];
		void popFront(){key++;}
		bool empty()=>key>=arr.length;
	}
	return range(arr);
}
auto digmap(string s,R)(R r){
	struct map{
		R r;
		auto front()=>r.dig!s;
		void popFront(){r.popFront;}
		bool empty()=>r.empty;
	}
	return map(r);
}
unittest{
	auto foo="hello,world,foo,bar";
	foo.torange.filter!(a=>a==',').digmap!"key".writeln;
}

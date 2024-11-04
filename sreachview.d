import std;
struct sreachview(R1,R2){
	R1 r1;
	R2 r2;
	auto front()=>r2.front;
	void popFront(){r2.popFront;}
	bool empty()=>r2.empty;
	void popBack()()=>r2.popBack;
	auto back()()=>r2.back;
	bool unpop()(){
		if(r2.key==r1.key){return false;}
		r2.key--;
		assert(r2.key>=r1.key);
		return true;
	}
	auto unpopback()(){
		if(r2.keyback==r1.keyback){return false;}
		r2.keyback++;
		assert(r2.keyback<=r1.keyback);
		return true;
	}
	auto opIndex(K)(K k)=>r2[key];
	auto simply()=>r1[r2.key..r2.keyback+1];
	auto left()=>r1[0..r2.key];
	auto right()=>r1[r2.keyback+1..$];
}

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
ref dig(string func,R)(ref R r){
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

auto fixkeys(R)(R r){
	struct withkeys{
		R r; alias r this;
		ref key()=>r.dig!"key";
		ref keyback()=>r.dig!"keyback";
	}
	return withkeys(r);
}
auto torange(T)(T[] arr){
	struct range{
		T[] arr;
		int key;
		int keyback;
		auto front()=>arr[key];
		auto back()=>arr[keyback];
		void popFront(){key++;}
		void popBack(){key--;}
		bool empty()=>key>keyback;
		typeof(this) opSlice(int i,int j){
			return typeof(this)(arr,i,j-1);
		}
		auto simply()=>arr[key..keyback+1];
		auto fullcontext()=>typeof(this)(arr,0,cast(int)arr.length-1);
		int opDollar()=>keyback+1;
	}
	return range(arr,0,cast(int)arr.length-1);
}

unittest{
	auto r="foo,bar,foobar,baz,faz".torange;
	auto r2=r[4..7];
	r2.simply.writeln;
	auto v=sreachview!(typeof(r),typeof(r2))(r,r2);
	v.unpopback;
	v.simply.writeln;
}

auto makesreachview_p(alias F,R)(R r){
	auto r1=r.fullcontext;
	auto r2=F(r).fixkeys;
	return sreachview!(typeof(r1),typeof(r2))(r1,r2);
}
unittest{
	auto r="foo,bar,foobar,baz,faz".torange;
	auto r2=r[4..$];
	auto v=r2.makesreachview_p!(a=>a.filter!(b=>b==','));
	v.front;
	v.simply.writeln;
	v.popFront;
	v.simply.writeln;
	
}

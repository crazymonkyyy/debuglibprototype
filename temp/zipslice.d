struct fatslice(T){
	T[] data;
	int key,keyback;
	ref T opIndex(int i)=>data[i+key];
	int length()=>keyback-key;
	auto opSlice(int i,int j)=>typeof(this)(data,i+key,j+key);
	int opDollar()=>keyback-key;
	T[] simplify()=>data[key..keyback];
}
auto zipslice(A...)(A args){
	alias D=typeof(args[0].data);
	struct zip{
		D data;
		A opDollar;
		ref auto opIndex(int i)=>data[i];
		auto opSlice(int i,int j)=>fatslice!(typeof(data[0]))(data,i,j);
	}
	static foreach(B;args[1..$]){
		static assert(is(typeof(B.data)==typeof(args[0].data)));
		assert(B.data==args[0].data);
	}
	return zip(args[0].data,args);
}
unittest{
	int[10] data=[1,2,3,4,5,6,7,8,9,10];
	fatslice!int foo=fatslice!int(data[],3,7);
	fatslice!int bar=fatslice!int(data[],5,9);
	auto foobar=zipslice(foo,bar);
	import std;
	foo.simplify.writeln;
	bar.simplify.writeln;
	foobar[$[0].key..$[1].keyback].simplify.writeln;
	foobar[max($[0].key,$[1].key)..min($[0].keyback,$[1].keyback)].simplify.writeln;
}

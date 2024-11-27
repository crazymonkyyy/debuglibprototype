struct fatslice(T){
	T data;
	int key,keyback;
	ref auto opIndex(int i)=>data[i+key];
	int length()=>keyback-key;
	auto opSlice(int i,int j)=>typeof(this)(data,i+key,j+key);
	int opDollar()=>keyback-key;
	T simplify()=>data[key..keyback];
}
/*
Im not entirely sure of this appooch, its fairly magic tho

todo more rant
*/
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
auto endlineslice(string s,int i){
	//fatslice!(typeof(s[0])) o;
	fatslice!string o;
	o.data=s;
	int j;
	while(i!=0 && j<s.length){
		if(s[j++]=='\n'){
			switch(--i){
				case 0: o.keyback=j-1;break;
				case 1: o.key=j;break;
				default:
			}
		}
	}
	return o;
}

template unmix_(string file=__FILE__,int line=__LINE__){
	enum unmix_=import(file).endlineslice(line);
}
//unittest{
//	import std;
//	unmix!().simplify.writeln; //hello
//}

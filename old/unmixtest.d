import unmix;
import std.stdio;
import std.string;
template bar(T...){
	int bar(string file=__FILE__,int line=__LINE__,S...)(S s){
		string[] args=unmixargs!("bar",file,line);
		if(args.length==2 && args[0].strip.equal("foo") && args[1].strip.equal("baz")){
			return 0;
		}
		line.writeln(" handled incorrectly ",args);
		return 1;
}}

unittest{
	int foo,baz;
	foo.bar(baz);
	foo.    bar   ( baz );
	(foo).bar(baz);
	//foo!1.bar(baz);
	bar(foo,baz);
	bar!1(foo,baz);
}

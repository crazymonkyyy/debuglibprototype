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

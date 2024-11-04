void dummynullablefunction(T)(T t){
	bool b=t.isNull;
}
enum isNullable(T)=__traits(compiles,dummynullablefunction!T);

auto replacewhen(alias F,T)(T t,T t_)=>F(t)?t_:t;
unittest{
	assert(2.replacewhen!(a=>a>5)(3)==2);
	assert(10.replacewhen!(a=>a>5)(3)==3);
}
T replacewhen(S,T)(S t,T t_) if(isNullable!(S)) => t.isNull?t_:t;
struct nullable(T){//temp
	T get; alias get this;
	bool isNull=true;
	this(T t){
		get=t;
		isNull=false;
	}
}
unittest{
	auto i=nullable!int();
	assert(i.replacewhen(6)==6);
	i.isNull=false;
	assert(i.replacewhen(6)==0);
}
auto replacenull(S,T)(S t,T t_) if(isNullable!(S)) => t.isNull?t_:t;
auto replacenull(T)(T t,T t_)=>t;
unittest{
	nullable!int bar;
	assert(bar.replacenull(3)==3);
	assert(5.replacenull(3)==5);
}

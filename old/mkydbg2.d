import unmix;
import mkymeta;

char to1char(int i){
	i%=10;
	return cast(char)('0'+i);
}
string to4char(int i){
	int digit=(i>9)+(i>99)+(i>999)+(i>9999)
				+(i>99999)+(i>999_999)+(i>9999_999)+(i>99_999_999);
	switch(digit){
		case 0: return "  "~to1char(i)~'|';
		case 1: return " "~to1char(i/10)~to1char(i)~'|';
		case 2: return ""~to1char(i/100)~to1char(i/10)~to1char(i)~'|';
		case 3: return ""~to1char(i/1000)~to1char(i/100)~to1char(i/10)~to1char(i);
		case 4: return ""~to1char(i/10000)~to1char(i/1000)~"k"~to1char(i/100);
		case 5: return ""~to1char(i/100000)~to1char(i/10000)~to1char(i/1000)~"k";
		case 6: return ""~to1char(i/1000000)~"M"~to1char(i/100000)~to1char(i/10000);
		case 7: return ""~to1char(i/10000000)~to1char(i/1000000)~"M"~to1char(i/100000);
		default: assert(0,"adr, its time to stop and simply your code, 9 digits lines of code is to many -monkyyy");
}}
unittest{
	assert(7.to4char=="  7|");
	assert(67.to4char==" 67|");
	assert(567.to4char=="567|");
	assert(4567.to4char=="4567");
	assert(34567.to4char=="34k5");
	assert(234567.to4char=="234k");
	assert(1234567.to4char=="1M23");
	assert(91234567.to4char=="91M2");
	//assert(891234567.to4char=="891M"); fails intentionally
}
void unixexcape(int i){
	import std;
	version(Windows) return;//TODO
	("\033["~i.to!string~"m").write;
}
void reset()=>unixexcape(0);
void underline()=>unixexcape(4);
void unixcolor(int i)=>unixexcape(30+i%8);
import std.algorithm;//TODO: write my own max
void warncolor(int i)=>unixcolor([7,4,5,3,6,1][max(i,0)%6]);//god why is the order of unix colors so strange
import std;
auto softtab(int max=120,R1,R2)(R1 r1,R2 r2)=>//TODO: write my own
	chain(
		r1.filter!(a=>a!='\t'),
		(r1.length+r2.length<max)?"\t":"",
		r2.filter!(a=>a!='\t')
	).detabber(8);

//-----
alias loglvl()=innate!(int,0,"logging");
alias activefile()=innate!(string,"","logging");
void logheader()(string file=__FILE__){
	import std;
	if(activefile!()!=file){
		activefile!()=file;
		underline();file.writeln;reset();
}}

void logln(int loglvl_=0,string file=__FILE__,int line=__LINE__,T...)(T args){
	import std;
	if(loglvl_<loglvl!()){return;}
	logheader(file);
	warncolor(loglvl_);
	line.to4char.write;
	writeln(args);
	reset();
}
void debugln(int loglvl_=1,string file=__FILE__,int line=__LINE__,T)(T t){
	//enum string[] args=unmixargs!("debugln",file,line);
	string[] args=unmixargs!("debugln",file,line);
	//static assert(args.length==1);
	assert(args.length==1);
	logln!(loglvl_,file,line)(
		softtab(args[0],t.to!string));
}
template compareln(string op,int loglvl_=1,string reference="compareln",string file=__FILE__,int line=__LINE__){//TODO: add string
	void compareln(T,S)(T t,S s){
		string[] args=unmixargs!(reference,file,line);
		assert(args.length==2);
		if(mixin("t"~op~"s")){
			logln!(loglvl_,file,line)(
				softtab(args[0]~op~args[1],t.to!string~op~s.to!string));
}}}


//TODO document
alias warnlt(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("<",loglvl_,"warnlt",file,line);
alias warngt(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!(">",loglvl_,"warngt",file,line);
alias warnle(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("<=",loglvl_,"warnle",file,line);
alias warnge(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!(">=",loglvl_,"warnge",file,line);
alias warneq(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("==",loglvl_,"warneq",file,line);
alias warnnt(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("!=",loglvl_,"warnnt",file,line);
	
//todo test
alias warnlessthen(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("<",loglvl_,"warnlessthen",file,line);
alias warngreaterthen(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!(">",loglvl_,"warngreaterthen",file,line);
alias warnlessequal(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("<=",loglvl_,"warnlessequal",file,line);
alias warngreaterthen(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!(">=",loglvl_,"warngreaterthen",file,line);
alias warnequal(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("==",loglvl_,"warnequal",file,line);
alias warnnotequal(int loglvl_=1,string file=__FILE__,int line=__LINE__)
	=compareln!("!=",loglvl_,"warnnotequal",file,line);


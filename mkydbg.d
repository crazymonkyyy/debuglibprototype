template unmix(string file=__FILE__,int line=__LINE__){
	import std;
	enum string unmix=import(file).split('\n').drop(line-1).front;
}

char to1char(int i){
	assert(i>=0&&i<=9);
	return cast(char)('0'+i);
}
string to4char(int i){//TODO support up to ... 8? digits if badly
	int digit=(i>9)+(i>99)+(i>999)+(i>9999);
	switch(digit){
		case 0: return "  "~to1char(i)~'|';
		case 1: return " "~to1char(i/10)~to1char(i%10)~'|';
		case 2: return ""~to1char(i/100)~to1char((i/10)%10)~to1char(i%10)~'|';
		case 3: return ""~to1char(i/1000)~to1char((i/100)%10)~to1char((i/10)%10)~to1char(i%10);
		default: assert(0);
}}
unittest{
	assert(7.to4char=="  7|");
	assert(67.to4char==" 67|");
	assert(567.to4char=="567|");
	assert(4567.to4char=="4567");
}
void unixexcape(int i){
	import std;
	version(Windows) return;//TODO
	("\033["~i.to!string~"m").write;
}
void reset()=>unixexcape(0);
void underline()=>unixexcape(4);
void unixcolor(int i)=>unixexcape(30+i%8);
import std.algorithm;
void warncolor(int i)=>unixcolor([7,4,5,3,6,1][max(i,0)%6]);//god why is the order of unix colors so strange
import std;
auto softtab(int max=120,R1,R2)(R1 r1,R2 r2)=>//todo consider fixing miscounting bugs, also maybe genericify for n ranges
	chain(
		r1.filter!(a=>a!='\t'),
		(r1.length+r2.length<max)?"\t":"",
		r2.filter!(a=>a!='\t')
	).detabber(8);
string matchparn(string s){//todo more genertic
	assert(s[0]=='(');
	int i=1;
	int count=1;
	while(i<s.length){
		if(s[i]==')'){count--;}
		if(s[i]=='('){count++;}
		if(count==0){return s[1..i];}
		i++;
	}
	assert(0,"mismatched");
}
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
	import std;
	logln!(loglvl_,file,line)(
		softtab(
			unmix!(file,line).find("debugln").find('(').matchparn,
			t.to!string));
}

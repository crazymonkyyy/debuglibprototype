import belonginstd;
alias loglvl()=innate!(int,0,"logging");
alias activefile()=innate!(string,"","logging");
alias currentfile()=innate!(string,"","current-logging");

import softtab;
import unmix;
// internal detail: controls filtering by file and file sections
bool fileheaderconsider()(string s){
	//import std;
	//writeln(s,activefile!(),s!=activefile!());
	if(activefile!().length>0 && s!=activefile!()){
		return false;
	}
	if(currentfile!()!=s){
		currentfile!()=s;
		printunderline(s);
	}
	return true;
}
//unittest{
//	fileheaderconsider("AHHH");
//	fileheaderconsider("AHHH");
//	fileheaderconsider("AHHH");
//	fileheaderconsider("foo");
//	activefile!()="bar";
//	fileheaderconsider("foobar");
//	fileheaderconsider("bar");
//}
void unmixln(int loglvl_=0,string file=__FILE__,int line=__LINE__,T)(T t){
	if(fileheaderconsider(file)){
		softln(line,loglvl_,unmix_!(file,line).simplify,"\t//",t);
}}
// int foo(string)=>1;
//unittest{
//	printunderline("foo");
//	"hello".foo.unmixln;
//	printunderline("bar");
//}
import parsecli;

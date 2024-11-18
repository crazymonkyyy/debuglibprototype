import std;
bool equal(T,S)(T a,S b){
	if(a.length!=b.length){return false;}
	foreach(i;0..a.length){
		if(a[i]!=b[i]){return false;}}
	return true;
}
int findnthindex(R1,R2)(R1 s,R2 t,int n=1){
	if(t==""){return -1;}
	int i=0;
	while(i<s.length-t.length+1){
		if(s[i..i+t.length].equal(t)){
			n--;
		}
		if(n==0){
			return i;
		}
		i++;
	}
	return -1;
}

unittest{
	//findnthindex("hello world","wor").writeln;
}
string endlineslice(string s,int n){
	int i=findnthindex(s,"\n",n);
	if(i==-1){return s;}
	int j=findnthindex(s[i+1..$],"\n");
	if(j==-1){return s[i..$];}
	return s[i..i+j];
}
struct oslice(R){
	static assert(is(R==string));
	R s;
	int i,j;
	auto opIndex(int k)=>s[i+k];
	auto opDollar()=>j-i;
	auto length()=>opDollar;
	auto opSlice(K,L)(K k,L l)=>typeof(this)(s,i+cast(int)k,i+cast(int)l);
	R simply()=>s[i..j];
	alias simply this;
}
auto outerslice(R,I,J)(R s,I i,J j){
	return oslice!R(s,cast(int)i,cast(int)j);
}
auto endlineouterslice(string s,int n){
	int i=findnthindex(s,"\n",n);
	if(i==-1){return outerslice(s,0,s.length);}
	int j=findnthindex(s[i+1..$],"\n");
	if(j==-1){return outerslice(s,i,s.length);}
	return outerslice(s,i,j+i);
}
auto findslice(R1,R2)(R1 s,R2 t,int n=1){
	int i=findnthindex(s,t,n);
	return s[i..i+t.length];
}
//unittest{
//	//hello
//	auto s=import(__FILE__).endlineouterslice(__LINE__-1);
//	//bye
//	foreach(i;0..6){
//		s[-i].write;
//	}
//	"---".writeln;
//	foreach(i;0..8){
//		s[$+i].write;
//	}
//	"---".writeln;
//	s[-5..0].writeln;
//	s[$+5..$+8].writeln;
//}

template unmix(string file=__FILE__,int line=__LINE__){
	enum string unmix=import(file).endlineslice(line-1);
}
alias iswhite=std.ascii.isWhite;
alias isanum=std.ascii.isAlphaNum;
string[] __unmixargs(string refence,string file_,int line){
	string[] output;
	auto file=file_.endlineouterslice(line-1).findslice(refence);
	
	while(file[-1].iswhite){
		file=file[-1..$];
	}
	if(file[-1]=='.'){
		while(file[-1].iswhite){
			file=file[-1..$];
		}
		//"utfs detected".writeln(line);
		auto utfs=file[-2..-1];
		//utfs.simply.writeln;
		if(utfs[0]==')'){
			//"() utfs detected".writeln(line);
			utfs=utfs[-1..$];
			while(utfs[0]!='('){
				utfs=utfs[-1..$];
				if(utfs[0]==')'){
					"nested () utfs detected".writeln(line);
				}
			}
			if(utfs[-1]=='!'){
				"templated utfs detected".writeln(line);
			}
			output~=utfs[1..$-1];
		} else {
			while(utfs[0].isanum){
				utfs=utfs[-1..$];
			}
			output~=utfs[1..$];
		}
	}
	while(file[$].iswhite){
		file=file[0..$+1];
	}
	if(file[$]=='!'){
		//"template detected".writeln;
		file=file[0..$+1];
		if(file[$-1]=='('){
			while(file[$-1]!=')'){
				file=file[0..$+1];
				if(file[$-1]=='('){
					"nested ()".writeln;
			}}
			file=file[0..$+1];
		} else {
			while(file[$-1].isanum){
				file=file[0..$+1];
			}
			file=file[0..$+1];
		}
	}
	if(file[$]==';'){
		"no arguements detected?".writeln(line);
	} else {
		auto args=file[$..$+1];
		if(args[0]!='('){
			"panic".writeln; return output;
		}
		args=args[0..$+1];
		while(args[$-1]!=')'){
			args=args[0..$+1];
			if(args[$-1]=='('){
				"nested () in args detected".writeln;
			}
			if(args[$-1]=='"'){
				"strings detected".writeln;
			}
		}
		int[] commas;
		args=args[1..$-1];
		output~=args.simply.split(',');
	}
	return output;
}
template unmixargs(string refence,string file=__FILE__,int line=__LINE__){
	//enum string[] unmixargs=refence.__unmixargs(import(file),line);
	string[] unmixargs()=>refence.__unmixargs(import(file),line);
}
/*
foo.bar!1(baz);
(foo).bar!(1);
bar(foo,baz);
bar!1(foo,bar);
bar!"()()()()"(foo,baz);
foo!(1,2,3).bar!4(baz)
*/



//unittest{
//	/* foo */ unmix!().writeln;
//}

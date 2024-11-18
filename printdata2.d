/**
lazy "tsv" printer, not for real use, just solving the softtab problem
**/
import std;
void print_(T)(ref T buf,ulong len){
	asm{
	mov RAX, 1;
	mov RDI, 1;
	mov RSI,buf;
	mov RDX,len;
	syscall;
}}
char to1char(int i){
	i%=10;
	return cast(char)('0'+i);
}
string to4char(int i){//consider making this inline and nonallocating
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
int tabwidth=8;
struct softtabprinter{
	char[9] details="\033[33m000|";
	//------------------0123456789
	void setcolor(int c){
		details[3]=max(c,0)%7+'1';
	}
	void setline(int l){
		details[5..9]=l.to4char;
	}
	union u{char[121] chr;ubyte[121] byt;}
	u data;
	int length;
	void store(string s){
		foreach(c;s){
			if(length>=data.chr.length){return;}
			data.chr[length++]=c;
	}}
	void print(){// TODO: theres an off by 1 error in this mess
		//print_(data.chr,length);
		ubyte* offsets=&data.byt[$-1];
		int i;
		foreach(c;data.chr[0..length]){
			if(c=='\t'){
				*(offsets--)=cast(ubyte)i;
				i+=tabwidth-(i%tabwidth);
			} else {
				i++;
			}
			if(i>120-details.length){goto earlyexit;}//TODO: pick more accurate number
		}
		if(false){
			earlyexit:
			foreach(ref c;data.chr[0..length]){
				if(c=='\t'){c=' ';}
			}
			print_(details,length+details.length);
			writeln;
			length=0;
			return;
		}
		int j=i;
		offsets++;
		
		while(length!=0){
			length--;
			if(data.chr[length]=='\t'){
				//"tab".writeln(i," ",*offsets);
				while(i>=*offsets){
					data.chr[i--]=' ';
				}
				offsets++;
			} else {
				data.chr[i--]=data.chr[length];
			}
		}
		print_(details,j+1+details.length);
		writeln;
	}
	
}
void main(string[] s){
	assert(s.length==2,"gib file");
	softtabprinter foo;
	foreach(i,data;File(s[1]).byLineCopy.enumerate){
		foo.setcolor(cast(int)i);
		foo.setline(cast(int)i);
		foo.store(data);
		foo.print;
		//foo.store("\n");
		//foo.print;
	}
}

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
int tabwidth=16;
struct softtabprinter{
	union u{char[121] chr;ubyte[121] byt;}
	u data;
	int length;
	void store(string s){
		foreach(c;s){
			data.chr[length++]=c;
	}}
	void print(){
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
		print_(data.chr,j+1);
		writeln;
	}
	
}
void main(string[] s){
	assert(s.length==2,"gib file");
	softtabprinter foo;
	foreach(data;File(s[1]).byLineCopy){
		foo.store(data);
		foo.print;
		//foo.store("\n");
		//foo.print;
	}
}

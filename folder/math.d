import mkydbg;
float safedivide(float a,float b){
	if(b==0){
		logln!2("/0 triggered");
		return float.infinity;
	}
	if(a!=a || b!=b){
		logln!4("nan or something");
	}
	return a/b;
}

#procedure lsclGetLeadingDenPower(DEN,LA,WRAP,POW)

* lsclGetLeadingDenPower() extracts the leading power of the denominator
* DEN in the variable LA, where DEN is assumed to a be a single argument function
* of the form DEN(... + ... LA^x1 + ... LA^x2 + ...). This gets replaced with
* WRAP(POW(x)*DEN(...)) where x is the leading power in LA.
* Cases where a signle term contains products of multiple DENs are explicitly supported.

* First we wrap DEN into WRAP, copying the argument of DEN into the 2nd argument of WRAP;
id `DEN'(lsclS?) = `WRAP'(`DEN'(lsclS),lsclS);


*  Looking tat the 2nd argument of WRAP, we multiply each term with POW containing the 
*  power of LA as its argument

argument `WRAP',2;
$minLaPow = `POW'(count_(`LA',1));
multiply $minLaPow;
endargument;

* we split sums and products such, that POW(...) will appear as single argument of WRAP
splitarg `WRAP';
factarg `WRAP';

* now we move all occurences of POW(...) into the first argument of WRAP that already contains DEN
repeat;
id `WRAP'(lsclS1?,?a,`POW'(lsclS2?),?b) = `WRAP'(lsclS1*`POW'(lsclS2),?a,?b);
endrepeat;

* drop all argument of WRAP but the first one
transform `WRAP', dropargs(2,last);
* join the products of POWs into a single POW with multiple arguments, then keep only the smallest
* argument
argument `WRAP';
chainin `POW';
id `POW'(lsclS1?,?a) = `POW'(min_(lsclS1,?a));
endargument;
* this is for expressions that don't contain any DENs or the DENs are free of LA
id `WRAP'() = 1;
#endprocedure

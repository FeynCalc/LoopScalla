#procedure lsclColorIsolate(NAME1,NAME2)

* lsclColorIsolate() puts color algebra related symbols
* outside of the brackets and employs argtoextrasymbols
* to prevent FORM from looking into the brackets. This is 
* very useful before color algebra simplifications that 
* significantly increase the  number of terms (e.g. Fierz 
* identities)

b lsclSUNF, lsclSUND, lsclSUNTF, lsclSUNDelta, lsclSUNFDelta;
.sort
Collect `NAME1', `NAME2';
argtoextrasymbol `NAME1', `NAME2';
#endprocedure

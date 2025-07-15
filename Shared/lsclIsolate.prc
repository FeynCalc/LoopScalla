#procedure lsclIsolate(NAME1,NAME2,?ISOSYMBOLS)

* lsclIsolate() puts symbols listed in ISOSYMBOLS
* outside of the brackets and employs argtoextrasymbols
* to prevent FORM from looking into the brackets. This is 
* very useful for all kinds of simplifications that 
* significantly increase the  number of terms

#message lsclIsolate: Bracketing `?ISOSYMBOLS': `time_' ...
b `?ISOSYMBOLS'
#if (`lsclPprIsolateLoopMomenta'!=0)
#do i=1, `lsclNLoops'
k`i',
#enddo
#endif
;

.sort
Collect `NAME1', `NAME2';
argtoextrasymbol `NAME1', `NAME2';
#message lsclIsolate: ... done: `time_'
#endprocedure

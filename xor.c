#include "src/compiled.h"

#include <stdlib.h>

Obj xor(Obj self, Obj A, Obj B)
{
    
    unsigned char *a, *b, *c;
    Obj C;
    int max_len = 256;
    int len_a, len_b, i;

    len_a = LEN_PLIST(A);   
    len_b = LEN_PLIST(B);

    if (len_a > len_b){
	max_len = len_a;
    }
    else {
	max_len = len_b;
    }
	
    a = (unsigned char*)calloc(max_len, sizeof(*a));
    b = (unsigned char*)calloc(max_len, sizeof(*b));
    c = (unsigned char*)malloc(max_len*sizeof(*c));

    for (i = 0; i < len_a; i++) {
        a[i] = INT_INTOBJ(ELM_PLIST(A, i+1));
    }

    for (i = 0; i < len_b; i++) {
        b[i] = INT_INTOBJ(ELM_PLIST(B, i+1));
    }

    for (i = 0; i < max_len; i++) {
        c[i] = a[i] ^ b[i];
    }

    C = NEW_PLIST( T_PLIST, max_len);
    SET_LEN_PLIST(C, (Int)max_len);
  

    for (i = 0; i < max_len; i++) {
        SET_ELM_PLIST( C, i+1, INTOBJ_INT( c[i] ) );
	CHANGED_BAG( C );
    }
    
    
    free(a);
    free(b);
    free(c);

    return C;
}

/* 
 * GVarFunc - list of functions to export
 */
static StructGVarFunc GVarFunc[] = {
  
  { "_Xor", 2, "a, b", xor, "xor.c:xor" },
  { 0 }
};

static Int InitKernel (StructInitInfo * module)
{
  InitHdlrFuncsFromTable(GVarFunc);
  return 0;
}

static Int InitLibrary(StructInitInfo * module)
{
  InitGVarFuncsFromTable(GVarFunc);
  return 0;
}

static StructInitInfo module = {
  MODULE_DYNAMIC,
  "BNCUpTime",
  0,
  0,
  0,
  0,
  InitKernel,
  InitLibrary,
  0,
  0,
  0,
  0
};

StructInitInfo * Init__Dynamic(void)
{
  return &module;
}

StructInitInfo * Init__BNCUpTime(void)
{
  return &module;
}

#ifdef __cplusplus
}
#endif

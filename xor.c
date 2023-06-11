#include "src/compiled.h"

#include <stdlib.h>
#include <string.h>

Obj xor(Obj self, Obj A, Obj B)
{
    int len_a = LEN_PLIST(A);   
    int len_b = LEN_PLIST(B);

    int bigger_len, smaller_len;
    Obj bigger, smaller;

    if (len_a > len_b) {
      bigger_len = len_a;
      smaller_len = len_b;

      bigger = A;
      smaller = B;
    } else {
      bigger_len = len_b;
      smaller_len = len_a;

      bigger = B;
      smaller = A;
    }

    int offset = bigger_len - smaller_len;
    unsigned char *c = (unsigned char*)malloc(bigger_len*sizeof(*c));
    memset(c, 0, bigger_len);

    for (int i = 0; i < bigger_len; i++) {
        unsigned char a = INT_INTOBJ(ELM_PLIST(bigger, i+1));
        unsigned char b = i < offset ? 0 : INT_INTOBJ(ELM_PLIST(smaller, i+1-offset));
        c[i] = a ^ b;
    }
    
    Obj C = NEW_PLIST( T_PLIST, bigger_len);
    SET_LEN_PLIST(C, (Int)bigger_len);
  

    for (int i = 0; i < bigger_len; i++) {
      SET_ELM_PLIST( C, i+1, INTOBJ_INT( c[i] ) );
	    CHANGED_BAG( C );
    }
    
    free(c);

    return C;
}

/* 
 * GVarFunc - list of functions to export
 */
static StructGVarFunc GVarFunc[] = {
  
  { "Xor", 2, "a, b", xor, "xor.c:xor" },
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

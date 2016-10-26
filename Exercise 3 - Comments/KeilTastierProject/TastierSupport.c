#include <stdio.h>
#include <stdlib.h>

// div function

extern int TastierDiv(int, int);

int TastierDiv(int i, int j) {
    div_t result;
    result=div(i,j);
    return result.quot;
}

// mod function

extern int TastierMod(int, int);

int TastierMod(int i, int j) {
    div_t result;
    result=div(i,j);
    return result.rem;
}

// print integer value

extern void TastierPrintInt(int);

void TastierPrintInt(int i) {
    printf("%d\n", i);
}

// print true

extern void TastierPrintTrue(void);

void TastierPrintTrue(void) {
    printf("true\n");
}

// print false

extern void TastierPrintFalse(void);

void TastierPrintFalse(void) {
    printf("false\n");
}

// read integer value

extern int TastierReadInt(void);

int TastierReadInt(void) {
    int i;
    scanf("%d", &i);
    return i;
}

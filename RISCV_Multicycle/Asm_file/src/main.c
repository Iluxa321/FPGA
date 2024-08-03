#include "main.h"
#include <math.h>
extern void _test_go(void);


void delay(uint32_t cnt) {
    volatile uint32_t i = 0;
    while(i != cnt) {
        i++;
    }
}


float a;
float b = 0;

int main(void) {
    
    // while(1) {
    //     _test_go();
    // }
    seg_t->data = 100;
    seg_t->controll = 1;
    while(1) {
        a = sin(b);
        // if(seg_t->controll == 1) seg_t->controll = 0;
        // else seg_t->controll = 1;
        seg_t->data = (uint32_t) a;
        delay(1);
        b = b + 0.01;
    }

    return 0;
}




// #define N 10

// extern void _stop(void);
// void sort(uint32_t *arr, uint32_t n);
// void copy(uint32_t *arr1, uint32_t *arr2, uint8_t n);
// int cmp(const void *a, const void *b);

// uint32_t arr[N] = {1,3,3,6,74,78,23,2,0,18};
// uint32_t arr2[N] = {0,0,0,0,0,0,0,0,0,0};

// // uint8_t maxVal;

// void main(void) {
//     // maxVal = 0;
//     // sort(arr, 10);
//     uint8_t i = 0;
//     copy((uint32_t *) arr, arr2, N);
//     sort(arr2, N);
//     // qsort(arr, arr2, 10, cmp);
//     _stop();
//     return;
// }


// int cmp(const void *a, const void *b) {
//     return *(int*)a - *(int*)b;
// }

// void copy(uint32_t *arr1, uint32_t *arr2, uint8_t n) {
//     for(int i=0; i < n; i++) {
//         arr2[i]=arr1[i];
//     }
// }

// void sort(uint32_t *arr, uint32_t n) {
//     for(int i = 0 ; i < n - 1; i++) { 
//        // сравниваем два соседних элемента.
//        for(int j = 0 ; j < n - i - 1 ; j++) {  
//            if(arr[j] > arr[j+1]) {           
//               // если они идут в неправильном порядке, то  
//               //  меняем их местами. 
//               int tmp = arr[j];
//               arr[j] = arr[j+1];
//               arr[j+1] = tmp; 
//            }
//         }
//     }
// }


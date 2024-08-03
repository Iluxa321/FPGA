#if !defined(DEVICE)
#define DEVICE

#include <inttypes.h>

typedef struct {
    volatile uint32_t controll;
    volatile uint32_t data;
}Seg_t;

#define PERIPH_BASE     0x40000

#define SEG_BASE        (PERIPH_BASE + 0)

#define seg_t           ((Seg_t *) SEG_BASE)


#endif // DEVICE

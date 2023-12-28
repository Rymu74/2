; keyboard_isr_stub.asm

global keyboard_isr_stub

extern keyboard_isr

keyboard_isr_stub:
    ; Save context if needed
    ; (e.g., push registers to stack)

    ; Call the C ISR
    call keyboard_isr

    ; Restore context if needed
    ; (e.g., pop registers from stack)

    ; Notify the PIC that the interrupt has been handled
    ; (e.g., outb to PIC)

    ; Return from interrupt
    iret

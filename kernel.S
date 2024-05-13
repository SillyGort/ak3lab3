.syntax unified
.cpu cortex-m4
.thumb
.equ a, 5
.equ b, 3
.equ c, 2

.global vtable_kernel
.global __kernel_reset__

.type vtable_kernel, %object
.type __kernel_reset__, %function

.section .interrupt_vector
vtable_kernel:
    .word __stack_start
    .word __kernel_reset__+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "

.section .text
__kernel_reset__:
    ldr r0, =data
    bl dbgput_line
    
    // calculate
    MOV R1, a
    MOV R2, b
    MOV R3, c

    MOV R0, R1
    SUB R0, R0, R2

    MOV R4, R0

    MOV R1, #3
    MUL R0, R4, R1

    MOV R4, #1
loop_pow:
    CMP R3, #0
    BLE end_pow
    LSLS R4, R4, #1
    SUBS R3, R3, #1
    B loop_pow
end_pow:

    ADD R3, R0, R4

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num

end:
    b end

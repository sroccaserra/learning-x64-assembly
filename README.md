Learning x64 assembly, following the book Learn to Program with Assembly.

- https://link.springer.com/book/10.1007/978-1-4842-7437-8

The examples run on Linux, and require the "as" assembler, and a linker.

To run an example, like "src/factorialstack.s", you can use `make
factorialstack`.

Note: some early examples use a non zero exit value to show the result, so they
appear to fail, this is intended.

## Learnings

### Misc instructions

Move memory blocks by setting `%rsi` to src and `%rdi` to dst, `%rcx` to count,
then apply with `rep movsq`.

Compare memory blocks by setting `%rsi` and `%rdi`, compare with `repe cmpsq`.

Find a 0 char by setting `%rdi` to the string address, set `%al` to `$0`, then
apply `repne scasb`.

### System calls


When the kernel is invoked with the syscall instruction , it reads the system
call number from `%rax`.

The parameters, if needed, of a system call are placed in the following registers:

    1.  %rdi
    2.  %rsi
    3.  %rdx
    4.  %r10
    5.  %r8
    6.  %r9

`man 2 syscalls`, `man 2 read`


The syscall instruction clobbers registers `%rcx` (this stores where the next
instruction will be when the kernel returns) and `%r11` (the current contents
of `%eflags` get copied to `%r11`). Then, if the system call has a value to
give back to the program, it will store that value in `%rax`.

### Function calls

#### Preservation of Registers

The calling conventions require that the function being called should preserve
the contents of the registers `%rbp`, `%rbx`, and `%r12` through `%r15`. This
means that if you want to use these registers, you have to save what is already
there first to memory or the stack and restore them before you return.

#### Passing input parameters

Parameters are identified by position, and the positions correspond to the
registers as follows:

    1.  %rdi
    2.  %rsi
    3.  %rdx
    4.  %rcx
    5.  %r8
    6.  %r9

If there are more than six parameters, all additional parameters get pushed
onto the stack as quadwords (using pushq). The last parameter gets pushed onto
the stack first.

#### Returning output parameters

Return values get returned in %rax. The ABI specification allows for using %rdx
as well if there is a second return value.

#### Preserving the stack

Functions can allocate memory on the stack, the `%rbp` contains the base
pointer to this location. If a function needs to allocate memory on the stack,
it needs to preserve the existing base pointer, allocate its memory, and when
the function is done, it needs to free the memory and restore the base pointer.

Example:

``` assembly
    # Save the pointer to the previous stack frame
    pushq %rbp
    # Copy the stack pointer to the base pointer for a fixed reference point
    movq %rsp, %rbp
    # Reserve however much memory on the stack I need
    subq $NUMBYTES, %rsp
```

Then, at the end of the function, these steps should be reversed:

``` assembly
    # Restore the stack pointer
    movq %rbp, %rsp
    # Restore the base pointer
    popq %rbp
```

The `enter` and `leave` instruction do something equivalent.

Always allocate multiples of 16 bytes to keep the stack alligned.

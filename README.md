# Debugger

After some tryouts it ended up being an Opal application. That is ruby as javascript in the browser.

![Debugger](https://raw.githubusercontent.com/salama/salama-debugger/master/static/debugger.png)

- On the left are the classes of the system. Next idea is to have hover info about them.
- Next a source code view (not implemented)
- next a view of the Virtual Instructions
- last section, current block with current Register Instruction highlighted
- step (next) button for single stepping
- status: starting , running , exited
- bottom row are the registers. If the register hold an object the variables are shown.
    (also should have hover info) , the first letter indicates the class, the number is the address

So lots to do, but a good start.



I don't want to use gdb anymore, and it would be easier without using the qemu setup, so:

- single step debugging of the register machine level (as close to arm as need be)
- visual transitions for steps
- visualisation of data in registers (some kind of link to the object)
- show the current instruction and a few around
- show vm object (message etc)
- show effect of register transitions on vm objects
- visualize vm object content (again some links)


# Space

- Visualise the object space in some way
- Visualise single object, bit like atoms
- values immediate
- objects as link

# Debugger

After some tryouts it ended up being an Opal application. That is ruby as javascript in the browser.
Below is a screenshot.

![Debugger](https://raw.githubusercontent.com/salama/salama-debugger/master/static/debugger.png)

## Views

From left to right there are several views showing different data and controls.
All of the green boxes are in fact pop-up menus and can show more information.  
Most of these are implemented as a single class with the name reflecting what part.
I wrote 2 base classes that handle element generation (ie there is hardly any html involved, just elements)

### Switch view

Top left at the top is a little control to switch files.
The files need to be in the repository, but at least one can have several and switch between
them without stopping the debugger.

Parsing is the only thing that opal chokes on, so the files are parsed by a server script and the
ast is sent to the browser.

### Classes View

The first column on the left is a list of classes in the system. Like on all boxes one can hover
over a name to look at the class and it's instance variables (recursively)


### Source View

Next is a view of the Soml source. The Source is reconstructed from the ast as html.
Soml (Salama object machine language) is is a statically typed language,
maybe in spirit close to c++ (without the c). In the future Salama will compile ruby to soml.

While stepping through the code, those parts of the code that are active get highlighted in blue.

Currently stepping is done only in register instructions, which means that depending on the source
constructs it may take many steps for the cursor to move on.  

Each step will show progress on the register level though (next view)


### Register Instruction view

Salama defines a register machine level which is quite close to the arm machine, but with more
sensible names. It has 16 registers (below) and an instruction set that is useful for Soml.

Data movement related instruction implement an indexed get and set. There is also Constant load and
integer operators and off course branches.
Instructions print their name and used registers r0-r15.

The next instruction to be executed is highlighted in blue. A list of previous instructions is shown.

One can follow the effect of instruction in the register view below.

### Status View

The last view at the top right show the status of the machine (interpreter to be precise), the
instruction count and any stdout

Current controls include stepping and three speeds of running the program.

- Next (green button) will execute exactly one instruction when clicked. Mostly useful when
  debugging the compiler, ie inspecting the generated code.
- Crawl (first blue button) will execute at a moderate speed. One can still follow the
  logic at the register level
- Run (second blue button) runs the program at a higher speed where register instruction just
  whizz by, but one can still follow the source view. Mainly used to verify that the source executes
  as expected and also to get to a specific place in the program (in the absence of breakpoints)
- Wizz (third blue button) makes the program run so fast that it's only useful function is to
  fast forward  in the code (while debugging)

### Register view

The bottom part of the screen is taken up by the 16 register. As we execute an object oriented
language, we show the object contents if it is an object (not an integer) in a register.

The (virtual) machine only uses objects, and specifically a linked list of Message objects to
make calls. The current message is always in register 0 (analgous to a stack pointer).
All other registers are scratch for statement use.

In Soml expressions compile to the register that holds the expressions value and statements may use
all registers and may not rely on anything other than the message in register 0.


The Register view is now greatly improved, especially in it's dynamic features:

- when the contents update the register obviously updates
- when the object that the register holds updates, the new value is shown immediately
- hovering over a variable will **expand that variable** .
- the hovering works recursively, so it is possible to drill down into objects for several levels

The last feature of inspecting objects is show in the screenshot. This makes it possible
to very quickly verify the programs behaviour. As it is a pure object system , all data is in
objects, and all objects can be inspected. 

### Debugging the debugger

Opal is pre 1.0 and is a wip. While current source map support is quite good, one only gets
real lines when switching debug on. Debug make it load every single file seperately, slooows it
down in other words. Set DEBUG environment to switch it on.

I set the sprockets cache to mem-cache and that increase load time from 12s to 1 , so it's quite
usable and restarting a debug is fine.

## Todos

Breakpoints would be nice at some point. Both in step count and variable value.

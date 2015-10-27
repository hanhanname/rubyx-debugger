# Debugger

After some tryouts it ended up being an Opal application. That is ruby as javascript in the browser.

![Debugger](https://raw.githubusercontent.com/salama/salama-debugger/master/static/debugger.png)

- On the left are the classes of the system. Next idea is to have hover info about them.
- Next a source code view (not implemented)
- next a view of the Register Instructions
- last section, current block with current Register Instruction highlighted
- step (next) button for single stepping
- state: starting , running , exited
- bottom row are the registers. If the register holds an object the variables are shown.

## Register View

The Register view is now greatly improved, especially in it's dynamic features:

- when the contents update the register obviously updates
- when the object that the register holds updates, the new value is shown immediately
- hovering over a variable will **expand that variable** .
- the hovering works recursively, so it is possible to drill pdown into objects for sevaral levels


### Debugging the debugger

Opal is pre 1.0 and is a wip. While current source map support is quite good, one only gets
real lines when switching debug on. Debug make it load every single file seperately, slooows it
down in other words. Set DEBUG environement to swithc it on.

I set the sprockets cache to mem-cache and that increase load time from 12s to 1 , so it's quite
usable and restarting a debug is fine.

## Todos

Currently only one source is supported. I change the code.rb file to debug a new problem.

Parsing (parslet) does not work in opal. So s-expressions are used. I use the parser or interpreter
to spew those out. Having a dropdown would be nice, and not even so difficult, but it happens rarely.

Breakpoints would be nice at some point. Both in step count and variable value.

Seeing the source code should be possible, just have to keep it around.

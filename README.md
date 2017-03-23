# Saturn

![Saturn banner](https://i.imgur.com/x8YdcdF.png)

___A general-purpose game engine for the Nintendo® Game Boy Advance™___

## About

__Saturn__ aims at providing a plethora of functionality and toolsets for
building 2D video games on the _Nintendo Game Boy Advance._ It is written in a
mixture of C, C++ and assembly, and will provide an Entity–Component–System
framework for building applications.

Here is a short list of some of the things Saturn hopes to provide:

- Classes and functions that make working with graphics more human
- A frame-based asynchronous task system
- A mainloop complete with a modifiable set of purposed callbacks
- A console interface that switches between input and output upon Select
- More abstractions for key input, sound, and link cable networking
- a dual-mode topdown graphics layout, either on a grid or unrestricted, plus a
  sidescrolling platformer layout
- A collection of PC utilities that help make creating Saturn projects easier
- A fully automated and distributed build system used to build GBA titles as
  well as the engine itself

## Free Software

Saturn is Free Software. That means you can distribute, modify, and use it in
any way you please, without restriction. To be specific, Saturn is released
under the __Apache License 2.0__.

## Building titles with Saturn

We have some notes regarding the usage of this engine to build titles for the
GBA. We ask that you read over them to ensure that you enjoy a seamless
development experience with our work.

- While the majority of the engine is kept in C++ namespaces to prevent naming
  collisions, this is not always possible as some of the code must be written
  in assembly where namespaces do not exist. To alleviate this issue, we have
  reserved all symbols beginning with `_sat__` for internal use by the engine,
  and ask that you do not create functions bearing this prefix for safety’s
  sake. This is in addition to ISO C’s reservation of symbols starting with an
  underscore followed by a capital letter, and ISO C++’s reservation of symbols
  starting with a double underscore.
- Saturn has a Simplified & Segregated Working Memory Model – a minimum of
  space is reserved towards the end of IWRAM for things required by hardware,
  with the remainder left entirely to static code/data and a full decrementing
  user stack. Likewise, the entirety of EWRAM is reserved for the program heap.

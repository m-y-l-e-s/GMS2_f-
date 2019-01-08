# GMS2 f()

**f()** is a single script dependency that gives you virtual private functions within objects in *GameMaker Studio 2*.

*GameMaker Studio 2* has a limitation in which all user scripts ("functions") are in the global space, which can lead to your project becoming very messy.  f() attempts to solve this problem by wrapping [User Events](https://docs2.yoyogames.com/source/_build/2_interface/1_editors/events/index.html)  (See: Other -> User Events) in an intelligent way and implementing a return system from these events.

This allows you to implement custom functions within the scope of a single object, which keeps the Scripts section of your project clean, and constrains one-off functionality to its owner.

## TL:DR

 1. Open the included project
 2. Look at **object0** -> **Create Event**
 3. Run project and press keys `0`, `1`, `2`, `3`, `spacebar`
 4. Monitor the **Output Console**

## How do I use it?

In your object, add the following to your Create Event.

    //f() function declarations
    functions = [
        "my_custom_function", // index 0 -> user event 0
        "my_other_function", // index 1 -> user event 1
    ];

You will declare your function names in **User Event numerical order** in the "*functions*"
array.  That is to say, the function that correlates to **User Event 0** will be first,
the function that correlates to **User Event 1** will be second, etc.

In your code, you may then call your function and its arguments in *one of three ways*:

*METHOD 1*: `f("my_custom_function('a string argument',1,2.532,true)");`

*METHOD 2*: `f("my_custom_function",["a string argument",1,2.532,true]);`

*METHOD 3*: `f("my_custom_function","a string argument",1,2.532,true);`

You will then write your custom function code in the respective **User Event**. The only
caveats are that *your return will have to be placed into a variable*...

**example User Event 0:**

    WRONG:
        return my_variable;
    RIGHT:
        _return = my_variable;

and *your arguments will be prepended with an underscore*...
**example User Event 0:** 

    WRONG:
        var my_variable = argument0 + argument1;
    RIGHT:
        var my_variable = _argument0 + _argument1;

From your **User Event** you can also see how many arguments to expect with
    
    _argument_count
and you can access more than 16 arguments by using the array

    _argument[0 ... max_num]

## How does it work?

Basically just parsing strings and using custom variables local to the object.  Check out the code I have heavily commented it.

## What are the limitations?

**GameMaker Studio 2** only allows *16* **User Events** per object, so you cannot exceed *16 custom functions* using **f()**.

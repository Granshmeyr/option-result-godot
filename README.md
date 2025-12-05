# Option/Result for Godot

This plugin enables absence-of-value semantics in Godot, removing the concept of `null` from a workflow. The API surface is basically copied from Rust's `Option` and `Result` enums, although I have never actually used Rust (shame).

Code generation is used to achieve this. All detected types, including built-in types, will have an Option and Result counter-part generated. For example, `int` will generate `Oint` and `Rint`. A class called `ZombieEnemy` will generate `OZombieEnemy` and `RZombieEnemy`.

Check out the included project for examples of the method chaining workaround, pattern matching, and unit tests for both Option and result land. Make sure to read the bullet points below. Check the bottom of this document for explanations on the method chaining workaround and pattern matching syntax.

**What problem(s) does this solve?**

- You call `my_tween.kill()` and `Cannot access method 'kill' on type 'Nil'` throws even though the object was statically a `Tween`, not `Nil`.
- For some reason you want a `float` variable that you can set as having no value, but `0.0` is actually a valid value.
- You want to force yourself and others to handle a possibly `null` object.
- You want something more advanced than an `if` statement for exhausting all cases of a possible `null` value.

**What important things do I need to know?**

- Because this plugin generates files, hundreds of files will inevitably be added to your project. The file management is contained, but this means an increase in project size (around 27.0 MB at ~800 types, meaning all built-in types).
- This is not a compile-time concept like Rust's Option/Result enum. The Option/Result (aka Opt/Res) classes in this plugin extend `RefCounted`.
- None of the types cross-reference each other by design which prevents the parser from exploding. Due to this, method chaining is replaced with hacky syntactic sugar. This workaround is entirely dynamic and not static at all. Many dynamic asserts are included for safety with useful messages. See below.
- Pattern matching is not done through the `match` keyword. Incorrectly typed lambdas are caught during runtime by Godot as per usual. Dynamic asserts are included for safety with useful messages. See below. The semantics are *kind of* similar to Rust, in that you can match Option(s) to Some and None, but you cannot match against expressions directly in the cases.
- Converting between Option and Result land will return either `OVariant` or `RVariant` due to the conversion being inherently dynamic. This value should be cast one way or another.
- There is no way to explicitly generate only certain types, because I that is not functionality I want to implement. I want this plugin to be a lazy drop-in solution with no configuration.

**Is this actually useful and production ready?**
- I developed this as a drop-in solution to the tween example above. It immediately solved the issue and felt clean doing so.
- This is not production ready and no testing has been performed other than API unit tests and me having fun.
- There are seemingly no runtime performance issues other than the obvious boxing of your optional values.

## Getting Started

1. Copy the plugin folder into your `res://addons/` folder.
2. Enable the plugin.
3. Click `Project → Tools → Option<T> & Result<T> → Create Core Files (res://optres/core/*)`
4. Click `Project → Tools → Option<T> & Result<T> → Generate Personas (res://optres/persona/*)`
5. Expect a crash or a very long script parse. The script parse will only occur once.
6. Restart the editor if you want to make sure the one-time script parse actually occurred.

All generated files are contained within `res://optres/` and can be deleted without affecting the plugin directly.

Generating files for new types you create is as simple as repeating step four. This will not recreate all types, only new types that aren't generated yet.

## Pattern Matching

``` gdscript
var msg: String = Oint\  
    .match(might_be_int, might_be_int_2, might_be_int_3)\  
    .to(&"String").do(  
       func ssn (a: int, b: int) -> String:  
          return ("First value is %s, second is %s, and third is none.") % [a, b],  
       func sns (a: int, c: int) -> String:  
          return ("First value is %s, second is none, and third is %s.") % [a, c],  
       func sss (a: int, b: int, c: int) -> String:  
          return ("First value is %s, second is %s, and third is %s.") % [a, b, c],  
       func __s (c: int) -> String:  
          return "At least third value was Some.",  
       func () -> String:  
          return "Option defaulted.",  
    )
```

Explanation:

1. `Oint.match(...opts: Array[Oint])` is a static, variadic method used to pattern match one or more `Oint` instances.
2. `.to(type: StringName | GDScript)` is an optional method for the developer to assert the type the match must evaluate to.
	- All built-in types are passed as `StringName` i.e. `.to(&"Node3D")`.
	- All *custom* types are passed directly using their keyword to support easier refactoring, i.e. `.to(MyCustomClass)`.
3. `.do(...cases: Array[Callable])` accepts a list of one or more lambdas that represent cases. The *name* of the lamda is how you define the case. This method is variadic.
	- `func ssn (a: int, b: int)` matches a case where the first and second `Oint` are Some, but the third is None.
	- `func sns (a: int, c: int)` does the same except matching the first and third as Some. Note that the argument list is in order of left-to-right based on the original list of `Oint` arguments provided to the match method.
	- `func __s (c: int)` matches that the third `Oint` is Some, but the first two can be either Some *or* None.
	- `func ()` is the default case.

Note: there is no fall-through.

##  Method Chaining (the hacky workaround for it)

``` gdscript
var applied_dmg: Oint = Chain.to(Oint).do(  
    Chain.start(base_dmg),  
    Oint.map_to_c(_apply_strength_bonus),  
    Oint.map_to_c(_apply_armor_reduction),  
    Oint.map_to_c(_apply_critical_hit),  
    Oint.map_to_c(func (dmg: int) -> int:  
       return dmg + _get_weakness_bonus(enemy_weakness),  
    ),  
)
```

Explanation (be prepared for hacky stuff):

1. `Chain.do(..._values: Array[Variant])` is a static, variadic method accepting a list of values.  These values *are not used by the method*. The purpose of this method is to provide a controlled environment where the "chained version" of Opt/Res methods are executed. Chained versions of methods are suffixed with `_c`. My intention here is to provide a logical scope the developer can easliy parse as a human, in which they feel like they are "chaining" methods, even though it is not literal method chaining. Due to this process being inherently dynamic, as much dynamically asserted safety protections as possible were implemented. Chained versions of methods assert that they are receiving the correct type from the previous method. `.do` can assert the type of the final value returned using `.to`. Chained versions of methods assert that the chain must first be initialized with `Chain.start`. See below.
2. `Chain.start(value: Variant)` is a static method which initializes the current chain with a starting value. As mentioned earlier, the next method in the chain will expect a certain type, and this method is included in that check.
3. `.to(type: StringName | GDScript)` is an optional method for the developer to assert the type the chain must evaluate to.
	- All built-in types are passed as `StringName` i.e. `.to(&"Node3D")`.
	- All *custom* types are passed directly using their keyword to support easier refactoring, i.e. `.to(MyCustomClass)`.

## Other Notable Things

- The methods `zip_with_to_c`, `map_to`, `map_to_c`, `map_or_to`, `map_or_to_c`, `map_or_else_to`, `map_or_else_to_c`, `and_then_to`, `and_then_to_c`, `and_to`, `and_to_c` are suffixed with `_to` because of the behavior difference from their original counterpart. Because generated types cannot cross-reference each other, I had to decide to make the input to `map` variant *or* the output, for example. I chose to make the input variant and the output static, as this leads to the safest behavior, as the lambda can statically type the input. Anyways, these methods are static—not instance methods. `Oint.map_to` means you are mapping *to* an `Oint`. Check the project example because it is hard to explain.
- `OUnit`, `RUnit`, `OVariant`, and `RVariant` are included as special types.
	- `OUnit` contains a possible backing value of type `Unit`, which is only accessible as a singleton instance via `Unit.instance`. This is used to create an Option that simulates a bool, if that is for some reason desired.
	- `OVariant` contains a possible backing value of type `Variant`. This is implemented as a workaround for the constraint that Option and Result types in this plugin cannot actually convert to other types in a static way, due to the lack of generic types in GDScript. This is used when converting between Option and Result land.
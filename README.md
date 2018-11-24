# ColossusUmbrella

**Colossus** - IO-agnostic **Thor**-like Command Line Interface framework, that utilises ErlangVM actor system for resources concurrent access.

## The problem

**CLI** interfaces are good examples of UX that are easy enought to implement and more-or-less understandable for humans.

Unfortunately, today **CLI** is a sysnonim to **Terminal interface**, so all frameworks that can be used to create **CLI** are working only with **stdin** and **stdout**,
which does not allow users to choose **IO** layer of communication.

**Colossus** try to eliminate the disadvantage, while remaining equally simple.

## Quiq-start

**Colossus** tryes not to bring semantics complexity to new users, thats why it utilise the same **DSL** as **Thor** - well-known **Ruby** CLI framework.

Basically, you can write your **Thor** code in **Elixir** way, and the **Colossus** will work as expected.

The basic example will looks like this:

```elixir
defmodule MyCLI do
  use Colossus

  @desc "hello NAME", "say hello to NAME"
  def hello(name) do
    Colossus.puts "Hello #{name}"
  end
end
```

In order to abstract the **IO** layer, **Colossus** reuires from user not to call functions from **IO** module directly, either use **Colossus.IO** functions.
In the case, when **MyCLI** will be used as **Terminal CLI**, these functions will be converted into **IO** functions.
In another cases, output can be perford in all kind of different ways (for example via SMS)


## Project structure

In this umbrella project, the small SmarHome showcase is presented. *Emulator* of this house is presented in `smart_home` application.

We are trying to controll this home in different ways: via **Terminal** and **Telegram Bot**. Example projects can be found in `colossus_terminal` and `colossus_tg` respectively.

Entire **Colossus** framework code can be found in `colossus` directory.

You can find detailed instructions and discription inside these projects.
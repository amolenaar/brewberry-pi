# Elixir

### Arjan does Actors, the sequel

---

## How it started

I had a small temperature monitoring app running on Python, utilizing the actor model.

----

I can do better!

----

Let's re-implement it in ~~Erlang~~ **Elixir**!

----

## Elixir

Unique traits:

 * accessible, Ruby-esque syntax
 * command pipelines
 * hygienic macros
 * build environment (*Mix*)
 * scripts
 * \+ everything Erlang has:
   + pattern matching
   + high concurrency
   + isolated processes
   + scalability
 
----
## Modules

The central unit of compilation

    defmodule Foo do
      def func do
        1 + 2
      end
    end

----

## Let the data flow

    "hello_there_world"
    |> String.split("_")
    |> Enum.map(&String.capitalize\1)
    |> Enum.join(" ")

----

## Macros

----

## Mix

----


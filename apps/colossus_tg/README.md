# ColossusTg

![Telegram screen](extra/screen.png?raw=true "Screen")

This example project utilises both **Colossus** and **Agala Telegram** libraries in order to create `Command Line Interface` over messenger.
CLI is controlling small SmarHome, that is presented in `smart_home` project unhder same umbrella application.

Because of perfect OTP's **actor system**, each separate user can concurrently (with some kind of CRDT) controll single SmartHome instance.
With adding an authorisations system, this can be easyly applied to real life purposes.

# Running instructions

1. Firstly, you need to create your own **Telegram Bot** using Telegram's Bot Father. The only 2 arguments that should be retreiven in this process:
  * Link to new bot's private messages.
  * Bot's *token* that will be utilized in this application.

2. This application will try to find the token under
   ```elixir
   Application.get_env(:colossus_tg, :telegram)[:token]
   ```

   So, you can provide it in any comfortable way. The easies way - is to create this file:

   ```elixir
   # config/dev.custom.exs

   use Mix.Config

   config :colossus_tg, :telegram,
     token: "%YOUR_TOKEN%"

   ```

3. Start application using `iex -S mix` or `mix run --no-halt`
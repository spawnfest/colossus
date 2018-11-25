# SmartHome

This is smart home controller example, that is made with colossus.

Basically, the house is really small:

1. Two light bulbs, that can be switched on, off and toggled.
2. A washing machine, with long running laundry.

We will try to controll the house with next commands:

* light on #id
* light off #id
* light toggle #id
* light show #id
* laundry start
* laundry stop
* laundry status
* laundry watch

Commands seems to be self-explainable.

We will use IO-agnostic module, presented in this project to create Terminal CLI **AND** Telegram **CLI**\

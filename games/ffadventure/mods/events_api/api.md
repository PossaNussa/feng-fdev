# Purpose of this API

This API provides functionality for easily creating and handling events - as well as registering functions to them. With options for automated setup.

The idea of this API is based on the idea behind Roblox's Luau's event functionality. The `event.register` functionality providing a function for disconnecting a registered function from said event.



# API Functions

`events_api.create(name, def)`

name: expected string, name of the event - should NOT include "on"

def: optional table, used for automated setup with provided values

 - `def.funcsgroup`
 - optional table, a table to add a reference to the events' registered functions (`event.funcs`) list to
 - `def.handlers`
 - optional table, a table to add a copy of the events' handler function (`event.handler`) to
 - `def.global`
 - optional table, should be your mod's global table. Adds a `register_on_myevent` (equal to `event.register`) function to your mod's global to register functions for the event

Function returns a table of the event's internal structure. See below section for more information.



# Event Internal Structure

`events_api.create` will return a table of information:

 - `event.funcs`
 - an array of registered functions to your event that can be added and removed by `event.register
 - `event.handler(...)`
 - a function for running the event's registered functions (`event.funcs`) with provided parameters
 - `...` being whatever values you decided to pass on
 - equal to calling returned table as `event(...)`
 - `event.register(func)`
 - a function for registering functions to the `event.funcs` table. 
 - returns a function for disconnecting the function from the `event.funcs` table, ceasing all calls of the function by the event.
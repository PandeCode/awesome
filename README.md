# AwesomeWM Config
Based off https://github.com/suconakh/awesome-awesome-rc


## Structure
The main rc.lua file only load the modules it was split into. Each module can have its own submodules, and they are all loaded from init.lua.

| module   | description                              |
| -------- | ---------------------------------------- |
| bindings | mouse and key bindings                   |
| config   | various variables for apps/tags etc...   |
| modules  | third-party libraries (e.g. bling, lain) |
| rules    | client rules                             |
| signals  | all signals are connected here           |
| widgets  | all widgets are defined here             |


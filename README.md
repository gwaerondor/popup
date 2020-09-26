# popup
A Windower 4 addon that displays a configurable popup text.

## Introduction
This addon displays a popup, or flying text, across the screen.
The intended use is to call this from other scripts, when you
want an event to grab your attention even while you aren't looking
at the log.

## How to use
`popup` only has one user command, called `msg`, that can be used
like this:

```
popup msg Reraise wore off
```

The recommended use is to put this in other addons, or other scripts,
when you want an event to grab your attention.

```lua
function buff_change(n, buffIsGained, buff_table)
    local name = string.lower(n)
    if buffIsGained and name == "doom" then
        windower.send_command("popup msg You have been doomed!")
    end
end
```

It's possible to play around with it by entering popup commands
manually, but it isn't very useful.

## Configuration
For now, the configuration is hard-coded. This _will_ change.
All configuration parameters are found in `line.lua`. Changing any parameter
not explained in the table below does nothing (as they are just placeholders)

* `config.y`: the Y distance from the top of the screen. Supports two different formats:
 * Percentage: a string (surrounded by double quotes) like so: `"40%"`
 * Absolute: the amount of pixels, an integer, like so: `300`
* `config.font`: the typeface (a string)
* `config.size`: the font size (an integer)
* `config.red`: the amount of red in the RGB value of the font color (`0`-`255`)
* `config.blue`: the amount of blue in the RGB value of the font color (`0`-`255`)
* `config.green`: the amount of green in the RGB value of the font color (`0`-`255`)
* `config.background.color.red`: the amount of red in the RGB value of the background (`0`-`255`)
* `config.background.color.green`: the amount of green in the RGB value of the background (`0`-`255`)
* `config.background.color.blue`: the amount of blue in the RGB value of the background (`0`-`255`)
* `config.background.alpha`: opacity of the background (`0`-`255`)
* `config.fadeInTime`: the time in seconds it takes for the text to fade in. A decimal number.
 * Set this to `0` to instantly display the popup.
* `config.fadeOutTime`: the time in seconds it takes for the text to fade out. A decimal number.
 * Set this to `0` to instantly remove the popup.
* `config.displayTime`: the time in seconds to display the popup. A decimal number.
 * The timer starts when the fade in starts, not when it is fully displayed.
 * Must be strictly higher than the fade in timer.
   If this timer is shorter, the fade in will not be aborted.
   This *will* lead to unwanted behaviour such as a lingering message box and possibly
   a race between the fade in and fade out mechanics. Don't do this.
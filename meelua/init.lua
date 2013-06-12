--     Author: Yudi Shi <a@sydi.org>
--     Create: <2012-12-02 22:49:42 ryan>
-- Time-stamp: <2012-12-14 14:01:58 ryan>

-- Standard awesome library
local awful = require("awful")
-- Notification library
local naughty = require("naughty")
-- ensure there's a client focus whenever
-- My configures
local o = require("meelua.conf")
require("meelua.theme")
require("meelua.tags")
require("meelua.keys")
require("meelua.wibox")
require("meelua.client")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors
then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

-- -- Handle runtime errors after startup
do
   local in_error = false
   awesome.connect_signal("debug::error",
                          function (err)
                             -- Make sure we don't go into an endless error loop
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = err })
                             in_error = false
                          end)
end
-- }}}

-- This is used later as the default terminal and editor to run.
terminal = o.terminal
editor = o.editor
editor_cmd = terminal .. " -e " .. editor

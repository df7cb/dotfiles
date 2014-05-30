---------------------------------------------------------------------------
-- Adapted from textclock.lua:
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4.15
---------------------------------------------------------------------------

local setmetatable = setmetatable
local io = io
local string = string
local capi = { widget = widget,
               timer = timer }

module("awful.widget.cpufreq")

function cpufreq()
    local f = io.open("/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq", "rb")
    local content = f:read("*all")
    f:close()
    return string.format("%.1f ", content / 1000000)
end

-- @param args Standard arguments for textbox widget.
-- @param timeout How often update the time. Default is 60.
-- @return A textbox widget.
function new(args, timeout)
    local args = args or {}
    local timeout = timeout or 60
    args.type = "textbox"
    local w = capi.widget(args)
    local timer = capi.timer { timeout = timeout }
    w.text = cpufreq()
    timer:add_signal("timeout", function() w.text = cpufreq() end)
    timer:start()
    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

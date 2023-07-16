-- resume_helper.lua
--
-- watch-later saving at the very end of the file be annoying when you want to
-- play that file again.   This script always starts a file back at the
-- beginning if it was previously >90% complete.
local mp = require 'mp'

mp.register_event("file-loaded", function()
    if mp.get_property_native("percent-pos") > 90 then
        mp.commandv("seek", 0.0, "absolute")
    end
end)

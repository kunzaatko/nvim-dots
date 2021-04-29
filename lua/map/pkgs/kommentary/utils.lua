local MUtils = _G.MUtils
local kommentary = require "kommentary"

MUtils.toggle_comment_singles_normal = function()
  kommentary.go("line", {kommentary.toggle_comment_singles})
end

MUtils.toggle_comment_singles_visual = function()
  kommentary.go("visual", {kommentary.toggle_comment_singles})
end

MUtils.toggle_comment_singles_motion = function()
  kommentary.go("init", {kommentary.toggle_comment_singles})
end

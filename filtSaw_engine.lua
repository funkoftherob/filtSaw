local filtSaw = {}
local Formatters = require 'formatters'

-- first, we'll collect all of our commands into norns-friendly ranges
local specs = {
  ["detune"] = controlspec.new(0, 6, "lin", 0, 3, ""),
  ["atk"] = controlspec.new(0, 20, "lin", 0, 6, ""),
  ["sus"] = controlspec.new(0, 10, "lin", 0, 4, ""),  
  ["rel"] = controlspec.new(0, 15, "lin", 0, 6, ""),
  ["curve1"] = controlspec.new(0, 5, "lin", 0, 1, ""),
  ["curve2"] = controlspec.new(-4, 0, "lin", 0, -1, ""),
  ["minCf"] = controlspec.new(0, 60, "lin", 0, 30, ""),
  ["maxCf"] = controlspec.new(0, 10000, "lin", 10, 6000, ""),
  ["minRq"] = controlspec.new(0, 1, "lin", 0, 0.005, ""),
  ["maxRq"] = controlspec.new(0, 1, "lin", 0, 0.04, ""),
  ["minBpfHz"] = controlspec.new(0, 2, "lin", 0, 0.02, ""),
  ["maxBpfHz"] = controlspec.new(0, 2, "lin", 0, 0.25, ""),
  ["lowshelf"] = controlspec.new(0, 440, "lin", 10, 220, ""),
  ["rs"] = controlspec.new(0, 1, "lin", 0, 0.85, ""),
  ["db"] = controlspec.new(0, 10, "lin", 0, 6, ""),
  ["gate"] = controlspec.new(0, 5, "lin", 0, 1, ""),
  ["amp"] = controlspec.new(0, 2, "lin", 0, 1, ""),
  ["spread"] = controlspec.new(0, 2, "lin", 0, 1, ""),  
}

-- this table establishes an order for parameter initialization:
local param_names = {"detune","atk","sus","rel","curve1","curve2","minCf","maxCf","minRq","maxRq","minBpfHz","maxBpfHz","lowshelf","rs","db","gate","amp","spread"}

-- initialize parameters:
function filtSaw.add_params()
  params:add_group("filtSaw",#param_names)

  for i = 1,#param_names do
    local p_name = param_names[i]
    params:add{
      type = "control",
      id = "filtSaw_"..p_name,
      name = p_name,
      controlspec = specs[p_name],
      
      -- every time a parameter changes, we'll send it to the SuperCollider engine:
      action = function(x) engine[p_name](x) end
    }
  end
  
  params:bang()
end

-- a single-purpose triggering command fire a note
function filtSaw.trig(hz)
  if hz ~= nil then
    engine.hz(hz)
  end
end

 -- we return these engine-specific Lua functions back to the host script:
return filtSaw

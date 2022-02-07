engine.name = 'filtSaw'
-- nb. single or double quotes doesn't matter, just don't mix + match pairs!

s = require 'sequins'
-- see https://monome.org/docs/norns/reference/lib/sequins for more info
filtSaw = include('filtSaw/lib/filtSaw_engine')

function init()
  filtSaw.add_params()
  mults = s{1, 2.25, s{0.25, 1.5, 3.5, 2, 3, 0.75} } -- create a sequins of hz multiples
  playing = false
  base_hz = 200
  sequence = clock.run(
    function()
      while true do
        clock.sync(1/3)
        if playing then
          engine.hz(base_hz * mults() * math.random(2))
        end
      end
    end
  )
end

function key(n,z)
  if n == 3 and z == 1 then
    playing = not playing
    mults:reset() -- resets 'mults' index to 1
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,32)
  screen.text(playing and "K3: turn off" or "K3: turn on")
  screen.update()
end

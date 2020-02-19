package.loaded.pick = nil
package.loaded.autoEat = nil
package.loaded.plantLine = nil
package.loaded.walkToward = nil
package.loaded.getInvSpace = nil
package.loaded.getInvStacks = nil
package.loaded.depositItems = nil
package.loaded.harvestLineB = nil

pick = require("pick")
autoEat = require("autoEat")
plantLine = require("plantLine")
walkToward = require("walkToward")
getInvSpace = require("getInvSpace")
getInvStacks = require("getInvStacks")
depositItems = require("depositItems")
harvestLineB = require("harvestLineB")

toolslot = 1
threshold = 6

--starting corner of the crop field
startx = -4
startz = -4

--opposite corner of the crop field
endx = 4
endz = 4

--number of slots in the block the bot uses to deposit. 54 for double chest
tsize = 54

--item config
seeditem = "minecraft:wheat_seeds"
deposititem = "minecraft:wheat"
throwitem = "minecraft:wheat_seeds"

--coordinates for the player to walk to when depositing items
depositx = -4
depositz = -6

--yaw and pitch for the player to look at when depositing items
--note that 0 yaw is south, 90 is west, 180 is north, and 270 is east
deposityaw = 90
depositpitch = 40

--coordinates for the player to walk to when discarding items
throwx = -4
throwz = -7

--yaw and pitch for the player to look at when discarding items
throwyaw = 90
throwpitch = 40

if startz < endz then
  hyaw = 0
  pyaw = 180
else
  hyaw = 180
  pyaw = 0
end

x,y,z = getPlayerBlockPos()

function dropoff(tx,tz)
  walkToward(depositx,depositz)
  look(deposityaw,depositpitch)
  sleep(100)
  use()
  sleep(250)
  depositItems(deposititem,tsize)
  sleep(250)
  walkToward(throwx,throwz)
  look(throwyaw,throwpitch)
  for i=1,getInvStacks(throwitem),1 do
    pick(throwitem,-1,2)
    sleep(250)
    drop(true)
    sleep(250)
  end
end

for rx=x,endx,1 do
  autoEat()
  if getInvSpace() < threshold then
    dropoff(rx,startz)
  end
  walkToward(rx,startz)
  pick(seeditem,-1,2)
  sleep(250)
  setHotbar(toolslot)
  sleep(250)
  harvestLineB(rx,endz,hyaw,90,"forward",150)
  sleep(250)
  plantLine(pyaw,rx,startz,seeditem,2)
  sleep(250)
end

dropoff(depositx,depositz)
log("done!")

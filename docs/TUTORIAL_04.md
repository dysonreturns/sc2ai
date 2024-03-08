# TUTORIAL 4

# Terran

<div class="docstring"><div class="note">
<strong>Glossary</strong><br/>
The Api refers to units, structures and neutral objects collectively as <code>`Api::Unit`</code>.<br/>
We therefore refer to units as "units" and structures as "structures" and collectively as capital Unit.<br/>
A group of Units such as <code>`structures.bases`</code> or <code>`units.workers`</code> normally reside in a <code>`UnitGroup`</code>.
</div></div>

## Idle hands and queued commands

Our workers are producing and supply depots are keeping up, but our economy is not yet perfect.
You might have noticed that, after construction is complete, our workers sit idle. This costs us mining time.

We will have to send them back to work once construction is completed.  
Both Terran and Protoss workers have this side effect, but not Zerg where the workers themselves transform into the structure.

### Set and forget

In terms of Actions, what a human would do is

- select the worker, 
- issue the build depot command,
- hold down Shift and then Right-Click on a mineral patch nearby.  

The final Shift+ instruction adds that action to a queue, making the build and mine actions occur in sequence.

Our flow will mimic these actions programmatically:

```ruby
builder = units.workers.random # 1
builder.build(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT, target: build_location) #2

# Now, find the nearest mineral to our build location
nearest_mineral = neutral.minerals.nearest_to(pos: build_location)
# Shift + Right-click on the mineral = Queue a mine command
builder.smart(target: nearest_mineral, queue_command: true) #3
```

The UnitGroup `neutral.minerals` contains all the mineral patches on the map. We will meet more `neutral` Units later.

That's all there is to it, but there are some **valuable** commands here worth exploring.

### Nearest neighbours

Previously, when finding build locations, we asked the world map about grid tiles and placement states.   
More commonly though, we just want to select the closest units to a position or unit. Much simpler.   

There are two common ways to do this:    

1. Filtering a UnitGroup for the nearest Unit(s) to a target position. As per our example above.    
```ruby
nearest_mineral = neutral.minerals.nearest_to(pos: build_location)
```
2. Or from a Unit, use your own position to filter a target group of units with `Unit#nearest`.
```ruby
nearest_mineral = builder.nearest(units: neutral.minerals)
```

Which you choose depends mostly on what you have with you at the time of calculation.  
If you have a Position in your hand, use `group.nearest_to(pos: some_position)`.  
If you have a Unit in hand, `some_unit.nearest(units: group)` can read better.  

**Finding more**  
Also, in both cases you can pass an optional `amount:`, if you need more than just the nearest 1, which will give you a Unit Group instead of a Unit.  
```ruby
# For example, an enemy nydus is spotted, so lets gather a squad of 5 units to deal with it 
# both are the same:
nydus_exterminators = enemy_nydus.nearest(units: units.army, amount: 5) #=> UnitGroup with max 5 units
nydus_exterminators = units.army.nearest_to(pos: enemy_nydus.pos, amount: 5) #=> UnitGroup with max 5 units
```

### Queue command

Finally, lets review the action we added.

```ruby
builder.smart(target: nearest_mineral, queue_command: true)
```

We've used a new action method on a Unit, called `smart`, which is what the client calls a right-click.  
`Api::AbilityId::SMART` does different actions depending on what happens in-game when you right-click. For army units, it might issue an attack command.
 
Below is a list of **common action methods**, which work for bot a Unit and UnitGroup. You'll recognize `build` and `train`.

- `action` - a raw action. every other method pipes through this.
- `build` / `train`
- `smart`
- `attack`
- `move`
- `stop`
- `hold` / `hold_position`
- `repair`

We mention these, because all of them accept an optional parameter `queue_command:`, which defaults to `false`.  
When setting `queue_command: true`, it will schedule this command after everything before it.   
This is the equivalent of holding down Shift in-game and performing an action.  
When performing two actions on the same unit and the latter action does _not_ have `queue_command: true`, then the last action given will overwrite all before it.

**To conclude**  
By issuing `smart` with `queue_command: true` we have Shift + Right-Clicked on the nearest mineral patch and queued a mine command after the construction is completed. 

You can see it in action if you followed along or by checking out [04_terran_command_queue.rb](https://github.com/dysonreturns/sc2ai/blob/main/docs/examples/04_terran_command_queue.rb)

---

Those lost workers are now happily back in the production line and not a mineral wasted.  
But you can't build machines if you don't have the green. Let's gather some vespene gas.

---

{file:docs/TUTORIAL_05.md Next ➡️}

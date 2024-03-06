# TUTORIAL 2

## Operational Differences
Each race has it's own nuance in basic operations to overcome. For one, unit and building construction mechanics very for each race.  
Let's take each race to a basic army composition, starting with the Terran.

While you might have your heart set on a specific race already, it's important to follow along as we introduce new parts of the API along the way.

# Terran
## Worker
Every race starts with enough minerals (blue resource) to construct a worker (cost: 50 minerals).
For Terran, you train a worker from the building you see on screen, the Command Centre.

```ruby
def on_step
  base = structures.hq.first
  base.build(unit_type_id: Api::UnitTypeId::SCV)
end
```

`structures.hq` returns an array of bases (Command Centre/Orbital Command/Planetary Fortress).    
Aliases include `structures.bases` and `structures.townhalls`, but we prefer `hq` for brevity.

Since we only have one at the start, `structures.hq.first` selects our main base's Command Centre and assign to to a local variable `base`.  
On this base, we call the `build` action.
```ruby
base.build(unit_type_id: Api::UnitTypeId::SCV)
```
`build` has an alias of `train`, if `base.train(unit_type_id: Api::UnitTypeId::SCV)` reads better for you.

Unit actions are all actually some form of an Ability being triggered on a Unit, such as MOVE, STOP, ATTACK.
When calling `build` the library translates the Unit Type Id of SCV into the correct Ability Id for you and calls an action in the background.

These two commands do the same thing:
```ruby
base.build(unit_type_id: Api::UnitTypeId::SCV)
base.action(ability_id: Api::AbilityId::COMMANDCENTERTRAIN_SCV)
```

It's recommend to call `action` when performing abilities and `build`/`train` when creating Units, for your own clarity.


## Your first challenge

Congrats, you're training an SCV, but you're doing that **every frame** and that causes a few problems:

- You might not have the money every frame.  
- You can only queue a limited amount of units before getting queue-full errors.  
- Performing unnecessary actions causes overhead
- Queueing up into the distant future eats up your economy - you could've used that money in the meantime to add on a structure.  
- You might have over-saturated your base with workers already.

We have broadly three **mechanics to limit/schedule** work:

- event triggers; we perform an action when an event occurs, such as a `on_unit_destroyed`
- time delay; only performing actions if current `game_loop` > a future loop value we determined  
- conditionals; perform actions if an observed value matches a condition

Let's implement some conditionals using world values from `common` and review them step by step.
```ruby
def on_step

  # How many units do we have supply or "food" for.
  supply_available = common.food_cap - common.food_used
  
  base = structures.hq.first
  # Ensure we have enough minerals and enough space for this unit
  if common.minerals > 50 && supply_available > 0
    base.build(unit_type_id: Api::UnitTypeId::SCV)
  end

end
```

### Resources: Supply

Supply or "food" is an RTS term used to describe how much space your units are taking.  
You have a limit or "cap", which can be expanded by adding more housing.  
Most units take 1 space, some take 2 or more, depending on size.

We can determine how much space we have available by subtracting supply used from our supply cap.

```ruby
supply_available = common.food_cap - common.food_used
```

### Resources: Minerals and Gas
The other two costs for a unit are **minerals** (blue resource) and **vespene** gas (green resource).  
```ruby
common.minerals #=> minerals (blue) as in ui top-right
common.vespene #=> vespene gas (green) as in ui top-right
```

### Unit cost
Unit costs are easily found online, but online you can also locate them dynamically in-game.   
To review the cost details for a Marauder you can call `Bot#unit_data(Api::UnitTypeId::MARAUDER)` or `Api::Unit#unit_data` on a specific marauder unit.

```ruby

def on_step
  unit_data(Api::UnitTypeId::MARAUDER).to_h
  # Returns:
  {
    unit_id: 51,
    name: "Marauder",
    # [...]
    mineral_cost: 100, # <= common.minerals
    vespene_cost: 25, # <= common.vespene
    food_required: 2.0 # <= common.food_cap - common.food_used
    # [...]
}
end
```




### Affordability and #can_afford?

You see that checking whether a unit is affordable becomes tedious quickly.  

Additionally, there is the tracking problem. What if you have 100 minerals, build a SCV (which costs 50) and then try build a supply depot (which costs 100)?   
Your `common.minerals` will still reflect that you have 100 until the info is refreshed the next frame.

We therefore internally track all you spending of minerals/vespene/supply and you can always rely on the method {Sc2::Player::Units#can_afford? can_afford?}, which accepts `unit_type_id:` and `quantity:`.  
```ruby
puts common.minerals #=> 100
can_afford?(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT) #=> true. depots cost 100.

base.build(unit_type_id: Api::UnitTypeId::SCV) # Costs 50. 100 - 50 = 50 remaining
puts common.minerals #=> still 100
puts @spent_minerals #=> 50

can_afford?(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT) #=> false. we only have 50 left 
can_afford?(unit_type_id: Api::UnitTypeId::SCV) #=> true
can_afford?(unit_type_id: Api::UnitTypeId::SCV, quantity: 2) #=> false. 
```


### Orders and progress 

When you give an `Api::Unit` a valid action, it is assigned added to the unit's `#orders`.  
Below we examine the base's `#orders` array to see how many SCVs are in progress.  
Two orders look like this, where one unit is training (`< 1.0`) and the other hasn't started (`0`)  
```ruby
Api::UnitTypeId::SCV #=> 524

pp structures.hq.first.orders 
# Produces:
[
  { ability_id: 524, progress: 0.672794104 },
  { ability_id: 524, progress: 0 },
]
```

Let's simplify the previous example with `can_afford?` and also limit the build queue using this knowledge of orders.

```ruby
def on_step
  base = structures.hq.first
  
  if can_afford?(unit_type_id: Api::UnitTypeId::SCV)
    
    workers_in_progress = base.orders.size
    if workers_in_progress == 0 
      # Scenario 1: Queue is empty, lets build
      base.build(unit_type_id: Api::UnitTypeId::SCV)
    elsif workers_in_progress == 1 && base.orders.first.progress < 0.9
      # Scenario 2: Queue has one unit, which is almost completed (== 1.0), so let's start another
      base.build(unit_type_id: Api::UnitTypeId::SCV)
    else
      # no operation. don't over-queue.
    end

  end
  
end
```

That's a good foundation for adding workers, but we'll very soon hit our supply cap.
Let's learn construct some buildings next.  

---

{file:docs/TUTORIAL_03.md Next ➡️}

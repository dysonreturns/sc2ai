# TUTORIAL 5

# Terran

<div class="docstring"><div class="note">
<strong>Glossary</strong><br/>
Vespene Gas: Colloquially "Gas". The green resource required for advanced upgrades/structures/units. <br/>
<code>`common.vespene` #=> Integer units of vespene gas in your bank</code><br/><br/>
Geyser: A bare vespene resource on the map. Requires a gas extraction structure to be harvested. <br/>
<code>`neutral.geysers` #=> Unit Group of type geyser</code><br/><br/>
Gas or Gasses: Referring to a gas extraction structures. "Has taken two gasses", "Gas-less expand". <br/>
<code>`structures.gas` #=> Unit Group of type Refinery/Extractor/Assimilator</code><br/>
</div></div>

## Geysers, Gas and Gathering Vespene 

The plan is simple: Build gas structures on-top of geysers and send in harvesters.

### Get the geysers

At this point we are well armed to find geysers nearby our main base, right?
```ruby
geysers_for_main = main_base.nearest(units: neutral.geysers, amount: 2)
```
It would be tempting to run this code universally, but other expansions on the map might not have exactly two geysers.  
We might donate free SCV's to the enemy if we pick the wrong build location. Not ideal.  

### Select Units inside a circle

Since we don't know how many geysers belong to this base, our first instinct could be drawing a circle around the main base, the selecting only the geysers inside of it.

![my eyes are cirlces](images/05_select_in_circle.jpg)

Fiddling with the auto-complete on neutral.geysers, we spot a Unit Group filter {Sc2::UnitGroup#select_in_circle}.

```ruby
geysers_for_main = neutral.geysers.select_in_circle(point: main_base.pos, radius: 8.5)

# Works for minerals
minerals_for_main = neutral.minerals.select_in_circle(point: main_base.pos, radius: 8.5)

# Works for gas structures too
gas_for_main = structures.gas.select_in_circle(point: main_base.pos, radius: 8.5)
```
This check's each geyser's distance to the main base's position and ensures it's less than 8.5 units away.  
Perfectly valid, but does unnecessary calculation.
It needs to loop over every single mineral or geyser on the map and test the distance. 

Let's save that computation time for battle.   

### Geo located resources

More efficient and exact are the purpose-built methods in `geo`.

```ruby
geysers_for_main  = geo.geysers_for_base(main_base)
minerals_for_main = geo.minerals_for_base(main_base)
gas_for_main      = geo.gas_for_base(main_base)
```
These are fast, because we do static map analysis once when the game starts and then use these values when doing lookups.  
Tidy too. The best option.

## Gas structures

Time to plant a gas structure on-top of the geyser. For Terran this structure is called a Refinery.

```ruby
def on_step
  # ...
  
  # Get geysers for main
  geysers_for_main = geo.geysers_for_base(main_base)

  # For each of them...
  geysers_for_main.each do |geyser|
    # ensure we can afford a refinery or break the loop
    break unless can_afford?(unit_type_id: Api::UnitTypeId::REFINERY)
    
    # and build a refinery on-top of the geyser position
    units.workers.random.build(unit_type_id: Api::UnitTypeId::REFINERY, target: geyser)
  end

end
```
With that, our gasses build organically as soon as we can afford them.  

<div class="docstring"><div class="note">
Note: Depending on your planned build order, you might want to delay the gas by waiting for `common.food_used` to be greater than a specific amount or only build <em>one</em> refinery at first.
</div></div>


## Harvesting

Right now, as refineries finish, only the constructing worker will harvest gas automatically.   
On-top of the refinery we can see that the ideal number of harvesters are 3.

It's also worth considering that our gas harvesters could drop for various reasons, i.e. workers destroyed by the enemy.  
Therefore, it's worth keeping a continuous eye on our refineries to ensure that they are saturated.

Every check we do, however, comes at a **performance cost**. Let's **limit how frequently we check** in on our refineries.  
How about we check every 2 in-game seconds? At 16fps that's every 32 frames.  

```ruby

# Gas saturation checks @ every 2s
if game_loop % 32 == 0
  
  # Get all gas structures for main base
  gasses = geo.gas_for_base(main_base)

  # Loop over completed gasses (don't worry about those under construction)
  gasses.select(&:is_completed?).each do |gas|
    
    # Move on to the next gas if we are not missing harvesters
    missing_harvesters = gas.missing_harvesters
    next if missing_harvesters.zero?

    # From the 5 nearest workers, randomly select the amount needed and send them to gas
    gas.nearest(units: units.workers, amount: 5)
      .random(missing_harvesters)
      .each { |worker| worker.smart(target: gas) }
  end
end
```

If we have harvesters missing (`missing_harvesters`), select randomly from workers nearby and send them in with the SMART action.  
Works great!

Most of the code is familiar by now, but let's touch on two things quick:

**Unit progress**  

Just like we checked orders progress, each Unit has a property called `build_progress`, which stores it's constructed state as a float between 0.0 and 1.0.  
The helper method `unit.is_completed?` returns true if a Unit is completed (`build_progress == 1.0`).

```ruby
gasses.select(&:is_completed?).each do |gas|
  #...
end

# Is the same as:
gasses.select{ |gas| gas.build_progress == 1.0 }.each do |gas|
  #...
end
```

**Select and reject using Unit booleans**

Above we used a boolean method from Unit in a `select` using "Symbol to Proc" shorthand.

Like `is_completed?`, there are many more like:

- `is_flying?`
- `is_ground?`
- `is_burrowed?`
- `is_active?`
- `is_biological?`
- `is_mechanical?`
- `is_summoned?`
- `is_powered?`
- `is_armored?`, etc.  

It's worth checking out {Api::Unit}, because as you've seen with progress checks, it can be super useful short-hand:

```ruby
# Land all flying buildings exactly where they are 
structures.select(:is_flying?).each do |unit|
  unit.action(ability_id: Api::AbilityId::LAND, target: unit.pos)
end

# Find all engineering bays which are not active (idle)
structures.select_type(Api::UnitTypeId::ENGINEERINGBAY).reject(:is_active?).each do |unit|
  # queue an upgrade command...
end
```

Don't worry, we will practice this more later.  

---

Alright, we're cooking with gas. Download and run the full example and see it in action:
[05_terran_gas.rb](https://github.com/dysonreturns/sc2ai/blob/main/docs/examples/05_terran_gas.rb)

Selecting units in zone, getting resources for a base, reading unit attributes, advanced group filters... we're getting pretty hardcore.  
How about a simpler task, like - I don't know - TAKING OVER THE ENTIRE MAP!

How about some macroni?

---

{file:docs/TUTORIAL_06.md Next ➡️}

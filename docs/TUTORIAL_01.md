# TUTORIAL 1

## Regarding Examples
The examples we use can be found in their final form in the repo in the [examples folder](https://github.com/dysonreturns/sc2ai/tree/main/docs/examples).  
When an example is given, we don't include the Match setup and opponent config, unless it's relevant.  
Boilerplate such as `require "sc2ai"` and `Sc2.config { |c| c.version =  "4.10" }` is also omitted for brevity.


## Taking your first steps

Participants use `RequestStep(step_count)` to progress the game in step mode.
The library automatically does this for your Bot after each `on_step`.

The game intelligently syncs control back to players, even with varying `step_count`'s.  
At `@step_count = 1` you take only one step per game loop and can parse every frame.   
`game_loop` will tell you how deep you've incremented.

```ruby
# 01_stepping.rb

class ExampleBot < Sc2::Player::Bot
  
  def configure
    @step_count = 1
  end

  def on_step
    pp "This is game_loop: #{game_loop}"
    #=> "This is game_loop: 0"
    #=> "This is game_loop: 1"
    #=> "This is game_loop: 2"
    #=> ...
  end
  
end
```

## Skipping is the best form of travel

Having a step count of 1 makes you theoretically more responsive, but it has it's downsides.  
For instance, giving an action may not reflect immediately on the next step, but show up on the step after.  

Therefore, the default `step_count` is 2. If you possess the chutzpah to stay fast and handle exceptions, you can try botting at a `step_count` of 1.  
You can define your step count value by overriding the `configure` method in your bot class.

```ruby
# 01_stepping.rb

class ExampleBot < Sc2::Player::Bot

  def configure
    @step_count = 2
  end

  def on_step
    pp "This is game_loop: #{game_loop}"
    #=> "This is game_loop: 0"
    #=> "This is game_loop: 2"
    #=> "This is game_loop: 4"
    #=> ...
  end

end
```

It's important to note that **you don't lose any information by skipping** steps.  
Any updates or events which occurred since your last observation will still be provided in the aggregate.  

## A Faster pace
The ladder expect bots to run at near human ("Faster") speed.  
At this pace, you should perform about **22.4 per steps per real-world second** or to put it differently, take **less than 44.64ms per step**.  
If you take too long on the ladder, your bot might get **penalized and removed**.

You would have noticed that running a bot prints out a float to stdout as it runs.
These are the milliseconds it took to complete your full step cycle.  

At step_count 1, this should remain sub 44.64ms.  
At the default step_count of 2, **you should be QUICKER than 89.29ms.**

Bots typically take 2, 4 or even 8 steps at a time without much competitive disadvantage.

---

The amount of time you have grows less with added complexity and the with the scale of objects on the map.  
The pressure will make you stronger. It's time to get academic about fast Ruby.

Performance was important enough a point to be mentioned first.

Enough for now, {file:docs/TUTORIAL_02.md let's build some stuff}! :)

---

{file:docs/TUTORIAL_02.md Next ➡️}

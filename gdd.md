# Game Design Document (GDD)
### Team's Project Template

## 1. Game Concept

**Working Title: Only Way Out is Up**  

**Genre: Rougelike, Strategy RPG, Action Adventure**  

**Platform(s): Windows/MacOS**  

**Elevator Pitch:** 
In this game you play as a villager who went exploring and ended up trapped in a dungeon with no way out even through death. You must fight, get stronger, and find your way out to get back to your dog at home.  

**Target Audience: For Everyone, people who enjoy the rougue like genre as well as rpg's** 


---

## 2. Core Loop
 
- **Go into dungeon** - pick your class and begin your journey out the dungeon
- **Fight Enemies** - Fight enemies along the way who get stronger closer to the top 
- **Collect Loot** - Find better items and materials to buy, sell, or equip
- **Upgrade Character** - Use the items and materials you found to make your character stronger as you go 
- **Die/Getout** - You either die and get sent back to the bottom or find your way out 


---

## 3. Game Mechanics

- **Player Actions: Move left, right, turn around, attack, block, heal**

- **Interactions: Open chest?, buying weapons, buying moves, buying upgrades, move on to next room, selling weapons and moves**

- **Rules: You can only do one action per turn, once your health runs out game over**

- **Progression: Your character starts with 2 moves and you slowly improve your character and get more moves as you progress through the dungeon. Along the way you can buy new items or materials from the Embassy and find new moves, health, items/powerups. Enemies become stronger as you progress**

- **Rewards: Progression based on how far into the dungeon you've gotten**

- **Feedback: When the player gets hit the screen shakes, different music and background for fights, pop up notifications for unlocks, and a room completion animation**

---

## 4. Story & Narrative *(when applicable)*

**Premise:**
- The main character a young villager ventures into a forest and finds a cave with a shiny gem deep inside. They go further in and touch it then suddenly appear in a room deep deep underground. They wake up to find the gem imbedded in their hand, and as they try to get out they find themselves surrounded by monsters and dies and returns back to the room they first woke up in. Determined to get back to their dog they decide to get stronger with the power of the gem and fight their way out no matter how long it takes. 


**Main Characters: The player**

**Conflict/Goal: trapped at the bottom of a dungeon and the only way out is up**

---

## 5. Level & World Design

**Setting/Theme: Fantasy medival**

**Level Structure: hub-based**

**Tutorial/Onboarding: Players learn the game as they die, try and get out the dungeon, and reapeat**

**Exploration/Challenges/Puzzles: each level is different and might have different enemies, bosses, npcs, and traps**

---

## 6. Visual & Audio Style

**Art Style Reference: pixel art**

**Color Palette: dark shades, underground earthy tones to fit the trappend underground theme**

**Music/Audio Resources: Older pixel game type**

---

## 7. User Interface (UI/UX)

**HUD (Heads-Up Display) Elements: health similar to minecraft, currency, attacks available**

**Menus:Pause menue will include a resume button as well as a stats button that would take a player to see their current run stats, and a help button that would show the controls and basic mechanics of the game**

**Accessibility Features (if any):**

---

## 8. Technical Requirements

**Engine: Godot**

**Programming Language(s): GDScript**

**Tools for Assets (art, sound, etc.):**

**Deployment Platform: PC**

---

## 9. Development Plan 

## **Week 4 – Foundation & Setup**

- Finish the Game Design Document (GDD)
- Set up and organize the main Godot project
- Start coding and working on the actual game
- Create a basic dungeon room using placeholder assets
- Add the player character and begin implementing movement
- Decide what type of backgrounds and visual style we want
- Find sprites/assets that match the pixel-art style
- Find possible music and sound effects
- Brainstorm enemy types and their attacks
- Begin planning the health system and HUD

**Goal:** Have a basic dungeon environment where the player character can appear and move.

## **Week 5 – Player, Combat & Enemies**

- Have the basic dungeon background implemented
- Finish basic player movement
- Add the first enemy type
- Implement basic player attacks
- Implement enemy movement and attacks
- Add a player health system
- Start creating the HUD with hearts for health
- Implement player death
- Begin implementing the system that sends the player back to the bottom after dying
- Begin working on the one-action-per-turn system

**Goal:** Have a basic combat encounter where the player and an enemy can attack each other and the player can die.

## **Week 6 – Core Mechanics & Progression**

- Finish the death/reset system
- Make sure the player can move, attack, block, and heal
- Finish the basic turn/action system
- Work out the math for player and enemy stats:
  - Health
  - Damage
  - Defense/blocking
  - Healing
  - Different attacks
- Create multiple dungeon rooms
- Allow the player to progress upward between rooms
- Add the dungeon progress bar to the HUD
- Add basic loot or rewards after defeating enemies
- Make enemies stronger as the player progresses

**Goal:** Have the main gameplay loop working:

**Fight → Win → Get Reward → Move Up → Fight Stronger Enemy → Die → Restart**

## **Week 7 – Additional Content & Visuals**

- Make sure all core mechanics work correctly before adding more features
- Fix problems with movement, combat, death, and room progression
- Add additional enemy types
- Add more player attacks/moves
- Add different dungeon room layouts
- Add weapons or upgrades
- Add chests or other ways of receiving loot
- Add a boss encounter if time allows
- Begin replacing placeholder sprites with final character and enemy sprites
- Improve the dungeon background and visual details
- Add the Embassy/shop system if time allows

**Goal:** Turn the basic gameplay loop into a more complete prototype with different enemies, rooms, attacks, and upgrades.

## **Week 8 – Polish & Testing**

- Playtest the entire prototype
- Fix major bugs
- Balance player and enemy health, damage, and attacks
- Finish character and enemy visuals
- Finish the HUD and progress bar
- Add music and sound effects
- Add screen shake when the player gets hit
- Add attack and hit effects
- Add room completion effects
- Add unlock notifications if time allows
- Improve menus and other UI elements
- Make sure death and restarting work consistently
- Make sure the player can progress from the bottom to the end of the prototype

**Goal:** Have a finished and playable version of the prototype.

## **Week 9 – Final Prototype**

- Have a complete working prototype of *Only Way Out is Up*
- Complete final playtesting
- Fix any remaining major bugs
- Make final balancing changes
- Make sure the game can be played from beginning to end
- Export the final build
- Prepare the game for the final presentation/demo

**Final Goal:** Have a playable prototype that demonstrates the game's combat, enemies, upgrades, dungeon progression, death/reset system, and core roguelike loop.

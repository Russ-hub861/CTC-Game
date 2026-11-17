# Game Design Document (GDD)
### Team CTC
### The Only Way Out is Up

## 1. Game Concept

**Working Title: Only Way Out is Up**  

**Genre: Rougelike, Strategy RPG, Action Adventure**  

**Platform(s): Windows/MacOS**  

**Elevator Pitch:** 
In this game you play as a villager who went exploring with their dog and ended up trapped in a dungeon with no way out even through death. To get back to your dog you must fight, get stronger, and find your way out to the surface.   

**Target Audience: For Everyone, people who enjoy the rougue like genre as well as rpg's** 


---

## 2. Core Loop
 
- **Go into dungeon** - pick your class and begin your journey out the dungeon
- **Fight Enemies** - Fight enemies along the way who get stronger closer to the top 
- **Upgrade Character** - Use experience you gain from killing enemies to learn new skills
- **Die/Getout** - You either die and get sent back to the bottom or find your way out back to your dog  


---

## 3. Game Mechanics

- **Player Actions:** Move left, right, turn around, attack, block, heal

- **Interactions:** Using experience points to unlock new skills 

- **Rules:** You can only do one action per turn, once your health runs out game over

- **Progression:** Your character starts with 2 moves and you slowly improve your character and get more moves as you progress through the dungeon. Enemies become stronger as you progress

- **Rewards:** Progression based on how far into the dungeon you've gotten

- **Feedback:** When the player and enemies gets hit theres sound and animation, when blocking players and enemies have. a blue outline and when attacking a red one,  different background for fights, pop up notifications and sound effects for unlocks, and a room completion button

---

## 4. Story & Narrative *(when applicable)*

**Premise:**
- The main character a young villager who ventures into a forest with his dog and falls into a mysterious cave. They wake up lost looking for their dog and start to worry more and more as they are deep underground in a unfamiliar area. As the villager explores they see enemies everywhere besides the place they woke up at and one wrong step leads them to die for the first time...


**Main Characters: The player**

**Conflict/Goal: trapped at the bottom of a dungeon away from their dog and the only way out is up**

---

## 5. Level & World Design

**Setting/Theme:** Fantasy medival

**Level Structure:** hub-based

**Tutorial/Onboarding:** There is a tutorial level at the start of the game that introduces the player to the basic controls but the player must learn the strategy to making their way to the top from trial and error 

**Exploration/Challenges/Puzzles:** Each level is different and has a different amount of enemies during each wave

---

## 6. Visual & Audio Style

**Art Style Reference:** Pixel art

**Color Palette:** Dark shades, underground earthy tones to fit the trappend underground theme

**Music/Audio Resources:** Older pixel game type

---

## 7. User Interface (UI/UX)

**HUD (Heads-Up Display) Elements:** health similar to Minecraft, experience points, and the attacks available

**Menus:** A pause menu that will include a quit button as well as a resume button that would take a player to see their current run, controls input menu for if you want to change the controls, and as well as a skills menu for unlocking different skills during the play though

**Accessibility Features (if any):** A control input menu, and sound sliders 

---

## 8. Technical Requirements

**Engine:** Godot

**Programming Language(s):** GDScript

**Tools for Assets (art, sound, etc.):** itch.io and Pixabay

**Deployment Platform:** Web, MacOs, and Windows 

---

**Final Goal:** Have a playable prototype that demonstrates the game's combat, enemies, upgrades, dungeon progression, death/reset system, and core roguelike loop.

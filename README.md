# 3D Character Controller (Godot)

This project contains a ready-to-use 3D character controller built in Godot.  
It is designed as a starting point for your own game projects.

---

## Features

- Third-person 3D movement
- Camera-relative controls
- Five rady to go characters to use
- Keyboard/Mouse controls and Controller
- State Machine
    - Movement
        - Idle
        - Run
        - Jump
    - Spawn
    - Damaged
    - Dead
- Basic animations for each state and substate
    - Additional animations included for you to implement

---

## Getting Started

1. Download or clone this repository
2. Open the project in Godot
3. Run the main scene

You should be able to control the character immediately.
You can build your game right out of this project, or implement a new one

---

## Controls

This project supports both **keyboard** and **controller** input.


| Action | Keys | Control |
|------|-----|---------|
| Move | W A S D | Left Stick |
| Look | Mouse | Right Stick |
| Jump | Space | Bottom Button (A / Cross) |
| Interact | E | Top Button (Y / Triangle) |

---

## Using the Player in Your Own Project

To use this controller in your own game:

1. For safety, copy the entire contents of this project into your new project folder
2. Add the `Player.tscn` to your scene.
3. Make sure your input actions match (see below)

### Changing the Player Character

You can change the character that is being used by doing the following:
1. Add the `Player.tscn` to your level scene
2. Right click on the root node of the Player, and select "Make Local"
3. Delete the default character model node "Ranger"
4. Add a new character model from the `KayKit_Adventurers_2.0_FREE/Characters` folder (a .glb file)
5. On the Player node, select the new character model on the Model variable 
6. It should work!

---

## Input Setup

This controller uses custom input actions, the easiest way to implement them in your project is to copy them from this project's `project.godot` file.

## Credits

Full credit to Kay Lousberg at KayKit for the character models and animations. Visit https://kaylousberg.itch.io/ for more of their awesome work making gorgeous themed assets. The assets used are all CC0. Any other of their KayKit Medium Rig characters should work with this controller perfectly

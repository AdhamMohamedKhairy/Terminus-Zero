KESTREL — FREE SHIP  (Sci-Fi Starships, Pack 1: Solar Dominion Fighters)
============================================================

One complete starship to try in your project, with every animation and colour of the paid pack.

  Kestrel    Light fighter    colours: default, blue, red, green
     top   cell 64x80: idle (4), left_1 (4), left_2 (4), right_1 (4), right_2 (4), boost (4), hit (4), destroy (10), warp (8)
     side  cell 96x48: idle (4), boost (4), hit (4), destroy (10), warp (8)

The full Pack 1: Solar Dominion Fighters has 4 ships (Kestrel, Starlance, Twinfang, Wraith), each with the same
views, animations, colours, Godot 4 SpriteFrames and Aseprite sources.

FILES
  starships/<ship>/<ship>_<view>.png           sprite sheet, rows = animations, columns = frames
  starships/<ship>/<ship>_<view>_<colour>.png  the same sheet in another colour scheme
  starships/<ship>/<ship>.json                 per view: cell size, rows, frame count, frame time (ms), loop, muzzles,
                                               "hitbox" [x, y, w, h] = the hull, "core" [x, y, w, h] = a 4x4 box
                                               for bullet-hell games (both in cell pixels)
  starships/<ship>/<ship>_<view>_frames.tres   Godot 4 SpriteFrames, one animation per row
  starships/<ship>/weapon/                     the ship's own weapon (see WEAPONS)
  frames/<ship>/<view>/<animation>/NN.png      every frame on its own
  aseprite/<ship>/<ship>_<view>.aseprite       source, one tag per animation, frame timings kept
  promo/                                       preview GIFs

VIEWS
  top   seen from above, nose up: vertical shooters. Flip it vertically for ships that fly down the screen.
  side  seen from the side, nose right: horizontal shooters.

ANIMATIONS
  idle      engines on, flames flicker (loop)
  left_1/2, right_1/2   banking while moving sideways, two levels (loop)
  boost     longer, brighter flames (loop)
  hit       white flash and a 1 px shake (once)
  destroy   the ship breaks apart in a fireball, then smoke (once)
  warp      a streak of light squeezes into the ship (once): use it when the ship enters the screen

WEAPONS
  Every ship has its own weapon, top and side view, 48x48 cells, art centred:
    shot, charged (loops)   charge (8 frames: loop the last 2 while the button is held)
    muzzle, muzzle_big      flashes at the gun      impact, impact_big   hit bursts
  <ship>_weapon.json: rows, frames, frame time, loop; for projectiles "spawn" = offset from the muzzle to the
  sprite centre (the tail sits on the muzzle) and a suggested "speed" in px per frame.
  MUZZLES: <ship>.json has, for every animation frame, the gun positions in cell pixels ("shot": one per gun,
  "charge": where the charge builds). Spawn shots there and they leave the barrels, banks included.

GODOT 4
  Copy the "starships" folder to the root of your project (res://starships/...). Add an AnimatedSprite2D,
  set Sprite Frames to starships/<ship>/<ship>_top_frames.tres and play "idle". Pixel art stays sharp with
  Project Settings > Rendering > Textures > Default Texture Filter = Nearest.

OTHER ENGINES
  Unity, GameMaker, Defold, Construct, Phaser...: slice the sheets with the cell size in the JSON
  (one row per animation, frames left to right) or import the single frames.

License: see LICENSE.txt (commercial use allowed).   Made by MEKAI GAMES.

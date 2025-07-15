use context essentials2021
# load the project support code
#include shared-gdrive("dcic-2021", "1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

include shared-gdrive("project2-spring2022-support", "1ORus_ohkL48PWp-ffwKDasmrm0j9cFlI")

include image
include tables
include reactors
import lists as L

ssid = "1SMod64bUKm4csuRgfnyHp4DJ9aP6LuVQO-ib4kDnaZI"
maze-data = load-maze(ssid)
item-data = load-items(ssid)

data Location:
  | location(x :: Number, y :: Number)
end

data OverLay:
  | overlayy(portalposition :: List<Location>, image :: Image)
end

data Player:
  | player(mildalocation :: Location, wormholecount :: Number)
end

test-player = player(
  location(
      10,
      10),
  5)

data GameState:
  | gamestate(player :: Player, overlay :: List<Location>, background :: List<List<String>>)
end

fun get-coord(rows :: List<Row>) -> List<Location>:
  doc:```Goes through a list of rows and turns the x and y aspects of those rows into locations```
  cases (List<Row>) rows:
    | empty => [list: ]
    | link(f, r) =>
      link(location(f["x"], f["y"]), get-coord(r))
  end
end
rowlist = item-data.all-rows()
get-coord(rowlist)

test-list = [list: [list: "apple", "banana", "watermelon"], [list: "peach", "orange", "kiwi"]]


fun get-item(l :: List<List<String>>, x :: Number, y :: Number) -> String:
  doc: ```Goes thorugh a list of lists and finds the value at the given location, note that the nth item in the yth list is found```
  l.get(y / -30).get(x / -30)
where:
  get-item(test-list, -30, -30) is "orange"
  get-item(test-list, 0, 0) is "apple"
  get-item(maze-data, 0, 0) is "x"
  get-item(maze-data, 0, -30) is "x"
  get-item(maze-data, -30, -30) is "o"
  get-item(maze-data, -120, -210) is "o"
end

test-game-state = gamestate(
    test-player,
  get-coord(item-data.all-rows()), maze-data)

fun game-complete(state :: GameState) -> Boolean:
  doc: ```Determines if the player has reached the computer, used to complete the game in the reactor```
  if state.player.mildalocation == location(-30 * 34, -30 * 14):
    true
  else:
    false
  end
where:
  game-complete(gamestate(
      player(
        location(
          -30 * 34,
          -30 * 14),
        2),
      get-coord(item-data.all-rows()),
      maze-data)) is true
   game-complete(gamestate(
      player(
        location(
          -30 * 33,
          -30 * 14),
        2),
      get-coord(item-data.all-rows()),
      maze-data)) is false
end

fun draw-row(row-list :: List<String>):
  doc: ```Iterates over a list of string and determines whether a wall or floor should be placed, then draws the row```
  cases (List) row-list:
    | empty => empty
    | link(fst, rst) =>
      if rst == empty:
        if fst == "x":
          load-texture("wall.png")
        else if fst == "o":
          load-texture("tile.png")
        end
      else:
        if fst == "x":
          beside(load-texture("wall.png"), draw-row(rst)) 
        else if fst == "o":
          beside(load-texture("tile.png"), draw-row(rst))
        end
      end
  end
end

fun background(lst :: List<List>)-> Image:
  doc: ```Used the draw-row function previously defined to iterate over a list of lists and stack the drawing of the rows over one another to create the maze image```
  cases (List) lst:
    | empty => empty
    | link(fst, rst) =>
      if rst == empty:
        draw-row(fst)
      else:
        above(draw-row(fst),background(rst))
      end
  end     
end

fun place-portals(lst :: List<Location>) -> Image:
  doc:```spaces out the portals to where they will be based on a list of locations, then draws them```
  cases (List<Location>) lst:
    | empty => rectangle(0,0,"solid","white")
    | link(f, r) => 
      overlay-xy(load-texture("wormhole.png"), -30 * f.x, -30 * f.y, place-portals(r))
  end
end

fun draw-game(state :: GameState) -> Image:
  doc:```Takes in a gamestate and creates the image```
  base-maze = background(maze-data)
  portal-maze = overlay-align("left", "top", place-portals(state.overlay), base-maze)
  computer-maze = overlay-xy(load-texture("computer.png"), -30 * 34, -30 * 14, portal-maze)
  overlay-xy(load-texture("milda-down.png"), state.player.mildalocation.x, 
  state.player.mildalocation.y, computer-maze)
end

fun get-portal(state :: GameState) -> GameState:
  doc: ```Determines whether a player has landed on a portal and then gets rid of the portal that was picked up and adds a portal to the players inverntory```
  if L.member(state.overlay, location(state.player.mildalocation.x / -30, state.player.mildalocation.y / -30)):
    new-overlay = L.remove(state.overlay, location(state.player.mildalocation.x / -30, state.player.mildalocation.y / -30))
    new-portals = state.player.wormholecount + 1
    gamestate(
    player(
      state.player.mildalocation,
      new-portals),
      new-overlay,
      state.background)
  else:
    state
  end
where:
  get-portal(gamestate(
      player(
        location(
          8 * -30,
          8 * -30),
        4),
        [list: location(8,8), location(2, 8), location(26, 13), location(18, 17), location(11, 11), location(22, 17)],
        maze-data)) is
      gamestate(
      player(
        location(
        8 * -30,
        8 * -30),
      5),
        [list: location(2, 8), location(26, 13), location(18, 17), location(11, 11), location(22, 17)],
    maze-data)
  ########
  get-portal(gamestate(
      player(
        location(
          8 * -30,
          8 * -30),
        4),
      [list: location(8,9), location(2, 8), location(26, 13), location(18, 17), location(11, 11), location(22, 17)],
      maze-data)) is
  gamestate(
      player(
        location(
        8 * -30,
        8 * -30),
      4),
    [list: location(8,9), location(2, 8), location(26, 13), location(18, 17), location(11, 11), location(22, 17)],
    maze-data)
end

fun use-portal(state :: GameState, x, y, button-type) -> GameState:
  doc: ```Uses a portal when the player clicks, determines whether the clicked location is valid and if so moves that player to the location and removes a portal from their inventory```
  
  new-x = (-1 * x) + (num-modulo(x, 30))
  new-y = (-1 * y) + (num-modulo(y, 30))
  
  fun distance(x2 :: Number, y2 :: Number) -> Number:
    doc: ```Determines the distance between playes current location and a location on the maze```
    num-sqrt(
      ((x2 - state.player.mildalocation.x) * (x2 - state.player.mildalocation.x)) + 
      ((y2 - state.player.mildalocation.y) * (y2 - state.player.mildalocation.y)))
  end
  
  if (button-type == "button-down") and (distance(new-x, new-y) <= 150) and (get-item(maze-data, new-x, new-y) == "o") and (state.player.wormholecount >= 1):
    gamestate(
    player(
        location(
          new-x, 
          new-y), 
        state.player.wormholecount - 1), 
        state.overlay, state.background)
  else:
    state
  end
    
where: 
  use-portal(test-game-state, 150, 100, "button-down") is 
  gamestate(
    player(
      location(10,10),5),
    get-coord(item-data.all-rows()), maze-data)
  
  use-portal(test-game-state, 40, 40, "button-down") is 
  gamestate(
    player(
      location(-30,-30),4),
    get-coord(item-data.all-rows()), maze-data)
  
end

fun move-with-button(state :: GameState, key :: String) -> GameState:
  doc: ```Moves a player to the desired location when a move button is clicked. Deteremines whether the desired location is valid and if so allows the player to move to that location```
  if (key == "w") or (key == "up"):
      new-x = state.player.mildalocation.x
    new-y = state.player.mildalocation.y + 30
    if get-item(maze-data, new-x, new-y) == "o":
      get-portal(
      gamestate(player(location(new-x, new-y), state.player.wormholecount),state.overlay, state.background)
        )
      else:
        state
      end
  else if (key == "a") or (key == "left"):
    new-x = state.player.mildalocation.x + 30
      new-y = state.player.mildalocation.y
    if get-item(maze-data, new-x, new-y) == "o":
      get-portal(
      gamestate(player(location(new-x, new-y), state.player.wormholecount),state.overlay, state.background)
        )
      else:
        state
      end
  else if (key == "s") or (key == "down"):
      new-x = state.player.mildalocation.x
    new-y = state.player.mildalocation.y - 30
    if get-item(maze-data, new-x, new-y) == "o":
      get-portal(
      gamestate(player(location(new-x, new-y), state.player.wormholecount),state.overlay, state.background)
        )
      else:
        state
      end
  else if (key == "d") or (key == "right"):
    new-x = state.player.mildalocation.x - 30
      new-y = state.player.mildalocation.y
    if get-item(maze-data, new-x, new-y) == "o":
      get-portal(
      gamestate(player(location(new-x, new-y), state.player.wormholecount),state.overlay, state.background)
        )
      else:
        state
      end
    else:
      state
    end
end

init-state = gamestate(
  player(
    location(
      -30,
      -30),
    1),
  get-coord(item-data.all-rows()), maze-data)


maze-game =
  reactor:
    init              : init-state,
    to-draw           : draw-game,
    on-mouse          : use-portal,
    on-key            : move-with-button,
    stop-when         : game-complete, # [up to you]
    close-when-stop   : true, # [up to you]
    title             : "MildaFlix"
  end

interact(maze-game)

#|
   Reflection:
   1. Having the support code representing the game layout as a list of lists rather than as a table offered many advantages but also came with it's disadvantages. On advantage waas that it was easier to iterate over than a table would be. Seeing as the cases function takes in a list, we would have had to convert the table into a list regardless in order to iterate over the list to make the background of the game. Having it already provided in a list made the process much easier to excecute. A disadvantage of having it as a list is that our item data was presented in table form, making it harder to create code that is cohesive for both the list annotation and the table anotation of data.
   2. As previously stated, the list format of the maze background is great for iterating over the list using the cases function. On the otherhand, it is not as great for representing exact locations of things, it was not a problem in our case seeing as each value in the lists represented a set suface area but if it were to represent different areas of the background the list format would be harder to work with. The table format is great for getting exact locations, as we see in the case of the portal locations. It is not as good at iterating over, seeing as it requires function to turn the table into list format that can be iterated over. Lastly, the images were very straight forward. They are great for layering over eachother and manipulating to create a cohesive and interactive game, but seeing as we were gien a certain set of images they are not as great if you want to easily edit the pictures that are on screen!
   3. A key insight we learned was that coding large projects takes many concepts into play, whether that be using the drawing code that we learned a the beginning fo the semester or iterating over list that we have newly learned, coding bigger projects takes both small and large concepts. It is interesting to think about how much more could be dont through pyret if we were more fluent in the language. A second key insight we learned was that you have to be very picky about how you create datatypes, we will eleaborate further in question 4 but we often ran into issues where our datatypes did not conntain as much information as we needed and we often had to change them in order for the code to run properly! So, while they are a poerful tool they are also more prone to mistakes because they are made by you!
   4. A mistake that we made during this project was the outlining of our datatypes. As we got further into the project we oftten realized that our datatypes did not contain sufficient information to represent everything that was happepning in the game, forcing us to change the datatypes and the code that came afterwards in order for the code to run properly! One misconception that we had while working on the project was realized when solving our aformenthioned mistake, which was that datatypes are more powerful than we expected. Through work in class, datatypes and their members were often given to us, but having to decided what members were included and how to manipulate those members in functions to output what we wanted made us realize how strong they can be when working on coding projects!
   5. Piggybacking on concepts in question 2, seeing as in this project we worked with three different types of data format, would it be easier and more cohesive if all of the data were presented in the same format? If the project were larger and had more features, how would we go about deciding which format the data is most efficient to be in?
|#

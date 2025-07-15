# MAZE GAME DEVELOPMENT

## Overview

This project implements a maze-based navigation game developed in Pyret for the CS111 Introduction to Computer Science course at Brown University. The system features a reactive game engine with portal-based teleportation mechanics, dynamic maze loading from external configuration files, and comprehensive collision detection.

## Features

* **Reactive game architecture** using Pyret's reactor system
* **Portal-based teleportation** with distance-limited range mechanics
* **Dynamic maze configuration** loaded from Google Sheets
* **Comprehensive collision detection** preventing wall traversal
* **Real-time inventory management** with visual feedback
* **Grid-based movement system** with 30x30 pixel precision
* **Configurable maze layouts** supporting arbitrary dimensions

## Game Mechanics

### Movement System
* `W/↑` - Move up one grid cell
* `A/←` - Move left one grid cell  
* `S/↓` - Move down one grid cell
* `D/→` - Move right one grid cell
* `Mouse Click` - Teleport to clicked location (portal required)

### Portal System
* **Collection** - Automatically acquired when moving onto portal cells
* **Teleportation** - Click-to-teleport with 150-pixel range limitation
* **Single-use consumption** - Each portal depletes after one teleportation
* **Inventory tracking** - Real-time display of available portals

### Objective
Navigate the player character from the starting position to the computer terminal located at the maze exit.

## Architecture Components

### Core Data Structures

```pyret
data Location:
  | location(x :: Number, y :: Number)
end

data Player:
  | player(mildalocation :: Location, wormholecount :: Number)
end

data GameState:
  | gamestate(player :: Player, overlay :: List<Location>, background :: List<List<String>>)
end
```

### Key Modules

1. **Game State Manager** - Centralizes all game state transitions and updates
2. **Collision Detection Engine** - Validates movement against maze boundaries
3. **Portal Management System** - Handles collection, inventory, and teleportation logic
4. **Maze Rendering Engine** - Converts configuration data to visual representation
5. **Input Processing Layer** - Manages keyboard and mouse event handling
6. **Configuration Loader** - Imports maze layouts and item placements from Google Sheets

## Technical Implementation

### Maze Generation
* **Grid-based layout** using list-of-lists data structure
* **Texture mapping** with 30x30 pixel wall and floor tiles
* **Dynamic loading** from Google Sheets configuration files
* **Collision boundaries** enforced through coordinate validation

### Portal Mechanics
* **Distance calculation** using Euclidean distance formula
* **Range validation** with 150-pixel teleportation radius
* **Inventory management** with real-time count tracking
* **Position validation** ensuring teleportation to valid floor tiles only

### Performance Characteristics
* **Grid dimensions**: 35×19 cell maze (1050×570 pixels)
* **Asset specifications**: 24×24 pixel sprites, 30×30 pixel tiles
* **Memory efficiency**: List-based maze storage with minimal overhead
* **Collision detection**: O(1) constant-time cell validation

## Configuration System

### Maze Layout Configuration
The maze structure is defined in a Google Sheets document with:
* **maze-layout sheet**: Binary grid using "x" (walls) and "o" (floors)
* **items sheet**: Portal coordinates with x,y positioning data

### Asset Management
* **Character sprite**: `milda-down.png` (24×24 pixels)
* **Portal texture**: `wormhole.png` (24×24 pixels)
* **Exit marker**: `computer.png` (24×24 pixels)
* **Environment tiles**: `wall.png`, `tile.png` (30×30 pixels)

## Testing Framework

### Critical Function Testing
* **Movement validation** - Comprehensive edge case coverage for boundary conditions
* **Portal mechanics** - Range validation and inventory management verification
* **Collision detection** - Wall boundary enforcement testing
* **State transitions** - Game completion and state persistence validation

### Test Coverage
* **Unit tests** for individual component functions (minimum 2 test cases each)
* **Integration tests** for complete game loop functionality
* **Edge case validation** for boundary conditions and error states
* **Performance testing** for responsive gameplay experience

## Setup Instructions

### Prerequisites
* Pyret programming environment
* Access to project support libraries
* Google Sheets with maze configuration data as linked in repository

### Installation Process
1. Configure spreadsheet ID in the source code
2. Load project dependencies and support libraries
3. Initialize game state with maze and item data fromo configuration
4. Launch reactor-based game loop

### Configuration
```pyret
ssid = "YOUR_SPREADSHEET_ID_HERE"
maze-data = load-maze(ssid)
item-data = load-items(ssid)
```
* https://docs.google.com/spreadsheets/d/1VI21BIZMZGfxU43gf1tnd8VWimNioKH5iVQLTR6ZaLs/edit?usp=sharing
* https://docs.google.com/spreadsheets/d/1s5DpnEhJsiXYHKDUJvbi4unTJKCFb0dog9lZPhwb4mU/edit?usp=sharing
* https://docs.google.com/spreadsheets/d/1Nt2JKwBK8gtVOQ7f5UtU-2K-P9WTLb7g3S6upqLK2cg/edit?usp=sharing

## Performance Optimization

### Key Optimizations
* **Efficient maze traversal** using direct list indexing
* **Optimized collision detection** with coordinate-based validation
* **Memory management** through immutable data structures
* **Rendering pipeline** with layered image composition

### Resource Utilization
* **Memory footprint**: Minimal with list-based maze representation
* **Processing efficiency**: O(1) movement validation and collision detection
* **Rendering performance**: Optimized through image overlay techniques

## Design Decisions

### Data Structure Selection
* **List-of-lists for maze data** - Enables efficient iteration with `cases` function
* **Table format for item coordinates** - Provides precise positioning for portal placement
* **Immutable game state** - Ensures consistent state transitions and debugging

### Portal System Implementation
* **Range-limited teleportation** - Prevents trivial maze solving
* **Single-use consumption** - Adds strategic resource management
* **Visual feedback** - Real-time inventory display for user awareness

## Limitations

### Technical Constraints
* **Fixed maze dimensions** - 35×19 grid limitation
* **Hardcoded portal range** - 150-pixel teleportation radius
* **Single configuration** - One maze layout per game session
* **No progressive difficulty** - Static challenge level

### Future Enhancements
* **Multi-level progression** with increasing maze complexity
* **Variable portal ranges** based on difficulty settings
* **Performance analytics** with completion time tracking
* **Enhanced visual effects** for improved user experience

## Verification

All system components have been validated through:
* **Functional testing** of core game mechanics
* **Boundary condition verification** for edge cases
* **Integration testing** with complete gameplay scenarios
* **Performance validation** for responsive user interaction

Expected behavior is documented with comprehensive test cases covering normal operation, edge conditions, and error states.

### Technology Stack
* **Language**: Pyret functional programming language
* **Framework**: Reactor-based event handling system
* **External Dependencies**: Google Sheets API for configuration
* **Testing**: Built-in Pyret testing framework

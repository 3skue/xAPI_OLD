# xAPI

![xAPI Logo](https://github.com/3skue/xAPI/assets/142699644/a3e884cb-05c0-46cd-98a6-2ef6ba85aa2f)

## Introduction

xAPI is an open source tool to simulate Roblox exploit functions, such as `hookfunction`, `getrawmetatable` and more.

## Usage

In order to use xAPI, put this code in the script:

```lua
require(game.ReplicatedStorage.xAPI)()
```

The functions will automatically load in, so there's no need to do

```lua
local xAPI = require(game.ReplicatedStorage.xAPI)
xAPI...
```

Example:

```lua
require(game.ReplicatedStorage.xAPI)()

local mt = setmetatable({}, {
    __metatable = "This metatable is locked"
})

print(getmetatable(mt))
-- This metatable is locked

print(getrawmetatable(mt))
--[[
    {
        __metatable = "This metatable is locked"
    }
]]
```

## Documentation

Coming soon!

###### Current build as of 5.11.2023 [11/5/2023]: build::832452800

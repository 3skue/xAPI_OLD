# xAPI Documentation

## Functions:

## Template

`[functionname][arguments (:<type>, ? = optional, ... means anything)] -> [returned type]`

- [>] description

- [!]  warning

- [i] information

- [*]  alias


**Example:**

- `print(...) -> nil`

- - [>] Adds a log to the developer console and (if in studio) into the `output` panel.

- - [i] `tostring`s `...`


### Instances

- `gethui() -> Instance`

- - [>] Returns the `LocalPlayer`'s `PlayerGui`

- `getinstances() -> table`

- - [>] Returns all `Instances`

- `getnilinstances() -> table`

- - [>] Returns all `Instances` parented to `nil` / that are destroyed

- `getscripts() -> table`

- - [>] Returns all `BaseScripts`

- `getmodules() -> table`

- - [>] Returns all `ModuleScripts`



### Scripting Environment

- `newcclosure(closure:<function>) -> function`

- - [>] Wraps `closure` into a `coroutine`

- `newlclosure(closure:<function>) -> function`

- - [>] Wraps `closure` into a a `luau` function

- `iscclosure(closure:<function>) -> boolean`

- - [>] Returns if `closure` is a `cclosure`

- `islclosure(closure:<function>) -> boolean`

- - [>] Returns if `closure` is an `lclosure`

- `clonefunction(closure:<function>) -> function`

- - [>] Returns a C or L closure which runs `closure` along with its `vararg`

- `getcurrentline() -> number`

- - [>] Returns the current line which ran this

- `getthreadidentity() -> number`

- - [>] Returns 2

- - [*] `getidentity`, `getthreadcontext`

- `getthread() -> thread`

- - [>] Returns the current running coroutine

- `getmemoryaddress(obj:<any>) -> string`

- - [>] Returns the memory address of `obj`

- `getgenv() -> table`

- - [>] Returns the xAPI environment

- `getrenv() -> table`

- - [>] Returns the Roblox environment

- `isexecutorclosure(closure:<function>) -> boolean`

- - [>] Returns if `closure` isn't a part of Roblox's environment

- - [*]  `checkclosure`, `isourclosure`

- `getrawmetatable(object:<table or userdata>)`

- - [>] Returns the rawmetatable of `object` if available

- - [!]  Will not get the real rawmetatable or the rawmetatable of predefined objects (like `game`, `getfenv`, etc.)

- `isluau() -> boolean`

- - [>] Returns if the current game is using luau

- - [i] Will always return true as luau is no longer toggleable

- `dumpstring(_string) -> string`

- - [>] Returns `_string` with every character being converted to a number

- - (`a` -> `\97`)

- `checkcaller() -> boolean`

- - [>] Returns if the current thread is the exact same as the scripts original thread

### Miscellaneous

- `isgameactive() -> boolean`

- - [>] Returns if the window is focused or not

- - [*]  `isrbxactive`

- `setfpscap(newfpscap:<number>) -> nil`

- - [>] Sets the FPS cap to `newfpscap`

- `setclipboard(content) -> nil`

- - [>] Fires the `clipboard` event with `content`

- - [*] `setclipboard`, `setrbxclipboard`, `toclipboard`

- `getloadedmodules() -> table`

- - [>] Returns a table of all modules that were loaded using require

- `identifyexecutor() -> union<string, string>`

- - [>] Returns xAP[i] and then the automatically generated build ID

- - [*] `getexecutorname`

### Crypt

- `crypt.base64encode(data)`

- - [>] Returns `data` encoded using base64

- - [*] `base64_encode`

- `crypt.base64decode(data)`

- - [>] Returns `data` decoded using base64

- - [*] `base64_decode`

- `crypt.hash(data, algorithm)`

- - [>] Returns  `data` hashed with `algorithm`

- - [i] Supports `SHA2` and `md5`

- `crypt.generatabytes(len)`

- - [>] Return random bytes of length `len`

### File System

- `readfile(name: string) -> string`

- - [>] Reads the content of the file specified by `name` and returns it as a string.

- `writefile(name: string, data: string) -> nil`

- - [>] Writes the provided `data` to the file specified by `name`.

- `appendfile(name: string, data: string) -> nil`

- - [>] Appends the provided `data` to the end of the file specified by `name`.

- `listfiles(name: string) -> table`

- - [>] Returns a table containing the names of all files inside the specified folder.

- `isfile(name: string) -> boolean`

- - [>] Returns true if the specified `name` refers to an existing file, otherwise false.

- `isfolder(name: string) -> boolean`

- - [>] Returns true if the specified `name` refers to an existing folder, otherwise false.

- `makefolder(name: string) -> nil`

- - [>] Creates a new folder with the specified `name`.

- `delfolder(name: string) -> nil`

- - [>] Deletes the folder specified by `name` along with all its contents.

- `delfile(name: string) -> nil`

- - [>] Deletes the file specified by `name`.

### RConsole API

- `rconsoleprint(txt: string) -> nil`

- - [>] Prints `txt` to `rconsole`

- - [i] Code: 1

- - [*] `rconsoleprint`, `consoleprint`

- `rconsolewarn(txt: string) -> nil`

- - [>] Warns `txt` to `rconsole`

- - [i] Code: 2

- - [*]  rconsolewarn, consolewarn

- rconsoleerr(txt: string) -> nil`

- - [>] Errors `txt` to `rconsole`

- - [i] Code: 3

- - [*] `rconsoleerr`, `rconsoleerror`, `consoleerr`, `consoleerror`

- `rconsoleclear() -> nil`

- - [>] Clears `rconsole` output

- - [i] Code: 4

- - [*] `rconsoleclear,` `consoleclear`

- `rconsoleinput() -> string`

- - [>] Waits for and returns user input from `rconsole`

- - [i] Code: 5

- - [*] `rconsoleinput`, `consoleinput`

- `rconsolesettitle(txt: string) -> nil`

- - [>] Sets the title of `rconsole` window to the specified `txt`

- - [i] Code: 6

- - [*] `rconsolesettitle`, `consolesettitle`, `rconsolename`

- `rconsolecreate() -> nil`

- - [>] Creates/Shows a new `rconsole` window

- - [i] Code: 7

- - [*] `rconsolecreate`, `consolecreate`

- `rconsoledestroy() -> nil`

- - [>] Destroys/Closes the current `rconsole` window

- - [i] Code: 8

- - [*] `rconsoledestroy`, `consoledestroy`

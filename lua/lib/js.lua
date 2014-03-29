--[[
Lua@Client - js.lua
The library that calls browser methods from Lua
Copyright (c) 2014 Felipe Daragon

License: MIT
]]

local getset = require("getset")

local function createJSLib()
local js = {}
-- Adds read-only properties to an object
function add_ra_prop(objname,obj,props)
	for i, name in ipairs(props) do
		getset.defineProperty(obj, name, {
			get = function() return js_getprop(objname,name) end
			})
		end
	end

	-- Adds read-and-write properties to an object
	function add_rw_prop(objname,obj,props)
		for i, name in ipairs(props) do
			getset.defineProperty(obj, name, {
				get = function() return js_getprop(objname,name) end,
				set = function( value ) js_setprop(objname,name,value) end
				})
			end
		end

		-- Creates the navigator object (fully implemented)
		function create_navigator()
			local n = "navigator"
			js.navigator = {
				javaEnabled = function() return js_method(n,"javaEnabled") end,
				taintEnabled = function() return js_method(n,"taintEnabled") end
			}
			add_ra_prop(n,js.navigator,
			{
				"appCodeName",
				"appMinorVersion",
				"appName",
				"appVersion",
				"browserLanguage",
				"cookieEnabled",
				"cpuClass",
				"onLine",
				"platform",
				"userAgent",
				"systemLanguage",
				"userLanguage"
			}
			)
		end

		-- Creates the history object (fully implemented)
		function create_history()
			local n = 'history'
			js.history = {
				back = function() js_method(n,"back") end,
				forward = function() js_method(n,"forward") end,
				go = function(url) js_method(n,"go",url) end
			}
			add_ra_prop(n, js.history, {"length"})
		end

		-- Creates the screen object (fully implemented)
		function create_screen()
			local n = "screen"
			js.screen = {}
			add_ra_prop(n, js.screen, {
				"availHeight",
				"availWidth",
				"colorDepth",
				"deviceXDPI",
				"deviceYDPI",
				"fontSmoothingEnabled",
				"height",
				"logicalXDPI",
				"logicalYDPI",
				"pixelDepth",
				"width"
			}
			)
			add_rw_prop(n, js.screen, {
				"bufferDepth",
				"updateInterval"
			}
			)
		end

		-- Creates the location object (fully implemented)
		function create_location()
			local n = "location"
			js.location = {
				assign = function(url) js_method(n,"assign",url) end,
				reload = function() js_method(n,"reload") end,
				replace = function(url) js_method(n,"replace",url) end
			}
			add_rw_prop(n, js.location, {
				"hash",
				"host",
				"hostname",
				"href",
				"pathname",
				"port",
				"protocol",
				"search"
			}
			)
		end

		-- Creates the document object (partially implemented)
		function create_document()
			local n = "document"
			js.document = {
				location = js.location,
				close = function() js_method(n,"close") end,
				open = function() js_method(n,"open") end,
				write = function(s) js_method(n,"write",s) end,
				writeln = function(s) js_method(n,"writeln",s) end
			}
			add_ra_prop(n, js.document, {
				"domain",
				"lastModified",
				"referrer",
				"title"
			}
			)
			add_rw_prop(n, js.document, {
				"cookie"
			}
			)
		end

		-- Creates the window object (partially implemented)
		function create_window()
			local n = "window"
			js.window = {
				location = js.location,
				document = js.document,
				history = js.history,
				alert = function(msg) js_method(n,"alert",msg) end,
				blur = function() js_method(js.window.name,"blur") end,
				clearInterval = function(id) js_method(n,"clearInterval",id) end,
				clearTimeout = function(id) js_method(n,"clearTimeout",id) end,
				close = function() js_method(n,"close") end,
				confirm = function(s) return js_method(n,"confirm",s) end,
				focus = function() js_method(n,"focus") end,
				moveBy = function(x, y) js_method(n,"moveBy", x, y) end,
				moveTo = function(x, y) js_method(n,"moveTo", x, y) end,
				open = function(url, name, features) js_method(n,"open", url, name, features) end,
				print = function() js_method(n,"print") end,
				prompt = function(s,deftext) return js_method(n,"prompt",s,deftext) end,
				scrollBy = function(x, y) js_method(n,"scrollBy", x, y) end,
				scrollTo = function(x, y) js_method(n,"scrollTo", x, y) end,
				setInterval = function(f, delay) js_method(n,"setInterval", f, delay) end,
				setTimeout = function(f, delay) js_method(n,"setTimeout", f, delay) end
			}

			add_ra_prop(n, js.window, {
				"closed",
				"length",
				"outerHeight",
				"outerWidth",
				"pageXOffset",
				"pageYOffset"
			}
			)

			add_rw_prop(n, js.window, {
				"defaultStatus",
				"name",
				"status"
			}
			)
		end
		
		-- Creates the console object (almost fully implemented)
		function create_console()
			local n = "console"
			js.console = {
				count = function(label) js_method(n,"count",label) end,
				debug = function(...) js_method(n,"debug",...) end, -- alias for log
				dir = function(...) js_method(n,"dir",...) end,
				error = function(...) js_method(n,"error",...) end,
				exception = function(...) js_method(n,"exception",...) end, -- alias for error
				group = function() js_method(n,"group") end,
				groupCollapsed = function() js_method(n,"groupCollapsed") end,
				groupEnd = function() js_method(n,"groupEnd") end,
				info = function(...) js_method(n,"info",...) end,
				log = function(...) js_method(n,"log",...) end,
				time = function(name) js_method(n,"time",name) end,
				timeEnd = function(name) js_method(n,"timeEnd",name) end,
				trace = function() js_method(n,"trace") end,
				warn = function(...) js_method(n,"warn",...) end
			}
		end

		-- Note: Do not change the execution order unless you reimplemented
		-- the object aliases using getset
		create_navigator()
		create_history()
		create_screen()
		create_location()
		create_document()
		create_window()
		create_console()
		return getset.seal(js)
	end

	js = createJSLib()

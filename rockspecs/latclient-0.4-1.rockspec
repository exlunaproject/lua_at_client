package = "latclient"
version = "0.4-1"
source = {
   url = "git://github.com/sailorproject/lua_at_client",
   tag = "v0.4-alpha"
}
description = {
   summary = "An extension of LuaPages preprocessor to use Lua at the browser",
   detailed = [[
      Lua@Client is focused in helping bring the Lua programming language to the web and browser. This project extends the .lp preprocessor to add support for new opening tags.
   ]],
   license = "MIT"
}
dependencies = { 
}
build = {
   type = "builtin",
   modules = {
      latclient = "lua/latclient.lua",
      ['latclient.common'] = "lua/latclient/common.lua",
      ['latclient.conf'] = "lua/latclient/conf.lua",
      ['latclient.lp_handler'] = "lua/latclient/lp_handler.lua",
      ['latclient.lua51js'] = "lua/latclient/lua51js.lua",
      ['latclient.luavmjs'] = "lua/latclient/luavmjs.lua",
      ['latclient.moonshine'] = "lua/latclient/moonshine.lua",
      ['latclient.starlight'] = "lua/latclient/starlight.lua"
   }
}
# Lua@Client #

Lua@Client is focused in helping bring the Lua programming language to the web. This project extends the .lp preprocessor to add support for new opening tags: `<?lua@client`, `<?lua@server`, and `<?lua@both`.

The tag `<?lua@client` converts the code to client-side Lua, `<?lua@server` works the same as `<?lua` without the @ complement, and `<?lua@both` allows to mix client and server-side Lua code.

Lua@Client can be used with mod_lua, CGILua and projects that use the `lp.lua` library. It is also integrated and bundled with the latest release of the Sailor MVC Lua Framework (https://github.com/Etiene/sailor).

To make the client-side Lua usage possible, the project integrates and extends the Lua VM in JavaScript developed by @agladysh allowing initial usage of browser-specific JavaScript objects (such as `document`, `window`, etc) from Lua. You can also use this without any preprocessors, from static HTML pages (see the examples folder for some simple example usage).

Lua@Client also provides on-the-fly conversion of Lua libraries to JavaScript. This allows to load files and modules via a standard `<script>` tag.

## Development Status #

This project is still beta. All input, feedback and contributions are highly appreciated. 

### Browser JS Objects #

* `navigator` - fully implemented
* `history` - fully implemented
* `screen` - fully implemented
* `location` - fully implemented
* `document` - partially implemented
* `window` - partially implemented

##Installation

###Installation for Apache with mod_lua

1. Copy the JavaScript files from the `js` directory in this repository to a public area of your website.
2. Change the js_url value in `latclient.lua`. It must point to the URL where your copy of the JS files can be found.
3. Copy `latclient.lua` and the `latclient` subdirectory (which contains the lp_*.lua files) to the lua directory.
4. Edit the Apache httpd.conf file and add:

```
LuaMapHandler "\.lp$" "path/to/lua/latclient/lp_handler.lua" handle_lp
```

Done! You can start using `<?lua@` in .lp files.

####Loading Modules

Lua@Client can load files and modules via a standard `<script>` tag. All that is needed is to edit the Apache httpd.conf file and add:

```
LuaMapHandler /pub/lua "path/to/lua/latclient/lp_handler.lua" provide_file
```

After this you can use a script tag pointing directly to files in the `/pub/lua` directory (Example: `<script src="pub/lua/mymodule.lua"></script>`). You will see that the file is converted on-the-fly to JavaScript. If you call, for example, `require "pub.lua.mymodule"` from within the tags `<?lua@client`, `<?lua@server` or `<?lua@both`, the module will be loaded.

####Note about FallbackResource

With Apache HTTPd <2.4.9 (TBA), the FallbackResource directive should preferably not be used in the active virtual host, as it invalidates the LuaMapHandler directive.

###Installation for Apache/mod_lua and Sailor

Lua@Client comes bundled with the Sailor MVC Lua Framework (https://github.com/Etiene/sailor), so there is no need to change anything. Install Sailor (https://github.com/Etiene/sailor#installation-for-debian-like-systems) and simply point your browser to `?r=test/runat_client` and `?r=test/runat_both` to see it in action.

###Installation for CGILua

1. Copy the JavaScript files from the `js` directory in this repository to a public area of your website.
2. Change the js_url value in `latclient.lua`. It must point to the URL where your copy of the JS files can be found.
3. Copy `latclient.lua` to the lua directory.
4. Edit `cgilua\lp.lua` and: add `local lat = require "latclient"` to the beginning of the file and add `s = lat.translate(s)` as the first line of the translate function (see the `lua\latclient\lp_mod.lua` file for an example).

Done! You can create your first .lp script using `<?lua@`

PS: A way to make a Lua file to provide itself as JS can be found under `\examples\file_provider\demo_cgilua.lua`

## Usage #

### Both Client & Server #

```html
<?lua@both
 msg = 'Houston, Tranquility Base here.'
 
 function getlastmsg()
  return 'The Eagle has landed.'
 end
?>

<h2><?=msg?></h2>
<h3><?=getlastmsg()?></h3>

<?lua@client
 require("js")
 js.window.alert(msg..' '..getlastmsg())
?>
```

### Client #

```html
<?lua@client
 require('js')
 
 print('Today is: '..os.date()..'<br>')
 print('Your User-Agent is: '..js.navigator.userAgent..'<br>')
 if js.navigator.cookieEnabled == true then
      print('Cookie support is enabled.<br>')
 else
      print('Cookie support is disabled.<br>')
 end
 
 function say_bye()
      print('Bye! :)')
 end
?>

<hr>

<?lua@client
 say_bye()
?>
```

## License #

Lua@Client is licensed under the MIT license (http://opensource.org/licenses/MIT)

(c) Felipe Daragon, 2014

Lua@Client contains the following MIT-licensed, third-party code:

* Copyright (c) LogicEditor <info@logiceditor.com>, and lua5.1.js authors - lua5.1.js project files, based on Lua.
* Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io) and Contributors (http://phpjs.org/authors) - base64 decode function for JavaScript
* Copyright (c) 2011 Josh Tynjala - getset Lua library
* Copyright (c) 1994-2012 Lua.org, PUC-Rio - Lua
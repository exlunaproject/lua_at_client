# Lua@Client #

Lua@Client is focused in helping bring the Lua programming language to the web. This project extends the .lp preprocessor to add support for new opening tags: `<?lua@client`, `<?lua@server`, and `<?lua@both`. The tag `<?lua@client` converts the code to client-side Lua, `<?lua@server` works the same as `<?lua` or `<?`, and `<?lua@both` allows to mix client and server-side Lua code.

To make the client-side Lua usage possible, the project integrates and extends the Lua VM in JavaScript developed by Alexander Gladysh (@agladysh), allowing initial usage of browser-specific JavaScript objects (such as `document`, `window`, etc) from Lua. You can also use this without any preprocessors, from static HTML pages (see the examples folder for some simple example usage).

Lua@Client also provides on-the-fly conversion methods of Lua libraries to JavaScript. This allows you to serve and load Lua libraries over the web without having to manually pack them as JavaScript files.

Lua@Client was developed to be used with the Sailor MVC Lua Framework (https://github.com/Etiene/sailor), but can also be used with projects that use the `lp.lua` library, like CGILua.

## Development Status #

This project is still beta. All input, feedback and contributions are highly appreciated. 

### Browser JS Objects #

`navigator` - fully implemented
`history` - fully implemented
`screen` - fully implemented
`location` - fully implemented
`document` - partially implemented
`window` - partially implemented

##Installation

###Installation for mod_lua with Sailor

Lua@Client comes bundled with the Sailor MVC Lua Framework (https://github.com/Etiene/sailor), so there is no need to change anything. Install Sailor and simply point your browser to `?r=test/runat_client` and `?r=test/runat_both` to see it in action.

###Installation for CGILua

1. Copy the JavaScript files from the `js` directory in this repository to a public area of your website.
1. Change the js_url value in `latclient.lua`. It must point to the URL where your copy of the JS files can be found.
2. Copy `latclient.lua` to the lua directory.
3. Edit `cgilua\lp.lua` and: add `local lat = require "latclient"` to the beginning of the file and add `s = lat.translate(s)` as the first line of the translate function.

Done! You can create your first .lp script using `<?lua@`!

## Usage #

### Mixed Client & Server #

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

## File Provider #

If you prefer, you can use Lua@Client to serve Lua libraries without having to manually convert the files to JavaScript. All that is needed is to add a `<script type="text/javascript"` tag pointing directly to the Lua library, which must be edited to include the code below. After this if you open the URL you will see that the Lua library is converted on-the-fly to lua5.1 compatible JavaScript.

### Provider for mod_lua #

```lua
function handle(r)
    local p = require "latclient"
    return p.handle(r)
end

--[[Your Code Here]]
```

### Provider for CGILua #

```lua
p = require "latclient"
p.cgilua_exit("/")

--[[Your Code Here]]
```

## License #

Lua@Client is licensed under the MIT license (http://opensource.org/licenses/MIT)

(c) Felipe Daragon, 2014

Lua@Client contains the following MIT-licensed, third-party code:

Copyright (c) LogicEditor <info@logiceditor.com>, and lua5.1.js authors - lua5.1.js project files, based on Lua.
Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io) and Contributors (http://phpjs.org/authors) - base64 decode function for JavaScript
Copyright (c) 2011 Josh Tynjala - getset Lua library
Copyright (c) 1994-2012 Lua.org, PUC-Rio - Lua
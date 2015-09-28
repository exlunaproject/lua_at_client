#Usage Examples #

Here are some examples of Lua code that will run on the browser using the `lua51js` virtual machine:

## Both Client & Server #

```
<?lua@both
 msg = 'Houston, Tranquility Base here.'
 
 function getlastmsg()
  return 'The Eagle has landed.'
 end
?>

<h2><?=msg?></h2>
<h3><?=getlastmsg()?></h3>

<?lua@client
 js.window:alert(msg..' '..getlastmsg())
?>
```

## Client #

```
<?lua@client
 js.document:write('Today is: '..os.date()..'<br>')
 js.document:write('Your User-Agent is: '..js.navigator.userAgent..'<br>')
 if js.navigator.cookieEnabled == true then
      js.document:write('Cookie support is enabled.<br>')
 else
      js.document:write('Cookie support is disabled.<br>')
 end
 
 function say_bye()
      js.document:write('Bye! :)')
 end
?>

<hr>

<?lua@client
 say_bye()
?>
```

## Calling JS functions from Lua #

```html
<?lua@client?><!-- Serve the VM first-->
<script type="text/javascript">
function myalert(L) {
 var str = C.luaL_checkstring(L, 1);
 window.alert(str);
 return 0;
}
LuaCS.addFunction('myalert',myalert);
</script>
<?lua@client
myalert('Hello World from Lua!')
?>
```

## Adding a Library #

```html
<?lua@client?><!-- Serve the VM first-->
<script type="text/javascript">
  var MyLib = {
   alert: function(L) {
    var str = C.luaL_checkstring(L, 1);
    window.alert(str);
    return 0;
   },
   upper: function(L) {
    var str = C.luaL_checkstring(L, 1);
    C.lua_pushstring(L,str.toUpperCase());
    return 1;
   }
  }
  
  var MyLibFuncs = [
   ["alert", MyLib.alert],
   ["upper", MyLib.upper]
  ];
  LuaCS.addLibrary("test", MyLibFuncs);
</script>
<?lua@client
  msg = test.upper('It works!')
  test.alert(msg)
?>
```

## Script Tag: An Alternative Way #

```html
<?lua@client runonload()?>
<script type="text/lua">
js.window:alert('Hello World from Lua!')
</script>
```

If you use this method, the Lua scripts will run after the page has loaded. For immediate execution, use the `<?lua@client` tag as explained above.

##Loading Modules #

Lua@Client can load files and modules via a standard `<script>` tag. All that is needed is to edit the Apache httpd.conf file and add:

```
LuaMapHandler /pub/lua "path/to/lua/latclient/lp_handler.lua" provide_file
```

After this you can use a script tag pointing directly to files in the `/pub/lua` directory. Example:

```html
<?lua@client?><!-- Serve the VM first-->
<script src="pub/lua/mymodule.lua"></script>
```

You will see that `mymodule.lua` is converted on-the-fly to JavaScript, extending the VM. Now you can load the library by just doing: 

```
<?lua@client
require "pub.lua.mymodule"
...
?>
```

###On-the-fly Using CGI-Lua #
PS: A way to make a Lua file to provide itself as JS can be found under [here](https://github.com/felipedaragon/lua_at_client/blob/master/examples/file_provider/demo_cgilua.lua).

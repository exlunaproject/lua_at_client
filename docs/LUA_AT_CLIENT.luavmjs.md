#Usage Examples

Here are some examples of Lua code that will run on the browser using the `luavmjs` virtual machine:

##Hello World

    <?lua@client
    
    -- Log it to the console
    print('hello' .. ' ' .. 'world!')
    
    ?>

##Manipulation of the DOM

    <div id="app"></div>
    <?lua@client
    
    local app = js.global.document:getElementById('app')
    print(app.textContent)
    app.textContent = 'lets go'
    
    js.global.window:alert('This code was written in Lua')
    
    ?>
    
##Run JS from Lua

    <?lua@client
    
    print(js.global:eval('[0,1,2,3,4,5][3]'))
    
    ?>
    
##Callbacks into Lua

    <?lua@client
    
    local window = js.global -- global object in JS is the window
    window:setTimeout(function() print('hello from lua callback') end, 2500)
    
    ?>
    
##Call constructors (global, or as properties of other objects)

    <?lua@client
    
    print("i made an ArrayBuffer of size " .. js.new(js.global.ArrayBuffer, 20).byteLength)
    
    ?>
    
##Exporting Lua modules to the browser

Not possible yet using this VM.

##Script Tag Support

```html
<?lua@client?><!-- Serve the VM first-->
<script type="text/lua">
js.window:alert('Hello World from Lua!')
</script>
```

If you use this method, the Lua scripts will run after the page has loaded. For immediate execution, use the `<?lua@client` tag as explained above.
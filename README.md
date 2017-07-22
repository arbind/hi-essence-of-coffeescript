
# run

```
coffee web.coffee
```

# build
```
cake jade
```

# install
```
npm install -g coffeescript
npm install -g jade
npm install -g stylus
npm install
```

# Building the Ace Editor
```
git submodule update

pushd .
cd ace
npm install
node ./Makefile.dryice.js --target ../public/js/vendor/ace
popd
cake jade
coffee web.coffee
```
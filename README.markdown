tinyprofiler-client
===================

shared client for tinyprofiler, a minimal JavaScript profiler

  * [introduction](#introduction)
  * [getting started](#getting-started)
  * [UI packages](#ui-packages)
  * [documentation](#documentation)
    * [browser bundling](#browser-bundling)
    * [markup specification](#markup-specification)
    * [API reference](#api-reference)
      * [tinyprofilerClient( [profiler], [options] )](#tinyprofilerclient-profiler-options-)
      * [fetch( id )](#fetch-id-)
      * [getById( id )](#getbyid-id-)
      * [getRequests()](#getrequests)

introduction
------------

This package contains the shared client code for [tinyprofiler][0].
Use this as part of your front-end environment to manage reporting of
profiles.  The one thing this package doesn't do is construct markup,
for that you'll need to install one of the UI pacakges.

getting started
---------------

First set up *tinyprofiler* server-side.  You can install this
package with the manager of your choice: we support **npm** (with
[npm-css][1] or [rework-npm][2] for stylesheets), **component** and
**bower**.

If you wish to profile client-side, create an instance of
*tinyprofiler* and pass it in to the client constructor.

```coffeescript
tp = require 'tinyprofiler'
tpClient = require 'tinyprofiler-client'

profiler = tp(options)
client = tpClient(profiler, options)
```

If you're only profiling server-side you can just create the client
passing only the options hash.

```coffeescript
tpClient = require 'tinyprofiler-client'

client = tpClient(options)
```

Now go get a UI package for the view engine of your choice!

UI packages
-----------

At the moment the only UI implementation is:

  * [tinyprofiler-react][3], a React.js-based front-end

The rationale for splitting the front-end code is to make it easier
for applications to tightly integrate *tinyprofiler* into their
existing stack.  If your front-end framework isn't represented in
the above list, you are invited to create a package to generate
markup and submit a pull request to list it here.

documentation
-------------

  * browser bundling
  * markup specification
  * API reference

### browser bundling ###

No matter how you develop your app, no matter what libraries or
frameworks you use, you should be bundling before deploying to
production.  *tinyprofiler* is built as a CommonJS module, so that
it can be loaded identically on the server in Node.js as well as on
the client with Browserify or another compatible tool.  We recommend
you do the same with your app.

*tinyprofiler-client* also includes shared CSS.  Packaging CSS over
NPM is still an emerging field, but npm-css and rework-npm provide
compatible implementations utilizing the standard `@import` statement.
We also provide `bower.json` and `component.json` files to integrate
seamlessly into those build systems.

Worst case, you can load the stylesheet explicitly from the
`node_modules` folder.  The stylesheet to load is specified in the
`package.json` file under the `style` key.  Currently the path is
`lib/index.css`.

If you have another package or build system you'd like us to handle,
we welcome pull requests to add additional support.

### markup specification ###

*nothing yet*

### API reference ###

#### tinyprofilerClient( [profiler], [options] ) ####

Create a new *tinyprofiler-client*.  `profiler` is an instance of
*tinyprofiler* for local profiling.  `options` is a hash of options.
Both are optional.

The options accepted are:

```coffeescript
headerName: "X-TinyProfiler-Ids"
monkeyPatch: yes
path: "tp"
```

##### headerName #####

the name of the HTTP header to use to receive profile ids

##### monkeyPath #####

do we automatically monkey patch the XHR object?

##### path #####

server path where *tinyprofiler* REST API is mounted

#### fetch( id ) ####

Fetch the profile with the given `id` from the server to make it
available locally.

#### getById( id ) ####

Get the profile with the given `id` from the local cache.

#### getRequests() ####

Get all profiles held locally.

##### ╭╮☲☲☲╭╮ #####

[0]: https://github.com/couchand/tinyprofiler
[1]: https://www.npmjs.org/package/npm-css
[2]: https://www.npmjs.org/search?q=rework-npm
[3]: https://github.com/couchand/tinyprofiler-react

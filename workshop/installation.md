# Workshop Prerequisites

In the workshop, we are going to be writing lots of code in both Elm 
and purescript. We're not guaranteed good Internet at the workshop, so
the workshop will need a little bit of preplanning and installation to 
get up and running.

If you forgot to do this don't fret and still come along if you're interested!
Ben will have his 4G Hotspot around, but it can only do 10 connections at once
and is his own personal data quota: so be nice! :)

You'll need a laptop at the workshop with the following high level prerequisites:

  - This entire git repo checked out.
  - nodejs & NPM (node package manager)
  - bower (a package manager that purescript uses)
  - elm
  - purescript & pulp (purescript build tool)
  - A text editor (Visual Studio Code works well)
  - Installing the elm and purescript dependencies in each of the projects

**_If you have any issues installing this, please raise an issue against the github tracker and I'll
help out._**

### Code

If you have git, just `git clone --recursive https://github.com/benkolera/ylj-reading-the-tea-leaves.git`.

If you don't have git and don't want to set that up, you can just 
[download the code here](https://github.com/benkolera/ylj-reading-the-tea-leaves/archive/master.zip) and
the answers here ([elm](https://github.com/benkolera/ylj-reading-the-tea-leaves-elm/archive/master.zip),
[halogen](https://github.com/benkolera/ylj-reading-the-tea-leaves-halogen/archive/master.zip). 

It'll be easier with git because you'll be able to easily pull new changes when
I invaribly make last minute changes. :)

### NodeJs & NPM

First please install nodejs and NPM for your operating system.

https://nodejs.org/en/download/package-manager/

_If you have an older version of node already installed, be sure to update. You'll need
npm 4.x to build purescript, so it's best to install up to node 7.10 or 6.10.3 (LTS)._

If you are unfamiliar with Node and NPM and your global installatian
of dependencies causes EACCESS errors, this is because NPM has been 
set up to write to a global package directory that isn't in a folder
that your user is allowed to write to. If you've installed on Windows
or Homebrew on Mac you won't have these issues, but some linux packages
set it up in this way.

*You should never run* `sudo npm install -g`. Npm packages can run arbitrary code
upon installation, so running them as root is a really bad idea. :)

Instead, fix the permissions using Option2 of these instructions:

https://docs.npmjs.com/getting-started/fixing-npm-permissions 

### Elm

Since we've got nodejs anyway for bower, the easiest way to get this running
is via npm.

`npm install -g elm`

But if that doesn't work for some reason, there are prebuilt binaries and installers
here:

https://guide.elm-lang.org/install.html

### Bower, Purescript & Pulp

_*If you already have purescript, be sure to have 0.11.4 installed otherwise 
the code won't compile*_. If you get an error about not knowing about the
RowCons type, you've got an older purescript 0.11.x version.

Note: If you have a distribution with a ncurses-6 (archlinux and fedora)
then you will need to install a [ncurses-5 compat layer](https://aur.archlinux.org/packages/ncurses5-compat-libs/). 

`npm install -g bower purescript pulp`

We need bower for dependency management and pulp is a nice build tool that wraps the compiler nicely.

### Editor

You can use whatever editor you want, but if you want something that works
out of the box fairly well for Elm and Purescript, give Visual Studio code
a go! 

https://code.visualstudio.com/docs/setup/setup-overview 

If you install "elm", "elm-format", "Purescript IDE" extensions you'll be in
a good spot to get going. Installing "Vim" is a good way to not get mad as VSCode
if you are like me have vim bindings in permanent muscle memory. :)

### Elm Dependencies

To make sure Elm is all happy and that it downloads all of the packages you need
before the workshop. Jump into the /elm directory of this project and run `elm-reactor`.

In a browser, navigate to http://localhost:8000/test.html and wait for hello world to 
appear. It needs to install a few dependencies to get there, so don't worry if it 
takes a little while.

If you see hello world button, you're all set to go! It's probably a good idea to 
edit the Main.elm to a different hello world string and make sure your editor
is all good and that refreshing your browser brings that change into the app.

### Purescript Dependencies

In the workshop/halogen directory, run `bower install` to bring in all of the purescript dependencies.

`pulp server` ought to start up a webserver that you can hit at http://localhost:1337/test.html .

If you see hello world button, you're all set to go! It's probably a good idea to 
edit the Main.purs to a different hello world string and make sure your editor
is all good and that refreshing your browser brings that change into the app.

*VSCode Tip*: You'll want to have a vscode open in the actual halogen folder rather than in this entire project. The purescript IDE plugin starts the 
compiler server in the root of folder and will not find your installed
modules if you aren't in the halogen directory.

Pulp's webserver doesn't quite put enough headers on the app.js to convince it Chrome
not to cache app.js in memory. It's probably a good idea to have the debugging tools
open with cache disabled regardless of your browser. :)

# bubing [![Build Status](https://travis-ci.org/zhulik/bubing.svg?branch=master)](https://travis-ci.org/zhulik/bubing) [![Code Climate](https://codeclimate.com/github/zhulik/bubing/badges/gpa.svg)](https://codeclimate.com/github/zhulik/bubing) [![Test Coverage](https://codeclimate.com/github/zhulik/bubing/badges/coverage.svg)](https://codeclimate.com/github/zhulik/bubing/coverage)

## What is it?
Bubing is a tool for bundling linux applications for running it on every linux distribution. It bundles all app's
dependencies in one folder and creates run script for executable bundle(and some other features described below).
Bundled application or library can be run on all linux distros with kernel newer than 2.6.
Bundling tested on ArchLinux and Ubuntu in 32 and 64 bit architectures,
any other distros, probably, suitable too.

Command `file` must be available on your system!

*This is linux-only solution now, i have no requirement for bundling apps for MacOS or Windows, but this ports are welcome*

## Who need it?
If you developing proprietary software(executable or library) for linux and you must deploy it on outdated/old/exotic linux distributions or user's
machines, you need it.

## Usage

### Installation
Firstly, you must install ruby >= 2.0.0 (apt-get, rvm or any other way).

Then, install bubing gem

`gem install bubing`

That's all!

### Bundling through CLI

#### Bundling executable(vlc for example)

`bubing /bin/vlc vlc_bundle -P /usr/lib/vlc`

This command will create vlc_bundle directory, that contains bin and lib folders and script run.sh for running your app.
`-P /usr/lib/vlc` flag means that we want to add vlc plugins to our bundle, vlc folder can be found as vlc_bundle/lib/vlc, all
plugin's dependencies will be bundled too. All arguments to run.sh script will be passed to your app.

#### Bundling libraries(libvlc for example)

`bubing /lib/libvlc.so.5.5.0 libvlc_bundle -P /usr/lib/vlc -F /usr/include/vlc=include`

After that, libvlc_bundle directory will be created. It will contains lib and include folders. Plugins will be bundled the
same way as in executable bundle, include directory will contains copy of /usr/include/vlc folder.

#### CLI flags

* -p, --plugin LIBRARY - allows you to bundle only one plugin library, it will be placed in lib/ dir of your bundle, dependencies will be bundled
* -P, --plugin_directory PATH - allows you to bundle whole directory with plugins and it's dependencies
* -f, --file FILE=PATH - allows to bundle any other file to relative PATH in your bundle(configs, themes and other files)
* -F, --file_directory PATH=PATH - allows to bundle whole directory with files to relative PATH in your bundle
* -L, --ld_path PATH - adds PATH to LD_LIBRARY_PATH
* -e, --env VAR=VAL - allows to add environment variables to your run script
* -r - allows to rename default run.sh to any other name `-r execute.sh`
* -v - verbose output

### Bundling through ruby script with DSL

#### vlc example

```ruby
#!/usr/bin/env ruby

require 'bubing'

Bubing::configure do |c|
  c.binary '/bin/vlc'
  c.directory 'vlc_bundle'
#  c.add_plugin '<path to plugin file>'
  c.add_plugin_dir File.join('', 'lib', 'vlc')
#  c.add_file '<path to file>', '<relative path in bundle>'
#  c.add_file_dir '<path to dir>', '<relative path in bundle>'
  c.add_env 'VARIABLE', 'VALUE'
#  c.add_ld_path '<additional ld_path>'
  c.run_script 'vlc.sh'
  c.verbose!
end.bundle!
```

This script describes bundling vlc player in the same way as bundling from CLI.

## Contributing

You know=)


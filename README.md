# RRI

## Dependencies

- [lpaggreg library](https://github.com/bsc-performance-tools/lpaggreg)
- gcc 5
- qt, qt-devel (version 5 -- do not compile with version 4)
- qmake
- R

## Related tools

- [folding tool](https://github.com/bsc-performance-tools/folding). Requires version 1.2.1.

## Get the sources

    $ git clone https://github.com/bsc-performance-tools/RRI.git

## Go into the directory

    $ cd RRI

## Compile

*Edit* `options.pri` *to enable or disable the compilation of subsidiary functionalities and change the target directory and the dependency location*.

    $ qmake-qt5
    $ make

## Install

    $ make install

Missing R libraries will be automatically installed if you have enabled RRI-bin compilation. You can also manually install them. They are listed in `script/rri-install.R`.

## Apply RRI on a folding directory

    $ rri <folding-directory>

The output is generated by default in `<folding-directory>.rri`.

## Apply RRI on a callerdata file (command line program)

    $ rri -i <folding-directory>/<callerdata.file>

The output is generated by default in `<folding-directory>.rri`.

## Options:

      - -i --inputfile <file>: apply the process on a single callerdata file
      - -h --help: print usage
      - -o --output <directory>: output directory (rri by default)
      - -ts --timeslices [integer]: timeslice number used to discretize the time period (200 by default)
      - -th --threshold [float]: minimal distance between two parameters p (0.0001 by default)
      - -mp --minprop [float]: routine minimal proportion (0.8 by default)

## Generate graphs from RRI data

    $ rri-pdf <rri-directory>

## Options:

      - -h --help: Print help
      - -c --clean: Remove all the generated pdf
      - -s --size w h: Set pdf outputs width and height in inch (default: 12 6)
      - -d --dpi: Set pdf outputs dpi (default: 300)


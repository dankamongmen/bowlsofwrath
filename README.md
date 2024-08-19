These bowls and struts are sized to snugly contain [4L cereal containers](https://www.amazon.com/gp/product/B0CFLJCJSF),
commonly employed as [dry boxen](https://www.thingiverse.com/thing:6254854) for
FDM filament spools. They furthermore embed a [Honeycomb wall](https://www.printables.com/model/152592-honeycomb-storage-wall)
into each side, into which the struts (and any other Honeycomb-compatible
item) are inserted. The front and back support several configurations,
depending on taste.

Neither supports nor small layer heights are necessary. A .2mm layer height 
with a 0.4mm nozzle is more than adequate. A .3mm layer height with a 0.6mm
nozzle ought likewise be fine. I typically print the struts using
polycarbonate, and everything else with ABS or ASA.

The honeycomb walls are oriented to support external hookups on both sides.

More info is available on [Dankwiki](https://nick-black.com/dankwiki/index.php/Dank%27s_Magnificent_Bowls).

## How do I use this?

These are [OpenSCAD](https://openscad.org/) source files. You'll want to
open them in OpenSCAD, adjust any parameters as needed, render them to
STL, and open that using the slicer of your choice. You'll need the
[BOSL2](https://github.com/BelfrySCAD/BOSL2) and
[roundedcube](https://danielupshaw.com/openscad-rounded-corners/) OpenSCAD
libraries.

You'll need at least one [Bowl](dankbowl.scad). For each Bowl you want to
connect, you'll need four [struts](struts.scad).

## Files

* [bolts.scad](bolts.scad): bolts for holding in placards on the front/back
* [dankbowl.scad](dankbowl.scad): the main Bowl
* [struts.scad](struts.scad): struts for connecting Bowls

**FIXME** add placards/wallpiece

## TODO

* Support internal hookups + slits to allow internal struts. Most of the
  honeycombs ought still be oriented to support external items.
* Restore honeycomb in floor, but make it optional. Ought be oriented to
    support external hookups. That would suggest you can't use these for
    internal struts, but you can: the bottom one will be held in by gravity.
* Make unified "wall" placard that covers both halves.
* Adjust existing placards to accommodate internal chamfers.
* New placard for 30256 label.
* New placard for--you guessed it--honeycomb.
* Parameterize struts.
* Struts that connect horizontally in addition to vertically.
* Snap-in bolts.
* 3MF project files.

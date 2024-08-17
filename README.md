These bowls and struts are sized to snugly contain [4L cereal containers](https://www.amazon.com/gp/product/B0CFLJCJSF),
commonly employed as [dry boxen](https://www.thingiverse.com/thing:6254854) for
FDM filament spools. They furthermore embed a [Honeycomb wall](https://www.printables.com/model/152592-honeycomb-storage-wall)
into each side, into which the struts (and any other Honeycomb-compatible
item) are inserted. The front and back support several configurations,
depending on taste.

Neither supports nor small layer heights are necessary. A .2mm layer height 
with a 0.4mm nozzle is more than adequate. A .3mm layer height with a 0.6mm
nozzle ought likewise be fine.

The honeycomb walls are oriented to support external hookups on both sides.

## How do I use this?

These are [OpenSCAD](https://openscad.org/) source files. You'll want to
open them in OpenSCAD, adjust any parameters as needed, render them to
STL, and open that using the slicer of your choice.

## TODO

* Support internal hookups + slits to allow internal struts. At least one row
  of the Honeycomb walls ought still be oriented to support external items.
* Restore honeycomb in floor, maybe. If we do so, they ought be oriented to
  support external hookups. That would suggest you can't use these for internal
  struts, but you can, since the bottom one will be held in by gravity.
* Make unified "wall" placard that covers both halves.
* Parameterize struts
* Snap-in bolts
* 3MF project files

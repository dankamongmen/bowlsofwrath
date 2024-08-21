.PHONY: all clean

COMMON:=$(addsuffix .scad, dankbowl-constants hex)

STL:=$(addsuffix .stl, bolts dankbowl struts)

all: $(STL)

%.stl: %.scad $(COMMON)
	openscad -o $@ $<

clean:
	rm -rf $(STL)

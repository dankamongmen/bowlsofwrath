.PHONY: all clean

COMMON:=$(addsuffix .scad, dankbowl-constants hex)

STL:=$(addsuffix .stl, dankbowl fpanel-unified struts trashcan)

all: $(STL)

%.stl: %.scad $(COMMON)
	openscad -o $@ $<

clean:
	rm -rf $(STL)

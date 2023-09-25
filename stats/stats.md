# About statistiques

## Usage

Before your mapathon:

1. Install [Osmosis](https://github.com/osmosis-labs/osmosis)
2. Download the data in a fixed area in JOSM by using an Overpass query like this one:
```
[out:json];
{{geocodeArea:Saint-Barthélemy-de-Séchilienne}}->.searchArea;
nw(area.searchArea);
out body;
>;
out skel qt;
```
3. Save the downloaded data in a before.osm file
4. Run the script [cityStats.sh](cityStats.sh) with argument before.osm
5. The script create a CSV with stats collected by Osmosis
6. Rename this csv to before.csv

After your mapathon:

1. Redo steps 2, 3, 4, 5
2. Merge the 2 csv by using LibreOffice Calc or any other solution
3. You can also add a "diff" column to know how many features where added/removed
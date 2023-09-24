#!/bin/bash

# To use this script, install Omosis: https://github.com/openstreetmap/osmosis
# Use JOSM to download data for a given area. Here is an example :
# [out:json];
# {{geocodeArea:Saint-Barthélemy-de-Séchilienne}}->.searchArea;
# nw(area.searchArea);
# out body;
# >;
# out skel qt;
# Then save all the data into an osm file.
# Finaly, use the command ./cityStats.sh <file.osm> to get a CSV with all the stats of your osm file

# Check if exactly one argument was passed
if [ $# -ne 1 ]; then
    echo "Invalid number of arguments"
    echo "Usage: ./cityStats.sh <file.osm>"
    exit 1
fi

# Read the input file name from the command line argument
input_file=$1

# Print WIP
echo "Processing file '$input_file' ..."

# Get the start time
start_time=$(date +%s)

# Write CSV header
echo "Objects;Objects fr;Count" > output.csv

# Run Osmosis to count the number of highways in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways highway=* --write-xml - | egrep '<way ' | wc -l)
echo "Highways (way);Routes, pistes, etc.;$count" >> output.csv

# Run Osmosis to count the number of highways in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways highway=* --write-xml - | osmosis -q --read-xml - --tf accept-ways name=* --write-xml - | egrep '<way ' | wc -l)
echo "Highways with name (way);Routes avec nom;$count" >> output.csv

# Run Osmosis to count the number of driveway in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways service=driveway --write-xml - | egrep '<way ' | wc -l)
echo "Driveways;Allées;$count" >> output.csv

# Run Osmosis to count the number of highway=track in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways highway=track --write-xml - | egrep '<way ' | wc -l)
echo "Tracks;Pistes;$count" >> output.csv

# Run Osmosis to count the number of highway=path in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways highway=path --write-xml - | egrep '<way ' | wc -l)
echo "Paths;Chemins;$count" >> output.csv

# Run Osmosis to count the number of barrier=gate  in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes barrier=gate --write-xml - | egrep '<node ' | wc -l)
echo "Gates;Portails;$count" >> output.csv

# Run Osmosis to count the number of highways in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=* --write-xml - | egrep '<node ' | wc -l)
echo "Highways (node);Noeuds highway (panneaux, passages piétons);$count" >> output.csv

# Run Osmosis to count the number of highway=stop in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=stop --write-xml - | egrep '<node ' | wc -l)
echo "Stops;Panneaux de stop;$count" >> output.csv

# Run Osmosis to count the number of highway=give_way in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=give_way --write-xml - | egrep '<node ' | wc -l)
echo "Give ways;Cédez le passage;$count" >> output.csv

# Run Osmosis to count the number of bus_stop in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=bus_stop --write-xml - | egrep '<node ' | wc -l)
echo "Bus stops;Arrêt de bus;$count" >> output.csv

# Run Osmosis to count the number of crossing in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=crossing --write-xml - | egrep '<node ' | wc -l)
echo "Crossings;Passage piéton;$count" >> output.csv

# Run Osmosis to count the number of shop in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes shop=* --tf accept-ways shop=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Shops;Magasins;$count" >> output.csv

# Run Osmosis to count the number of amenity in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=* --tf accept-ways amenity=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Amenities;Aménités;$count" >> output.csv

# Run Osmosis to count the number of parking lots in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways amenity=parking --write-xml - | egrep '<way ' | wc -l)
echo "Parking ways;Parkings;$count" >> output.csv

# Run Osmosis to count the number of parking space lots in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=parking_space --tf accept-ways amenity=parking_space --write-xml - | egrep '<node |<way ' | wc -l)
echo "Parking spaces;Places de parking;$count" >> output.csv

# Run Osmosis to count the number of parking lots in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=parking --write-xml - | egrep '<node ' | wc -l)
echo "Parking nodes TODO convert to ways;Noeuds parking à convertir en way;$count" >> output.csv

# Run Osmosis to count the number of bicycle parking in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=bicycle_parking --tf accept-ways amenity=bicycle_parking --write-xml - | egrep '<node |<way ' | wc -l)
echo "Bicycle parkings;Parkings à vélo;$count" >> output.csv

# Run Osmosis to count the number of highway=cycleway in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways highway=cycleway --write-xml - | egrep '<way ' | wc -l)
echo "Cycleways;Pistes cyclables dédiées;$count" >> output.csv

# Run Osmosis to count the number of highway=cycleway in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways cycleway:both=* cycleway:right=* cycleway:left=* --write-xml - | egrep '<way ' | wc -l)
echo "Cyclelines;Lignes cyclables;$count" >> output.csv

# Run Osmosis to count the number of public bookcases in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=public_bookcase --tf accept-ways amenity=public_bookcase --write-xml - | egrep '<node |<way ' | wc -l)
echo "Public bookcases;Microbibliothèques;$count" >> output.csv

# Run Osmosis to count the number of public bookcases in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=library --tf accept-ways amenity=library --write-xml - | egrep '<node |<way ' | wc -l)
echo "Library;Bibliothèques;$count" >> output.csv

# Count the number of Places in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes place=* --tf accept-ways place=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Places (hamlet, village, ...);Lieux (hameaux, village, ...);$count" >> output.csv

# Count the number of buildings in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes building=* --tf accept-ways building=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Buildings;Bâtiments;$count" >> output.csv

# Count the number of chapel in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways building=chapel --write-xml - | egrep '<way ' | wc -l)
echo "Chapels;Chapelles;$count" >> output.csv

# Count the number of church in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways building=church --write-xml - | egrep '<way ' | wc -l)
echo "Churches;Églises;$count" >> output.csv

# Count the number of shelters in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways amenity=shelter --write-xml - | egrep '<way ' | wc -l)
echo "Shelters;Abris;$count" >> output.csv

# Count the number of barrier=wall in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways barrier=wall --write-xml - | egrep '<way ' | wc -l)
echo "Walls;Murs;$count" >> output.csv

# Count the number of barrier=hedge in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways barrier=hedge --write-xml - | egrep '<way ' | wc -l)
echo "Hedges;Haies;$count" >> output.csv

# Count the number of buildings in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes addr:housenumber=* --tf accept-ways addr:housenumber=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Housenumbers;Numéros de rue;$count" >> output.csv

# Run Osmosis to count the number of historic=memorial in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes historic=memorial --write-xml - | egrep '<node ' | wc -l)
echo "Memorials;Mémoriaux;$count" >> output.csv

# Run Osmosis to count the number of historic=wayside_cross in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes historic=wayside_cross --write-xml - | egrep '<node ' | wc -l)
echo "Wayside crosses;Croix historiques;$count" >> output.csv

# Count the number of man_made=cross in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes man_made=cross --write-xml - | egrep '<node ' | wc -l)
echo "Crosses (religion);Croix religieuses;$count" >> output.csv

# Run Osmosis to count the number of tourism=* in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes tourism=* --tf accept-ways tourism=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Tourism objects;Objets touristiques;$count" >> output.csv

# Count the number of drinking_water in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=drinking_water --tf accept-ways amenity=drinking_water --write-xml - | egrep '<node |<way ' | wc -l)
echo "Drinking water points;Points d'eau potable;$count" >> output.csv

# Count the number of drinking_water in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=recycling --tf accept-ways amenity=recycling --write-xml - | egrep '<node |<way ' | wc -l)
echo "Recycling containers;Containers de recyclage;$count" >> output.csv

# Count the number of drinking_water in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=school --tf accept-ways amenity=school --write-xml - | egrep '<node |<way ' | wc -l)
echo "Schools;Ecoles;$count" >> output.csv

# Count the number of amenity=post_box in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=post_box --tf accept-ways amenity=post_box --write-xml - | egrep '<node |<way ' | wc -l)
echo "Post boxes;Boites aux lettres jaunes;$count" >> output.csv

# Count the number of amenity=fountain  in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=fountain --write-xml - | egrep '<node ' | wc -l)
echo "Fountains;Fontaines;$count" >> output.csv

# Count the number of amenity=lavoir in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=lavoir --tf accept-ways amenity=lavoir --write-xml - | egrep '<node |<way ' | wc -l)
echo "Lavoirs;Lavoirs;$count" >> output.csv

# Count the number of amenity=toilets in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=toilets --tf accept-ways amenity=toilets --write-xml - | egrep '<node |<way ' | wc -l)
echo "Toilets;Toilettes;$count" >> output.csv

# Count the number of opening_hours in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes opening_hours=* --tf accept-ways opening_hours=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Opening hours objects;Objets avec horaires d'ouverture;$count" >> output.csv

# Count the number of information=board in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes information=board --write-xml - | egrep '<node ' | wc -l)
echo "Information boards;Panneaux d'information;$count" >> output.csv

# Count the number of amenity=bench in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=bench --write-xml - | egrep '<node ' | wc -l)
echo "Benches;Bancs;$count" >> output.csv

# Count the number of highway=street_lamp in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes highway=street_lamp --write-xml - | egrep '<node ' | wc -l)
echo "Street lamps;Lampadaires;$count" >> output.csv

# Count the number of amenity=waste_basket in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=waste_basket --tf accept-ways amenity=waste_basket --write-xml - | egrep '<node |<way ' | wc -l)
echo "Waste baskets;Poubelles pour piétons;$count" >> output.csv

# Count the number of amenity=waste_basket in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes amenity=waste_disposal --tf accept-ways amenity=waste_disposal --write-xml - | egrep '<node |<way ' | wc -l)
echo "Waste disposal;Container poubelle;$count" >> output.csv

# Count the number of tourism=viewpoint in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes tourism=viewpoint --write-xml - | egrep '<node ' | wc -l)
echo "Viewpoints;Points de vue;$count" >> output.csv

# Count the number of tourism=viewpoint in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes natural=tree --write-xml - | egrep '<node ' | wc -l)
echo "Trees;Arbres;$count" >> output.csv

# Count the number of tourism=viewpoint in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-ways natural=tree_row --write-xml - | egrep '<way ' | wc -l)
echo "Tree rows;Rangées d'arbres;$count" >> output.csv

# Count the number of information=guidepost in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes information=guidepost --write-xml - | egrep '<node ' | wc -l)
echo "Guideposts;Panneaux de randonnée/vélo;$count" >> output.csv

# Count the number of information=map in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes information=map --write-xml - | egrep '<node ' | wc -l)
echo "Maps;Cartes/plans;$count" >> output.csv

# Count the number of information=map in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes leisure=picnic_table --write-xml - | egrep '<node ' | wc -l)
echo "Picnic tables;Tables de pique-nique;$count" >> output.csv

# Count the number of information=map in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes leisure=playground --tf accept-ways leisure=playground --write-xml - | egrep '<node |<way ' | wc -l)
echo "Playgrounds;Aires de jeux;$count" >> output.csv

# Count the number of information=map in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes leisure=pitch --tf accept-ways leisure=pitch --write-xml - | egrep '<node |<way ' | wc -l)
echo "Pitches;Terrains/Equipements sportifs;$count" >> output.csv

# Count the number of information=map in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes leisure=swimming_pool --tf accept-ways leisure=swimming_pool --write-xml - | egrep '<node |<way ' | wc -l)
echo "Swimming pools;Piscines;$count" >> output.csv

# Count the number of emergency=fire_hydrant in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes emergency=fire_hydrant --write-xml - | egrep '<node ' | wc -l)
echo "Fire hydrants;Bouches à incendie;$count" >> output.csv

# Run Osmosis to count the number of craft=* in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes craft=* --tf accept-ways craft=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Crafts;Artisans;$count" >> output.csv

# Run Osmosis to count the number of fixme=* in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes fixme=* --tf accept-ways fixme=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Fixmes;Fixmes;$count" >> output.csv

# Run Osmosis to count the number of fixme=* in the input file
count=$(osmosis -q --read-xml $input_file --tf accept-nodes wikidata=* --tf accept-ways wikidata=* --write-xml - | egrep '<node |<way ' | wc -l)
echo "Wikidata objects;Objets Wikidata;$count" >> output.csv

# Print the path of the output file
echo "The output has been written to $(pwd)/output.csv"

# Get the end time
end_time=$(date +%s)

# Calculate the duration
duration=$((end_time - start_time))

# Print Execution time
echo "Execution time: $duration seconds"

# Print content of CSV file
#echo "Content of CSV file:"
#cat output.csv

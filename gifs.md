# About the compare gifs

## Pre-requisites

Before your mapathon:

1. Go on http://bigmap.osmz.ru
2. Select the area you want to screenshot
3. Generate all the images you need
4. For each image, give it an id like 001, 002 and save each bigmap url in a CSV (see [screenshots.csv](screenshots.csv))
5. Save all thoses images in a src folder with a "a" suffix. The "a" mark the images generated before the mapathon

After your mapathon, you have to generate the "b" images. And then merge a and b in an animated gif.

To do so, either you do it manually or you use my scripts:

1. Use the [get_files.py](get_files.py) to download the b images according to your [screenshots.csv](screenshots.csv)
2. Run get_files.py multiple times, until bigmap generated all the "b" images and the script save them all
3. Move the "b" images from folder "out" to folder "src" (to paste them near the "a" images)
4. Run the script [make_gif.py](make_gif.py) to create the animated gifs
5. The gifs are generated in the "gif" folder
6. Done!

Note the "a" images will be anoted "Avant" and the "b" images "Après". Feel free to change this in the make_gif.py script.

## Automatic method 👍️

Here you can find the script I wrote to generate the gifs:
- [get_files.py](get_files.py): this script will query bigmap to ask map generation. Then you have to wait until bigmap created all the asked images. By running this script again, it will download the images and save them with the given suffix (a or b)
- [make_gif.py](make_gif.py): this script take 2 png with suffix (a and b). Add a caption (avant/après) into them. And merge them together in an animated gif.

## Manual method

Here are several usefull commands.

### Open in browser

xdg-open "http://bigmap.osmz.ru/bigmap.php?xmin=8456&xmax=8459&ymin=5890&ymax=5892&zoom=14&scale=256&tiles=humanitarian&action=enqueue" && sleep 1

### Add comment

```sh
mkdir tmp
magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Avant" src/001a.png tmp/001a.png
magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Après" src/001b.png tmp/001b.png
```

### Make gif

```sh
mkdir gif
magick convert -loop 0 -delay 200 tmp/01a.png tmp/01b.png gif/CartoStBarth2023-01.gif
```

### With a loop
```sh
mkdir tmp
mkdir gif
for i in `seq -w 1 24`
do
    echo "Image ${i}..."
    magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Avant" ${i}a.png tmp/${i}a.png
    magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Après" ${i}b.png tmp/${i}b.png
    magick convert -loop 0 -delay 200 tmp/${i}a.png tmp/${i}b.png gif/CartoStBarth2023-${i}.gif
done
```

### Crop images
```sh
magick convert 15a.png -crop 75x40%+600+1500 +repage 151a.png
magick convert 15b.png -crop 75x40%+600+1500 +repage 151b.png

magick convert 18a.png -crop 75x40%+200+600 +repage 181a.png
magick convert 18b.png -crop 75x40%+200+600 +repage 181b.png

magick convert 19a.png -crop 75x40%+0+0 +repage 191a.png
magick convert 19b.png -crop 75x40%+0+0 +repage 191b.png

magick convert 19a.png -crop 75x40%+200+600 +repage 192a.png
magick convert 19b.png -crop 75x40%+200+600 +repage 192b.png

for i in 151 181 191 192
# copy previous for bloc
```
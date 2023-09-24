# pip install requests beautifulsoup4

import csv
import os
import subprocess


# Script parameters
csv_file = 'screen_paul.csv'

# Read the CSV file
with open(csv_file, newline='') as csvfile:
    reader = csv.reader(csvfile)

    # Loop through the CSV lines
    for row in reader:
        id_value = row[0]

        print (f'Processing {id_value}')

        # Create the "tmp" folder if it doesn't exist
        if not os.path.exists("tmp"):
            os.makedirs("tmp")

        # Create the "gif" folder if it doesn't exist
        if not os.path.exists("gif_paul"):
            os.makedirs("gif_paul")

        # Add before (Avant) caption on picture
        cmd = f'magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Avant" src_paul/{id_value}a.png tmp/{id_value}a.png'
        subprocess.run(cmd, shell=True)

        # Add before (Avant) caption on picture
        cmd = f'magick convert -gravity NorthWest -pointsize 30 -undercolor yellow -annotate +10+10 "Après" src_paul/{id_value}b.png tmp/{id_value}b.png'
        subprocess.run(cmd, shell=True)

        if os.path.exists(f'tmp/{id_value}a.png') and os.path.exists(f'tmp/{id_value}b.png'):
            # Create the gif
            cmd = f'magick convert -loop 0 -delay 200 tmp/{id_value}a.png tmp/{id_value}b.png gif_paul/CartoSBDSPaul-{id_value}.gif'
            subprocess.run(cmd, shell=True)
    
    print('Done')
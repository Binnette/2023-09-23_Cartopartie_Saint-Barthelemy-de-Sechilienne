# pip install requests beautifulsoup4

import csv
import requests
from bs4 import BeautifulSoup
from datetime import datetime
import re
import os


# Script parameters
csv_file = 'screenshots.csv'
png_suffix = 'b'
bigmap_url = 'http://bigmap.osmz.ru/'


# Read the CSV file
with open(csv_file, newline='') as csvfile:
    reader = csv.reader(csvfile)

    # Loop through the CSV lines
    for row in reader:
        id_value = row[0]
        url = row[1] + '&action=enqueue'

        # Send a GET request to the URL and retrieve the HTML content
        response = requests.get(url)
        html_content = response.text

        # Parse the HTML content using BeautifulSoup
        soup = BeautifulSoup(html_content, "html.parser")

        # Find the first <h1> block and extract its content as text
        h1_block = soup.find("h1")
        h1_text = h1_block.get_text()

        # Parse the text value using a regular expression to extract the desired value
        pattern = r"Task (.*):"
        match = re.search(pattern, h1_text)
        if match:
            extracted_value = match.group(1)
        else:
            extracted_value = None

        # Put the extracted value in a variable (e.g., id_value)
        task_id = extracted_value

        # Do something with the extracted value (e.g., print it)
        print(f"ID: {id_value}, Task id: {task_id}, Url: {url}")

        # Get the current date
        today = datetime.today()

        # Format the date as dd.mm.yy
        formatted_date = today.strftime("%d.%m.%y")
        #print(f"The current date is: {formatted_date}")

        # Let's check if a screenshot exist for today
        if formatted_date in html_content:
            # Today screenshot exist, so let's download it
            print(" - Today screenshot found.")

            # Create the "out" folder if it doesn't exist
            if not os.path.exists("out"):
                os.makedirs("out")

            # Define the filename
            filename = f"{id_value}{png_suffix}.png"

            # Test if the file already exist
            filepath = os.path.join("out", filename)

            if os.path.exists(filepath):
                print(f" - The file {filename} already exists. Ignore download")
                continue
            else:
                print(f" - The file {filename} does not exist. Continue with downloading")

            # Find all links in the HTML content
            links = soup.find_all("a")

            # Loop through the links and test their content
            for link in links:
                link_url = link["href"]
                link_text = link.get_text()
                if formatted_date in link_text and 'png' in link_url:
                    # Download the screenshot and save it in a file
                    download_url = bigmap_url + link_url
                    print(' - Downloading: ' + download_url)

                    # Send a GET request to the URL and retrieve the file content
                    response = requests.get(download_url)
                    file_content = response.content

                    # Save the file content to the custom filename in the "out" folder
                    with open(filepath, "wb") as f:
                        f.write(file_content)

                    print(f" - The file has been saved as {filename} in the 'out' folder.")

        elif 'Restart task' in html_content:
            print(" - Today screenshot not found. But we can restart the image generation")
            # Calling the restart
            #queue.php?task=lzq304676091&restart=1"
            restart_url = bigmap_url + 'queue.php?task=' + task_id + '&restart=1'
            print(' - Calling restart: ' + restart_url)
            requests.get(restart_url)
        else:
            print(" - Today screenshot not found. And we can not restart processing. So try later.")

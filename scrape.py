from bs4 import BeautifulSoup as soup  # HTML data structure
from urllib.request import urlopen as uReq  # Web client


# name the output file to write to local disk
out_filename = "expiration.csv"
# header of csv file to be written
headers = "name,pantry,refrigerator,freezer \n"

# opens file, and writes headers
f = open(out_filename, "w")
f.write(headers)
for x in range(16000, 20000):
    # URl to web scrap from.
    # in this example we web scrap graphics cards from Newegg.com
    page_url = "https://stilltasty.com/Fooditems/index/"+str(x)

    # opens the connection and downloads html page from url
    uClient = uReq(page_url)

    # parses html into a soup data structure to traverse html
    # as if it were a json data type.
    page_soup = soup(uClient.read(), "html.parser")
    uClient.close()

    # finds each product from the store page
    container1 = page_soup.findAll("div", {"class": "food-storage-right image1"})
    container2 = page_soup.findAll("div", {"class": "food-storage-right image2"})
    container3 = page_soup.findAll("div", {"class": "food-storage-right image3"})
    namec = page_soup.findAll("div",{"class": "food-storage-container"})


    # loops over each product and grabs attributes about
    # each product
    if len(container1)!=0 or len(container2)!=0 or len(container3)!=0:
        if len(container1) == 0:
            pantry = "0"
        else:
            c1 = container1[0].findAll("div",{"class": "red-image clearfix"})
            pantry = c1[0].span.text.replace('\r', '').replace('\t', '').replace(' ', '')
        if len(container2) == 0:
            refrigerator = "0"
        else:
            c2 = container2[0].findAll("div", {"class": "red-image clearfix"})
            refrigerator  = c2[0].span.text.replace('\r', '').replace('\t', '').replace(' ', '')
        if len(container3) == 0:
            freezer = "0"
        else:
            c3 = container3[0].findAll("div", {"class": "red-image clearfix"})
            freezer = c3[0].span.text.replace('\r', '').replace('\t', '').replace(' ', '')
            # prints the dataset to console
        name=namec[0].h2.text.replace('\r', '').replace('\t', '').replace(',', ' ')

            # writes the dataset to file
        f.write(name + ", " + pantry + ", " + refrigerator + ", "+ freezer+ "\n")
    print(x)
f.close()  # Close the file

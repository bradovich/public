import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


dist = '1.5'
hh = '00'
mm = '16'
ss = '30'

url = "https://runsmartproject.com/calculator/"
driver = webdriver.Chrome()
driver.get(url)

time.sleep(0.01)

distance_path = '//*[(@id = "cDistance")]'
distance = driver.find_element_by_xpath(distance_path)
for i in range(10):
    distance.send_keys(Keys.LEFT)
distance.send_keys(dist)

time.sleep(0.01)

hours_path = '//*[(@id = "hr")]'
hours = driver.find_element_by_xpath(hours_path)
for i in range(2):
    hours.send_keys(Keys.LEFT)
hours.send_keys(hh)

time.sleep(0.01)

minutes_path = '//*[(@id = "min")]'
minutes = driver.find_element_by_xpath(minutes_path)
for i in range(2):
    minutes.send_keys(Keys.LEFT)
minutes.send_keys(mm)

time.sleep(0.01)

seconds_path = '//*[(@id = "sec")]'
seconds = driver.find_element_by_xpath(seconds_path)
for i in range(2):
    seconds.send_keys(Keys.LEFT)
seconds.send_keys(ss)

time.sleep(0.01)

calculate_path = '//*[(@id = "btnCalculate")]'
driver.find_element_by_xpath(calculate_path).click()

time.sleep(0.01)

vdot_path = '//*[(@id = "vdot")]'
vdot = driver.find_element_by_xpath(vdot_path)
vdot_value = vdot.text

print("VDot: ", vdot_value)

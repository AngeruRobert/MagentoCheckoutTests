import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select, WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys

from Data import *
from Locators import *

@pytest.fixture(scope="function")
def browser():
    driver = webdriver.Chrome()
    driver.get(Url)
    driver.maximize_window()
    driver.implicitly_wait(10)
    yield driver
    driver.quit()

def wait_until_visible(driver, locator):
    return WebDriverWait(driver, 5).until(EC.visibility_of_element_located((By.XPATH, locator)))

def scroll_into_view(driver, locator):
    element = driver.find_element(By.XPATH, locator)
    driver.execute_script("arguments[0].scrollIntoView();", element)

def accept_cookies(driver):
    wait_until_visible(driver, cookie_accept_button_locator).click()

def navigate_to_product_page(driver):
    scroll_into_view(driver, item1_locator)
    driver.find_element(By.XPATH, item1_locator).click()
    WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.TAG_NAME, "body"), "Radiant Tee"))

def try_adding_zero_quantity(driver):
    quantity_input = driver.find_element(By.XPATH, item1_quantity_locator)
    quantity_input.clear()
    quantity_input.send_keys("0")
    scroll_into_view(driver, item1_add_from_product_locator)
    driver.find_element(By.XPATH, item1_add_from_product_locator).click()
    wait_until_visible(driver, quantity_error_locator)

def try_adding_out_of_stock(driver):
    scroll_into_view(driver, item1_quantity_locator)
    driver.find_element(By.XPATH, item1_quantity_locator).send_keys("1")
    driver.find_element(By.XPATH, item1_xssize_from_product_locator).click()
    driver.find_element(By.XPATH, item1_color_locator_from_product_locator).click()
    scroll_into_view(driver, item1_add_from_product_locator)
    driver.find_element(By.XPATH, item1_add_from_product_locator).click()
    wait_until_visible(driver, stock_error_locator)

def add_product_from_homepage(driver):
    scroll_into_view(driver, item1_locator)
    driver.find_element(By.XPATH, item1_size_locator).click()
    driver.find_element(By.XPATH, item1_color_locator).click()
    ActionChains(driver).move_to_element(driver.find_element(By.XPATH, item1_img_locator)).perform()
    wait_until_visible(driver, item1_add_locator).click()

def add_product_from_product_page(driver):
    driver.find_element(By.XPATH, item1_size_from_product_locator).click()
    driver.find_element(By.XPATH, item1_color_locator_from_product_locator).click()
    scroll_into_view(driver, item1_add_from_product_locator)
    driver.find_element(By.XPATH, item1_add_from_product_locator).click()
    WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.TAG_NAME, "body"), "You added Radiant Tee to your shopping cart."))

def proceed_to_checkout(driver):
    scroll_into_view(driver, cart_counter_locator)
    wait_until_visible(driver, cart_counter_locator)
    assert driver.find_element(By.XPATH, cart_counter_locator).text == "1"
    driver.find_element(By.XPATH, cart_locator).click()
    wait_until_visible(driver, cart_top_locator).click()
    WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.TAG_NAME, "body"), "Shipping Address"))

def fill_shipping_form_invalid(driver):
    WebDriverWait(driver, 5).until(EC.invisibility_of_element((By.XPATH, loading_mask_locator)))
    driver.find_element(By.XPATH, email_locator).send_keys(email_negative + Keys.RETURN)
    wait_until_visible(driver, email_error_locator)

    driver.find_element(By.XPATH, next_button_locator).click()
    wait_until_visible(driver, shipping_error_locator)

    driver.find_element(By.XPATH, shipping_locator).click()
    driver.find_element(By.XPATH, next_button_locator).click()

    wait_until_visible(driver, firstname_error_locator)
    wait_until_visible(driver, lastname_error_locator)
    wait_until_visible(driver, address_error_locator)
    wait_until_visible(driver, city_error_locator)
    scroll_into_view(driver, region_locator)
    wait_until_visible(driver, state_error_locator)
    wait_until_visible(driver, postcode_error_locator)
    wait_until_visible(driver, phone_error_locator)

def fill_shipping_form_valid(driver):
    WebDriverWait(driver, 5).until(EC.invisibility_of_element((By.XPATH, loading_mask_locator)))
    driver.find_element(By.XPATH, email_locator).send_keys(email)
    driver.find_element(By.XPATH, firstname_locator).send_keys(fname)
    driver.find_element(By.XPATH, lastname_locator).send_keys(lname)
    driver.find_element(By.XPATH, company_locator).send_keys(company)
    driver.find_element(By.XPATH, address_locator).send_keys(address)
    driver.find_element(By.XPATH, city_locator).send_keys(city)
    Select(driver.find_element(By.XPATH, region_locator)).select_by_value("2")
    driver.find_element(By.XPATH, postcode_locator).send_keys(postcode)
    driver.find_element(By.XPATH, phone_locator).send_keys(phone)
    driver.find_element(By.XPATH, shipping_locator).click()
    driver.find_element(By.XPATH, next_button_locator).click()

def proceed_to_payment(driver):
    WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.TAG_NAME, "body"), "Payment Method"))
    WebDriverWait(driver, 5).until(EC.invisibility_of_element((By.XPATH, loading_mask_locator)))
    driver.find_element(By.XPATH, place_order_locator).click()

def confirm_order_success(driver):
    WebDriverWait(driver, 5).until(EC.text_to_be_present_in_element((By.TAG_NAME, "body"), "Thank you for your purchase!"))

# === TEST CASES ===

def test_successful_checkout_from_homepage(browser):
    accept_cookies(browser)
    add_product_from_homepage(browser)
    proceed_to_checkout(browser)
    fill_shipping_form_valid(browser)
    proceed_to_payment(browser)
    confirm_order_success(browser)

def test_successful_checkout_from_product_page(browser):
    accept_cookies(browser)
    navigate_to_product_page(browser)
    add_product_from_product_page(browser)
    proceed_to_checkout(browser)
    fill_shipping_form_valid(browser)
    proceed_to_payment(browser)
    confirm_order_success(browser)

def test_invalid_quantity_and_out_of_stock(browser):
    accept_cookies(browser)
    navigate_to_product_page(browser)
    try_adding_zero_quantity(browser)
    try_adding_out_of_stock(browser)

def test_shipping_form_validation_errors(browser):
    accept_cookies(browser)
    add_product_from_homepage(browser)
    proceed_to_checkout(browser)
    fill_shipping_form_invalid(browser)

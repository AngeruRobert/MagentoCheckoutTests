*** Settings ***
Library  Selenium2Library
Variables  Data.py
Variables  Locators.py
Test Setup  User opens website  ${Url}
Test Teardown  Close All Browsers



*** Variables ***

*** Test Cases ***
User Adds Item to cart from home page
    Accept Cookies
    User adds item to cart
    Verify Cart and Go to Shipping Page
    Complete Form from Shipping Page
    Go to Payment Page
    Payment Information

*** Keywords ***
User opens website
    [Arguments]  ${url}
    Open Browser  ${url}  ${Browser}
    Maximize Browser Window

Scroll To Element
    [Arguments]  ${locator}
    ${x}=        Get Horizontal Position  ${locator}
    ${y}=        Get Vertical Position    ${locator}
    Execute Javascript  window.scrollTo(${x}, ${y})

Accept Cookies
    Click Element   xpath=${cookie_accept_button_locator}

User adds item to cart
    Scroll To Element   xpath=${item1_locator}
    Click Element   xpath=${item1_size_locator}
    Click Element   xpath=${item1_color_locator}
    Mouse Over  xpath=${item1_img_locator}
    Wait Until Element Is Visible   xpath=${item1_add_locator}
    Click Element   xpath=${item1_add_locator}
Verify Cart and Go to Shipping Page
    Wait Until Element Is Visible    xpath=${cart_counter_locator}
    Element Text Should Be           xpath=${cart_counter_locator}    1
    Wait Until Element Is Visible  xpath=${cart_locator}
    Click Element   xpath=${cart_locator}
    Wait Until Element Is Visible   xpath=${cart_top_locator}
    Click Element   xpath=${cart_top_locator}
    Wait Until Page Contains    Shipping Address  20s
Complete Form from Shipping Page
    Wait Until Element Is Visible   xpath=${email_locator}
    Input Text  xpath=${email_locator}     ${email}
    Wait Until Element Is Visible   xpath=${firstname_locator}
    Input Text  xpath=${firstname_locator}  ${fname}
    Input Text  xpath=${lastname_locator}  ${lname}
    Input Text  xpath=${company_locator}   ${company}
    Input Text  xpath=${adress_locator}  ${adress}
    Input Text  xpath=${city_locator}    ${city}
    Select From List By Value  xpath=${region_locator}   2
    Input Text  xpath=${postcode_locator}   ${postcode}
    Input Text  xpath=${phone_locator}  ${phone}
    Click Element   xpath=${shipping_locator}
    Click Button    xpath=${next_button_locator}
Go to Payment Page
    Wait Until Page Contains    Payment Method  20s
    Wait Until Element Is Not Visible   xpath=${loading_mask_locator}
    Click Element    xpath=${place_order_locator}
Payment Information
    Wait Until Page Contains    Thank you for your purchase!  20s



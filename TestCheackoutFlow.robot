*** Settings ***
Library           Selenium2Library
Variables         Data.py
Variables         Locators.py
Test Setup        Open Browser To Site    ${Url}
Test Teardown     Close All Browsers
Suite Teardown    Close All Browsers

*** Test Cases ***
User Can Successfully Complete Checkout
    Accept Cookies
    Add Product To Cart
    Proceed To Checkout
    Fill Shipping Form
    Proceed To Payment
    Confirm Order

*** Keywords ***
Open Browser To Site
    [Arguments]    ${url}
    Open Browser    ${url}    ${Browser}
    Maximize Browser Window
    Set Selenium Timeout    10s

Scroll Element Into View
    [Arguments]    ${locator}
    ${x}=    Get Horizontal Position    ${locator}
    ${y}=    Get Vertical Position      ${locator}
    Execute Javascript    window.scrollTo(${x}, ${y})

Accept Cookies
    Wait Until Element Is Visible    xpath=${cookie_accept_button_locator}
    Click Element    xpath=${cookie_accept_button_locator}

Add Product To Cart
    Scroll Element Into View    xpath=${item1_locator}
    Click Element               xpath=${item1_size_locator}
    Click Element               xpath=${item1_color_locator}
    Mouse Over                  xpath=${item1_img_locator}
    Wait Until Element Is Visible    xpath=${item1_add_locator}
    Click Element               xpath=${item1_add_locator}

Proceed To Checkout
    Wait Until Element Is Visible        xpath=${cart_counter_locator}
    Element Text Should Be               xpath=${cart_counter_locator}    1
    Wait Until Element Is Visible        xpath=${cart_locator}
    Click Element                        xpath=${cart_locator}
    Wait Until Element Is Visible        xpath=${cart_top_locator}
    Click Element                        xpath=${cart_top_locator}
    Wait Until Page Contains             Shipping Address    timeout=20s

Fill Shipping Form
    Wait Until Element Is Visible        xpath=${email_locator}
    Input Text                           xpath=${email_locator}          ${email}
    Input Text                           xpath=${firstname_locator}      ${fname}
    Input Text                           xpath=${lastname_locator}       ${lname}
    Input Text                           xpath=${company_locator}        ${company}
    Input Text                           xpath=${adress_locator}         ${adress}
    Input Text                           xpath=${city_locator}           ${city}
    Select From List By Value            xpath=${region_locator}         2
    Input Text                           xpath=${postcode_locator}       ${postcode}
    Input Text                           xpath=${phone_locator}          ${phone}
    Click Element                        xpath=${shipping_locator}
    Click Button                         xpath=${next_button_locator}

Proceed To Payment
    Wait Until Page Contains             Payment Method    timeout=20s
    Wait Until Element Is Not Visible    xpath=${loading_mask_locator}
    Click Element                        xpath=${place_order_locator}

Confirm Order
    Wait Until Page Contains             Thank you for your purchase!    timeout=20s

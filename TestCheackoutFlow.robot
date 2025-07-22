*** Settings ***
Library           Selenium2Library
Variables         Data.py
Variables         Locators.py
Test Setup        Open Browser To Site    ${Url}
Test Teardown     Close All Browsers
Suite Teardown    Close All Browsers

*** Test Cases ***
Successful Checkout From Home Page
    Accept Cookies
    Add Product To Cart From Homepage
    Proceed To Checkout
    Fill Shipping Form With Valid Data
    Proceed To Payment
    Confirm Order Success

Successful Checkout From Product Page
    Accept Cookies
    Navigate To Product Page
    Add Product To Cart From Product Page
    Proceed To Checkout
    Fill Shipping Form With Valid Data
    Proceed To Payment
    Confirm Order Success

Invalid Quantity And Out Of Stock Handling
    Accept Cookies
    Navigate To Product Page
    Try Adding Zero Quantity
    Try Adding Out Of Stock Product

Shipping Form Validation Errors
    Accept Cookies
    Add Product To Cart From Homepage
    Proceed To Checkout
    Fill Shipping Form With Invalid Data

*** Keywords ***

Open Browser To Site
    [Arguments]    ${url}
    Open Browser    ${url}    ${Browser}
    Maximize Browser Window
    Set Selenium Timeout    10s

Accept Cookies
    Wait Until Element Is Visible    xpath=${cookie_accept_button_locator}
    Click Element                    xpath=${cookie_accept_button_locator}

Scroll Element Into View
    [Arguments]    ${locator}
    ${x}=    Get Horizontal Position    ${locator}
    ${y}=    Get Vertical Position      ${locator}
    Execute Javascript    window.scrollTo(${x}, ${y})

Navigate To Product Page
    Scroll Element Into View    xpath=${item1_locator}
    Click Element               xpath=${item1_locator}
    Wait Until Page Contains    Radiant Tee    timeout=20s

Try Adding Zero Quantity
    Input Text                  xpath=${item1_quantity_locator}    0
    Scroll Element Into View    xpath=${item1_add_from_product_locator}
    Click Element               xpath=${item1_add_from_product_locator}
    Wait Until Element Is Visible    xpath=${quantity_error_locator}
    Element Should Be Visible        xpath=${quantity_error_locator}

Try Adding Out Of Stock Product
    Scroll Element Into View    xpath=${item1_quantity_locator}
    Input Text                  xpath=${item1_quantity_locator}    1
    Click Element               xpath=${item1_xssize_from_product_locator}
    Click Element               xpath=${item1_color_locator_from_product_locator}
    Scroll Element Into View    xpath=${item1_add_from_product_locator}
    Click Element               xpath=${item1_add_from_product_locator}
    Wait Until Element Is Visible    xpath=${stock_error_locator}
    Element Should Be Visible        xpath=${stock_error_locator}

Add Product To Cart From Product Page
    Click Element               xpath=${item1_size_from_product_locator}
    Click Element               xpath=${item1_color_locator_from_product_locator}
    Scroll Element Into View    xpath=${item1_add_from_product_locator}
    Click Element               xpath=${item1_add_from_product_locator}
    Wait Until Page Contains    You added Radiant Tee to your shopping cart.

Add Product To Cart From Homepage
    Scroll Element Into View    xpath=${item1_locator}
    Click Element               xpath=${item1_size_locator}
    Click Element               xpath=${item1_color_locator}
    Mouse Over                  xpath=${item1_img_locator}
    Wait Until Element Is Visible    xpath=${item1_add_locator}
    Click Element               xpath=${item1_add_locator}

Proceed To Checkout
    Scroll Element Into View    xpath=${cart_counter_locator}
    Wait Until Element Is Visible    xpath=${cart_counter_locator}
    Element Text Should Be           xpath=${cart_counter_locator}    1
    Click Element                   xpath=${cart_locator}
    Wait Until Element Is Visible   xpath=${cart_top_locator}
    Click Element                   xpath=${cart_top_locator}
    Wait Until Page Contains        Shipping Address    timeout=20s

Fill Shipping Form With Invalid Data
    Wait Until Element Is Not Visible    xpath=${loading_mask_locator}
    Input Text    xpath=${email_locator}    ${email_negative}
    Press Keys    xpath=${email_locator}    RETURN
    Element Should Be Visible    xpath=${email_error_locator}

    Click Button    xpath=${next_button_locator}
    Element Should Be Visible    xpath=${shipping_error_locator}

    Click Element    xpath=${shipping_locator}
    Click Button     xpath=${next_button_locator}

    Element Should Be Visible    xpath=${firstname_error_locator}
    Element Should Be Visible    xpath=${lastname_error_locator}
    Element Should Be Visible    xpath=${address_error_locator}
    Element Should Be Visible    xpath=${city_error_locator}
    Scroll Element Into View     xpath=${region_locator}
    Element Should Be Visible    xpath=${state_error_locator}
    Element Should Be Visible    xpath=${postcode_error_locator}
    Element Should Be Visible    xpath=${phone_error_locator}

Fill Shipping Form With Valid Data
    Wait Until Element Is Not Visible    xpath=${loading_mask_locator}
    Input Text    xpath=${email_locator}       ${email}
    Input Text    xpath=${firstname_locator}   ${fname}
    Input Text    xpath=${lastname_locator}    ${lname}
    Input Text    xpath=${company_locator}     ${company}
    Input Text    xpath=${address_locator}     ${address}
    Input Text    xpath=${city_locator}        ${city}
    Select From List By Value    xpath=${region_locator}    2
    Input Text    xpath=${postcode_locator}    ${postcode}
    Input Text    xpath=${phone_locator}       ${phone}
    Click Element    xpath=${shipping_locator}
    Click Button     xpath=${next_button_locator}

Proceed To Payment
    Wait Until Page Contains          Payment Method    timeout=20s
    Wait Until Element Is Not Visible    xpath=${loading_mask_locator}
    Click Element                        xpath=${place_order_locator}

Confirm Order Success
    Wait Until Page Contains    Thank you for your purchase!    timeout=20s

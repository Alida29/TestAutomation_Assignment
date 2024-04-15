*** Settings ***
Documentation       Keywords collection for all test cases
Library             Hook.py
Library             Collections

*** Keywords ***
Sign up a new user
    [Arguments]     ${name}    ${password}
    ${params}       Create Dictionary    name=${name}   passwd=${password}
    ${response}     post request    ${ENV_SIGNUP_URL}/signup    ${params}

Register the same user twice
    [Arguments]     ${name}    ${password}
    Sign up a new user      name=test123      password=test_password
    Sign up a new user      name=test123      password=test_password

Renew token for user
    [Arguments]     ${random_name}
    ${random_name}       Create Dictionary    name=${random_name}
    ${response}     patch request    ${ENV_SIGNUP_URL}/renew    ${random_name}

Renew token for unregistered user
    [Arguments]     ${random_name}
    ${random_name}       Create Dictionary    name=${random_name}
    ${response}     patch request    ${ENV_SIGNUP_URL}/renew    ${random_name}

Get User Token
    [Arguments]     ${random_name}    ${password}
    Sign up a new user    ${random_name}    ${password}
    ${token}   extract token   text=${response.text}
    Set test variable     ${token}     ${token}

Get user information
    [Arguments]     ${token}
    ${params}       Create Dictionary    token=${token}
    ${response}     get request    ${ENV_SIGNUP_URL}/user    ${params}

Validate provided token is valid
    [Arguments]     ${token}
    ${params}       Create Dictionary    token=${token}
    ${response}     get request    ${ENV_SIGNUP_URL}/validate    ${params}

Validate provided token is invalid
    [Arguments]     ${invalid_token}
    ${params}       Create Dictionary    token=${invalid_token}
    ${invalid_token}    get request    ${ENV_SIGNUP_URL}/validate    ${params}

Generate quote
    [Arguments]     ${token}
    ${params}       Create Dictionary    token=${token}
    ${response}     get request    ${ENV_QUOTE_URL}/quote    ${params}

Return weather information with valid token
    [Arguments]     ${token}
    ${params}       Create Dictionary    token=${token}
    ${response}     get request    ${ENV_WEATHER_URL}/weather   ${params}

Get random token
    ${invalid_token}    generate uuid
    Set test variable     ${invalid_token}     ${invalid_token}

Return weather information with random token
    [Arguments]     ${invalid_token}
    ${invalid_token}    Get random token
    ${params}    Create Dictionary    token=${invalid_token}
    ${invalid_token}   get request    ${ENV_WEATHER_URL}/weather   ${params}
    [Return]    ${response}

Get random name
    ${random_name}    generate random name
    Set test variable     ${random_name}     ${random_name}

Verify Headers Content Is Dictionary
    [Arguments]    ${headers}
    ${is_dict}=    Evaluate    isinstance(${headers}, dict)
    Should Be True    ${is_dict}    The headers content is not in dictionary form.

Verify Response Body Is Dictionary
    [Arguments]    ${body}
    ${is_dict}=    Evaluate    isinstance(${body}, dict)
    Should Be True    ${is_dict}    The response body is not in dictionary form.


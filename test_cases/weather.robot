*** Settings ***
Documentation       Test collection for registration system
Resource            ../resources/common.resource

*** Test Cases ***
TC1 Get weather information when valid token is provided by user
    [Documentation]     verifies that user can generate quote when valid token is provided
    [Setup]             Get User Token      name=test_user      password=test_password
    Return weather information with valid token    token=${token}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Verify response body schema    ${RESPONSE.text}

TC2 Get weather information when invalid token is provided by user
    [Documentation]     Verifies that user cannot get weather information when an invalid token is provided
    [Tags]      weather1
    [Setup]     Get random token
    Return weather information with random token      token=${invalid_token}
    Verify response status code
    ...          expected_status_code=200       actual_status_code=${RESPONSE.status_code}
     Verify response body schema        ${RESPONSE.text}


*** Settings ***
Documentation       Test collection for registration system
Resource            ../resources/common.resource

*** Test Cases ***
TC1 Generate quote when valid token is provided by user
    [Documentation]     verifies that user can generate quote when valid token is provided
    [Tags]              quote
    [Setup]             Get User Token      name=test_user      password=test_password
    Generate quote    token=${token}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Verify response body schema    ${RESPONSE.text}

TC2 Generate quote when invalid token is provided by user
    [Documentation]     verifies that user cannot generate quote when invalid token is provided
    [Tags]              quote1
    [Setup]             Get random token
    Generate quote    token=${invalid_token}
    Verify response status code
    ...          expected_status_code=401        actual_status_code=${RESPONSE.status_code}
     Should Contain     ${RESPONSE.text}             token is invalid




*** Settings ***
Documentation       Test collection for registration system
Resource            ../resources/common.resource
Library    String


*** Test Cases ***
TC1 Signup a user with valid credentials
    [Documentation]     verifies that user can register into the system with valid credentials
    [Tags]      signup
    Sign up a new user
    ...         name=test1
    ...         password=test_password
    #Assertions
    Verify Response Status Code
    ...         expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Verify response body schema    ${RESPONSE.text}
    set test variable   ${assert_reponse_text}      token: {}\\n Please save it. This is visible only once. If you forget please regenerate token
    ${token}=      extract token       text=${RESPONSE.text}
    ${assert_reponse}=      format string      ${assert_reponse_text}    ${token}
    Should Contain                ${RESPONSE.text}      ${assert_reponse}

TC2 Renew token by providing valid name
    [Documentation]     verifies that user can renew token when valid name is provided
    [Tags]              renew
    [Setup]             run keywords     Get random name       AND
    ...                                  Sign up a new user    name=${random_name}      password=1234567
    Renew token for user        random_name=${random_name}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Verify Headers Content Is Dictionary     ${RESPONSE.headers}

TC3 Renew token by providing an unregistered name
    [Documentation]     verifies that user cannot renew token when unregistered name is provided
    [Tags]      unregistered
    [Setup]     Get random name
    Renew token for unregistered user    name=${random_name}
    Verify response status code
    ...          expected_status_code=404        actual_status_code=${RESPONSE.status_code}
    Verify Response Body Is Dictionary    ${RESPONSE.content}
    
TC4 Renew token by providing a user's name is registered twice
    [Documentation]     verifies that user cannot renew token when name have been registered twice
    [Tags]      duplicate
    [Setup]     Register the same user twice
    ...             name=test123      password=test_password
    Renew token for user                random_name=test123
    Verify response status code
    ...          expected_status_code=409        actual_status_code=${RESPONSE.status_code}
     Should Contain     ${RESPONSE.text}                Duplicate Records found

TC5 Validate token by providing valid token 
    [Documentation]     verifies that token provided by user is valid
    [Tags]      validate
    [Setup]             Get User Token      name=John      password=test_password
    Validate provided token is valid   token=${token}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Should Contain     ${RESPONSE.text}   true

TC6 Validate token by providing invalid token 
    [Documentation]     verifies that token cannot be validated when provided token is invalid
    [Tags]              validate1
    [Setup]             Get random token
    Validate provided token is invalid    ${invalid_token}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
    Should Contain     ${RESPONSE.text}   false

TC7 Get user information by providing valid token
    [Documentation]     verifies user gets user information when valid token is provided
    [Tags]              get_user
    [Setup]             Get random name
    Get User Token    ${random_name}    password=12345abc
    Get user information    token=${token}
    Verify response status code
    ...          expected_status_code=200        actual_status_code=${RESPONSE.status_code}
   Should Contain     ${RESPONSE.text}   ${random_name}

TC8 Get user information by providing invalid token
    [Documentation]     verifies user cannot get user information when invalid token is provided
    [Tags]              get_user1
    [Setup]             Get random token
    Get user information    token=${invalid_token}
    Verify response status code
    ...          expected_status_code=401        actual_status_code=${RESPONSE.status_code}
    Should Contain     ${RESPONSE.text}   Invalid Token



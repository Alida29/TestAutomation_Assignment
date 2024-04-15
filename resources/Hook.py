import requests
import re
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError
import uuid
import names


class Hook:
    def __init__(self):
        self._builtin = None

    @property
    def builtin(self):
        if not self._builtin:
            try:
                self._builtin = BuiltIn()
            except RobotNotRunningError:
                self._builtin = None
        return self._builtin

    @keyword('post request')
    def post_request(self, url: str, param: dict = None):
        resp = requests.post(url=url, params=param)
        self.builtin.set_test_variable('${RESPONSE}', resp)

    @keyword('patch request')
    def patch_request(self, url: str, param: dict = None):
        resp = requests.patch(url=url, params=param)
        self.builtin.set_test_variable('${RESPONSE}', resp)

    @keyword('get request')
    def get_request(self, url: str, param: dict = None):
        resp = requests.get(url=url, params=param)
        self.builtin.set_test_variable('${RESPONSE}', resp)

    @keyword('verify response status code')
    def verify_response_status_code(self, expected_status_code: int, actual_status_code: int):
        try:
            assert str(expected_status_code) == str(actual_status_code)
        except AssertionError:
            err = f'Actual Status Code is {actual_status_code}, not {expected_status_code} as expected.\n'
            raise AssertionError(err)

    @keyword('Verify response body schema')
    def verify_response_body_schema(self, actual_body):
        # Verify that the response body is a string
        if not isinstance(actual_body, str):
            raise AssertionError('Response body is not a string')

    @keyword('Verify response headers')
    def verify_response_headers(self, response):
        # Verify that the headers is a dictionary
        if not isinstance(response.headers, dict):
            raise AssertionError('Response headers are not a dictionary')

        if 'Content-Type' not in response.headers:
            raise AssertionError('Content-Type header is missing')
        if response.headers['Content-Type'] != 'application/json':
            raise AssertionError('Content-Type is not application/json')

        if 'Content-Length' not in response.headers:
            raise AssertionError('Content-Length header is missing')
        content_length = int(response.headers['Content-Length'])
        if content_length <= 0:
            raise AssertionError('Content-Length should be greater than 0')

    @keyword('extract token')
    def extract_token(self, text):
        match = re.search(r'token: (\w+)', text)
        if match:
            return match.group(1)
        else:
            return None

    @keyword('generate uuid')
    def generate_uuid(self):
        return str(uuid.uuid4())

    @keyword('generate random name')
    def generate_random_name(self):
        return names.get_full_name()



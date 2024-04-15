Instructions to run the tests:
1. pip3 install -r requirements.txt
2. command to run all tests: robot -d output -A resources/env/qa.env test_cases
3. command to run signup test suite: robot -d output -A resources/env/qa.env test_cases/signup.robot
4. command to run quote test suite: robot -d output -A resources/env/qa.env test_cases/quote.robot
5. command to run weather test suite: robot -d output -A resources/env/qa.env test_cases/weather.robot
6. command to run single test case: robot -d output -A resources/env/qa.env -i [tag_name] test_cases


robot: This is the command to run a test suite in Robot Framework.
-d output: This option specifies the directory where output files are created. 
-A resources/env/qa.env: The -A option is used to read variables from environment.
test_cases/signup.robot: This is the path to the test suite file. 
-i (tag): This runs only the test case you want to run. if you want to run only test case with the tag signup, 
          you can use the -i signup. 


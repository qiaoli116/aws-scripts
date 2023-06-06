# AWS Temporary Credentials Generator

This shell script generates temporary AWS credentials using the AWS Security Token Service (STS) and provides the necessary environment variables for authentication.

## Prerequisites

- AWS CLI: Ensure that the AWS CLI is installed and configured with the necessary credentials and region. You can install it by following the instructions in the [AWS CLI User Guide]([https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)).

- For generate_aws_credentials.sh
    - `jq`: The script relies on the `jq` command-line tool for processing JSON output. Make sure `jq` is installed on your system. You can install it using your system's package manager or refer to the [jq website](https://stedolan.github.io/jq/) for installation instructions.

- For generate_aws_credentials.py
    - Python 3 needs to be installed 

## Usage

```shell
./generate_credentials.sh -d days -h hours -m minutes -s seconds
```
-   `-d` (optional): Specify the duration in days.
-   `-h` (optional): Specify the duration in hours.
-   `-m` (optional): Specify the duration in minutes.
-   `-s` (optional): Specify the duration in seconds.

``` shell
python3 generate_aws_credentials.py -d days -H hours -m minutes -s seconds
```
-   `-d` (optional): Specify the duration in days.
-   `-H` (optional): Specify the duration in hours.
-   `-m` (optional): Specify the duration in minutes.
-   `-s` (optional): Specify the duration in seconds.

Note: at least one argument (days, hours, minutes, or seconds) must be provided to set a valid duration. If no arguments are provided, the script will display the usage information.

## Output

The script generates the following output:

-   Environment Variables: The script outputs `export` statements that can be used to set the necessary environment variables in the current shell session. These environment variables are:
    
    -   `AWS_ACCESS_KEY_ID`: The generated access key ID.
    -   `AWS_SECRET_ACCESS_KEY`: The generated secret access key.
    -   `AWS_SESSION_TOKEN`: The generated session token.

To unset the Environment Variables:
```shell
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```

-   AWS CLI Configuration: The script also outputs AWS CLI configuration settings for the `[default]` profile. These settings include:
    
    -   `aws_access_key_id`: The generated access key ID.
    -   `aws_secret_access_key`: The generated secret access key.
    -   `aws_session_token`: The generated session token.
-   Expiration Time/Date: The script displays the expiration time/date of the temporary credentials.
    
## Error Handling

The script includes error handling to capture and display any errors that may occur during the execution of the `aws sts get-session-token` command. If the command fails, an error message is printed, indicating the reason for the failure.

## License

This script is released under the MIT License.

data "aws_iam_policy_document" "lambda-admin" {
  provider = aws.secondary
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_role" "lambda-admin" {
  provider = aws.secondary
  name = "lambda-admin"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  provider = aws.secondary
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger-2nd-server.function_name
  principal = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn = aws_cloudwatch_metric_alarm.primary-server-unhealthy.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "trigger-2nd-server" {
  provider = aws.secondary
  filename         = data.archive_file.lambda.output_path
  function_name    = "trigger-2nd-server"
  role             = data.aws_iam_role.lambda-admin.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  publish          = true

  environment {
    variables = {
      SECONDARY_ASG_NAME = aws_autoscaling_group.my_asg_secondary.name
    }
  }
}

#lambda turn of the secondary server when the primary server is healthy

resource "aws_lambda_permission" "allow_cloudwatch_off" {
  provider = aws.secondary
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.trigger-2nd-server-off.function_name
  principal = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn = aws_cloudwatch_metric_alarm.primary-server-healthy.arn
}

data "archive_file" "lambda_function_turn_off" {
  type        = "zip"
  source_file = "${path.module}/lambda_function_turn_off.py"
  output_path = "${path.module}/lambda_function_tufn_off.zip"
}
resource "aws_lambda_function" "trigger-2nd-server-off" {
  provider = aws.secondary
  filename         = data.archive_file.lambda.output_path
  function_name    = "trigger-2nd-server-off"
  role             = data.aws_iam_role.lambda-admin.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = data.archive_file.lambda_function_turn_off.output_base64sha256
  publish          = true

  environment {
    variables = {
      SECONDARY_ASG_NAME = aws_autoscaling_group.my_asg_secondary.name
    }
  }
}
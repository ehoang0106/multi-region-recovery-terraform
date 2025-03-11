# resource "aws_lambda_function" "trigger_asg_secondary" {
#   filename         = "lambda_function.zip"
#   function_name    = "trigger_asg_secondary"
#   role             = aws_iam_role.lambda_exec.arn
#   handler          = "lambda_function.lambda_handler"
#   runtime          = "python3.8"
#   source_code_hash = filebase64sha256("lambda_function.zip")

#   environment {
#     variables = {
#       ASG_NAME = aws_autoscaling_group.my_asg_secondary.name
#     }
#   }
# }

# resource "aws_lambda_permission" "allow_sns" {
#   statement_id  = "AllowExecutionFromSNS"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.trigger_asg_secondary.function_name
#   principal     = "sns.amazonaws.com"
#   source_arn    = aws_sns_topic.trigger_secondary_asg.arn
# }

# resource "aws_sns_topic_subscription" "lambda" {
#   topic_arn = aws_sns_topic.trigger_secondary_asg.arn
#   protocol  = "lambda"
#   endpoint  = aws_lambda_function.trigger_asg_secondary.arn
# }
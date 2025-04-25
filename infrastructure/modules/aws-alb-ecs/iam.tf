#################################################################################################
# This file describes the IAM resources: ECS task role, ECS execution role
#################################################################################################

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name                  = "${var.app_name}-app-ecsTaskExecutionRole"
    assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions               = ["sts:AssumeRole"]

    principals {
      type                = "Service"
      identifiers         = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#Allows pull image from ECR, write to CloudWatch Logs and use AWS Secrets Manager and SSM Parameter Store 
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role                  = aws_iam_role.ecsTaskExecutionRole.name
    policy_arn            = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecsTaskRole" {
    name                  = "ecsTaskRole"
    assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json   
}

# resource "aws_iam_role_policy_attachment" "ecsTaskRole_policy" {
#     role                  = aws_iam_role.ecsTaskRole.name
#     policy_arn            = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
# }
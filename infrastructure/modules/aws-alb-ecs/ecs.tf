##########################################################################################
# This file describes the ECS resources: ECS cluster, ECS task definition, ECS service
##########################################################################################

#Log group for ECS
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 7
}

#ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
    name                                = "${var.app_name}-ecs-cluster"
}

#The Task Definition used in conjunction with the ECS service
resource "aws_ecs_task_definition" "task_definition" {
    family                              = "${var.app_name}-family"
    # container definitions describes the configurations for the task
    container_definitions               = jsonencode(
    [
      {
    name        = "${var.app_name}-container",
    image       = "${var.container_image}",
    essential   = true,
    entryPoint  = [],
    networkMode = "awsvpc", # maybe should be removed

    portMappings = [
      {
        containerPort = var.container_port,
        hostPort      = var.container_port,
        protocol      = "tcp"
      }
    ],
    # healthCheck = {
    #   command     = [ "CMD-SHELL", "curl -f http://localhost:5000/ || exit 1" ],
    #   interval    = 30,
    #   timeout     = 10,
    #   startPeriod = 10,
    #   retries     = 3
    # },
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        awslogs-group         = "/ecs/${var.app_name}",
        awslogs-region        = "${var.region}",
        awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

    #Fargate is used as opposed to EC2, so we do not need to manage the EC2 instances. Fargate is serveless
    requires_compatibilities            = ["FARGATE"]
    network_mode                        = "awsvpc"
    cpu                                 = "256"
    memory                              = "512"
    execution_role_arn                  = aws_iam_role.ecsTaskExecutionRole.arn
    task_role_arn                       = aws_iam_role.ecsTaskRole.arn
}

#The ECS service described. This resources allows you to manage tasks
resource "aws_ecs_service" "ecs_service" {
    name                                = "${var.app_name}-ecs-service"
    cluster                             = aws_ecs_cluster.ecs_cluster.arn
    task_definition                     = aws_ecs_task_definition.task_definition.arn
    launch_type                         = "FARGATE"
    scheduling_strategy                 = "REPLICA"
    desired_count                       = 2 # the number of tasks you wish to run

  network_configuration {
    subnets                             = [var.private_subnet_1_id , var.private_subnet_2_id] # private_subnet_ids
    assign_public_ip                    = false
    security_groups                     = [aws_security_group.ecs_sg.id, aws_security_group.alb_sg.id]
  }

# This block registers the tasks to a target group of the loadbalancer.
  load_balancer {
    target_group_arn                    = aws_lb_target_group.target_group.arn
    container_name                      = "${var.app_name}-container"
    container_port                      = var.container_port
  }
#   depends_on = [
#   aws_lb_listener.listener,
#   aws_lb_target_group.target_group
# ]
  depends_on                            = [aws_lb_listener.listener]
}
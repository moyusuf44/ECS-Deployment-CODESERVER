resource "aws_ecs_cluster" "this" {
    name      = "code-server-cluster-terra"

    setting {
        name  = "containerInsights"
        value = "enabled"
    }
}

resource "aws_ecs_task_definition" "this" {
    family                   = "code-server-task-terra"
    requires_compatibilities = ["FARGATE"]

    network_mode             = "awsvpc"
    
    cpu                      = var.cpu
    memory                   = var.memory

    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

    container_definitions   = jsonencode ([
        {
            name             = "code-server-terra"
            image            = var.image_id
            environment = [
        {
            name  = "PASSWORD"  
            value = var.code_server_password
        }
    ]
            portMappings     = [
                {
                    containerPort = 8080
                    hostPort      = 8080
                }
            ]
        }
    ])
}

resource "aws_ecs_service" "this" {
    name                 = "code-server-service-terra"
    cluster              = aws_ecs_cluster.this.id
    task_definition      = aws_ecs_task_definition.this.arn
    launch_type          = "FARGATE"

    desired_count        = var.desired_count

    network_configuration {
        subnets          = var.subnets
        security_groups  = var.security_group
        assign_public_ip = true 
    }

    load_balancer {
        target_group_arn = var.target_group_arn
        container_name = "code-server-terra"
        container_port = "8080"
    }
}

resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecsTaskExecutionRole"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                } 
                Action = "sts:AssumeRole"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
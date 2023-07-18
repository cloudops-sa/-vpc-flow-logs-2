
resource "aws_iam_role" "flow_log_role" {
  name               = "flow_log_role"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_assume_role_policy.json
}


resource "aws_iam_role_policy" "flow_log_role_policy" {
  name   = "flow_log_role_policy"
  role   = aws_iam_role.flow_log_role.id
  policy = data.aws_iam_policy_document.flow_log_role_policy.json
}


resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "/aws/vpcflowlogs/${var.vpc_name}/${var.vpc_id}/${var.vpc_flow_log_group_name}"
  #name_prefix = var.vpc_flow_log_group_name_prefix 

  tags = var.cloudwatch_log_tags
}


resource "aws_flow_log" "vpc_flow_log" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  log_destination_type = var.vpc_log_destination_type
  traffic_type         = var.vpc_traffic_type
  vpc_id               = var.vpc_id

  iam_role_arn = aws_iam_role.flow_log_role.arn

   tags = "${merge(
    tomap({"Name" = "${var.vpc_name}"}),
     var.aws_flow_log_tags)}"

}
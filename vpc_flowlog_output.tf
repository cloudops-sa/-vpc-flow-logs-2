output vpc_flowlog_id {
  value       = aws_flow_log.vpc_flow_log.id
  description = "The ID of the Flow Log resource"

}
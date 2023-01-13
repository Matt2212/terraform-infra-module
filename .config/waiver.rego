package fugue.regula.config

waivers[waiver] {
  waiver := {
    "resource_id": "module.eks.module.self_managed_node_group.aws_autoscaling_group.this",
    "rule_id": "FG_R00014"
  }
} {
  waiver := {
    "resource_id": "aws_s3_bucket.log_bucket",
    "rule_id": "FG_R00275"
  }
} {
  waiver := {
    "resource_id": "aws_s3_bucket.log_bucket",
    "rule_id": "FG_R00354"
  }
} {
  waiver := {
    "resource_id": "aws_s3_bucket.log_bucket",
    "rule_id": "FG_R00355"
  }
}
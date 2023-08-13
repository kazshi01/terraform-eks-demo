##コントローラーはdeployされるが、その後ingressを作成しても、ALBが作成されない

# resource "helm_release" "lb" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   depends_on = [
#     kubernetes_service_account.service_account
#   ]

#   set {
#     name  = "region"
#     value = "var.region"
#   }

#   set {
#     name  = "vpcId"
#     value = data.terraform_remote_state.vpc.outputs.vpc_id
#   }

#   set {
#     name  = "image.repository"
#     value = "602401143452.dkr.ecr.ap-northeast-1.amazonaws.com/amazon/aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "false"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "clusterName"
#     value = var.cluster_name
#   }
# }

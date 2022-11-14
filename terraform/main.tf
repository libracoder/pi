terraform {
  backend "pg" {
    conn_str = "postgres://postgres:123pco@192.168.1.82/tfbackend?sslmode=disable"
    schema_name = "public"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "pi"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {
  cluster    = "pi"
  namespaces = ["apps", "ingress-nginx", ]
}

resource "kubernetes_labels" "example" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "win"
  }
  labels = {
    "owner" = "myteam"
  }
}

resource "kubernetes_namespace" "this" {
  count = length(local.namespaces)
  metadata {
    name = local.namespaces[count.index]
  }
}


resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metallb"
  namespace = "ingress-nginx"

  values = [
    file("values.yaml")
  ]

  set {
    name  = "service.type"
    value = "LoadBalancer"

  }
  depends_on = [kubernetes_namespace.this]
}
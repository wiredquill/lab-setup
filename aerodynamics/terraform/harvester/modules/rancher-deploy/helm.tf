# Helm resources

# Install cert-manager helm chart
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version = "v${var.cert_manager_version}"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  set {
    name  = "crds.enabled"
    value = "true"
  }

  set {
    name  = "dns01RecursiveNameserversOnly"
    value = "true"
  }

  set {
    name  = "dns01RecursiveNameservers"
    value = "8.8.8.8:53"
  }
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  wait             = true
}

resource "kubernetes_secret" "cloudflare-api-token" {
  depends_on = [ helm_release.cert_manager ]
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }

  data = {
    api-token = var.cloudflare_api_token
  }
}

resource "kubectl_manifest" "letsencrypt-prod" {
  depends_on = [ helm_release.cert_manager, kubernetes_secret.cloudflare-api-token ]
  yaml_body = <<EOF
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
      namespace: cert-manager
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${var.letsencrypt_email}
        privateKeySecretRef:
          name: letsencrypt-prod
        solvers:
        - dns01:
            cloudflare:
              apiTokenSecretRef:
                name: cloudflare-api-token
                key: api-token
  EOF
}

# Install Rancher helm chart
resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager,
    helm_release.ingress-nginx,
    kubectl_manifest.letsencrypt-prod,
    kubernetes_secret.cloudflare-api-token
  ]

  name             = "rancher"
  repository = var.rancher_helm_repository
  chart            = "rancher"
  version = var.rancher_version
  namespace        = "cattle-system"
  create_namespace = true
  wait             = true

  set {
    name  = "hostname"
    value = var.rancher_server_dns
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name = "ingress.extraAnnotations.cert-manager\\.io/cluster-issuer"
    value = "letsencrypt-prod"
  }

  set {
    name = "ingress.ingressClassName"
    value = "nginx"
  }

  set {
    name = "ingress.tls.source"
    value = "secret"
  }

  set {
    name = "ingress.tls.secretName"
    value = "rancher-tls"
  }

  set {
    name = "agentTLSMode"
    value = "system-store"
  }

  set {
    name  = "bootstrapPassword"
    value = "admin" # TODO: change this once the terraform provider has been updated with the new pw bootstrap logic
  }

  values = [jsonencode(
    {
        "extraEnv" = [
            {
                "name"  = "CATTLE_SERVER_VERSION"
                "value" = "2.11-gartner-head"
            }
        ]
    }
)]
}

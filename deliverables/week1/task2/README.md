# Istio Gateway Configuration for E-commerce Frontend

## Overview

This task configures Istio to expose the e-commerce application frontend through an Istio ingress gateway instead of a direct Kubernetes LoadBalancer service. This establishes a foundation for advanced traffic management and observability features.

## Prerequisites

- Kubernetes cluster (tested on GKE and minikube)
- Istio 1.27+ installed with demo profile
- E-commerce application deployed in `ecomm-app` namespace

## Configuration Files

### Gateway Configuration (`gateway.yaml`)

```yaml
apiVersion: networking.istio.io/v1
kind: Gateway
metadata:
  name: ecomm-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
```

**Key Configuration Points:**
- Uses the default `istio-ingressgateway` selector
- Listens on HTTP port 80 (standard web traffic)
- Accepts traffic from all hosts (`*`)

### VirtualService Configuration (`virtualservice-frontend.yaml`)

```yaml
apiVersion: networking.istio.io/v1
kind: VirtualService
metadata:
  name: ecomm-virtualservice
spec:
  hosts:
  - "*"
  gateways:
  - ecomm-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: frontend
        port:
          number: 80
```

**Key Configuration Points:**
- Routes all incoming traffic (prefix: `/`) to the frontend service
- Forwards traffic to the frontend service on port 80
- References the `ecomm-gateway` for traffic entry

## Setup Instructions

### 1. Namespace Preparation

Ensure the application namespace has Istio sidecar injection enabled:

```bash
kubectl label namespace ecomm-app istio-injection=enabled
kubectl get ns ecomm-app --show-labels
```

### 2. Deploy Gateway and VirtualService

Apply the Istio configurations:

```bash
kubectl apply -f gateway.yaml -n ecomm-app
kubectl apply -f virtualservice-frontend.yaml -n ecomm-app
```

### 3. Restart Deployments

Restart deployments to inject Istio sidecars:

```bash
kubectl rollout restart deployment -n ecomm-app
```

### 4. Verify Configuration

Check that resources are created successfully:

```bash
kubectl get gateway -n ecomm-app
kubectl get virtualservice -n ecomm-app
kubectl describe gateway ecomm-gateway -n ecomm-app
kubectl describe virtualservice ecomm-virtualservice -n ecomm-app
```

## Verification

### 1. Check Istio Ingress Gateway Service

```bash
kubectl get svc istio-ingressgateway -n istio-system
```

**Expected Output (GKE):**
```
NAME                   TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)
istio-ingressgateway   LoadBalancer   10.22.1.219   34.147.239.134   15021:31317/TCP,80:31065/TCP,443:31969/TCP,31400:31931/TCP,15443:32295/TCP
```

### 2. Test External Access

**On GKE (with LoadBalancer):**
```bash
curl http://EXTERNAL-IP/
# Example: curl http://34.147.239.134/
```

**On Minikube (with port-forwarding):**
```bash
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80 --address=0.0.0.0 &
curl http://localhost:8080/
```

### 3. Verify Pod Sidecar Injection

Check that pods have Istio sidecars injected (should show 2/2 READY):

```bash
kubectl get pods -n ecomm-app
```

**Expected Output:**
```
NAME                        READY   STATUS    RESTARTS   AGE
frontend-xyz                2/2     Running   0          5m
loadgenerator-abc           2/2     Running   0          5m
```

## Testing Results

### Successful Deployments

**Minikube Environment:**
- Successfully deployed and accessed via `http://localhost:8080/`
- Required port-forwarding for external access
- All Istio components functioning correctly

**GKE Environment:**
- Successfully deployed with external LoadBalancer IP: `34.147.239.134`
- Direct external access without port-forwarding
- Production-ready configuration

### Traffic Flow Verification

1. **External Request** → Istio Ingress Gateway (port 80)
2. **Gateway** → VirtualService routing rules
3. **VirtualService** → Frontend service (port 80)
4. **Frontend Service** → Frontend pods with Istio sidecars

## Observability Setup

Optional: Install Istio observability addons for traffic monitoring:

```bash
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.27/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.27/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.27/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.27/samples/addons/jaeger.yaml

# Access Kiali dashboard
kubectl port-forward -n istio-system svc/kiali 20001:20001
```

Access Kiali at `http://localhost:20001/kiali` to visualize service mesh traffic.

## Key Benefits Achieved

1. **Traffic Management**: Frontend now accessible through Istio gateway enabling advanced routing capabilities
2. **Observability**: All traffic flows through Istio sidecars providing detailed metrics and tracing
3. **Security**: Foundation for implementing mutual TLS, authorization policies, and rate limiting
4. **Load Balancing**: Istio provides sophisticated load balancing algorithms beyond basic Kubernetes services

## Troubleshooting

### Common Issues

1. **Gateway Configuration**: Ensure port is set to 80, not 8080
2. **Namespace Labels**: Verify Istio injection is enabled on the namespace
3. **Sidecar Injection**: Restart deployments after enabling injection
4. **API Versions**: Use `networking.istio.io/v1` for current Istio versions

### Verification Commands

```bash
# Check Istio proxy status
istioctl proxy-status

# Analyze configuration issues
istioctl analyze -n ecomm-app

# View proxy configuration
istioctl proxy-config routes deploy/istio-ingressgateway -n istio-system
```

## Conclusion

The e-commerce frontend is now successfully exposed through the Istio ingress gateway, providing a foundation for advanced service mesh capabilities including traffic management, security policies, and comprehensive observability.
NAMESPACE := mock-chart
RELEASE := mock-chart-release
CHART_PATH := .
ACTIVE ?= blue
HOST := mock-chart.local

.PHONY: all install setup-ingress upgrade switch-blue switch-green test forward load uninstall

all: install

setup-ingress:
	@echo "[info] Checking Ingress NGINX..."
	@if ! kubectl get ns ingress-nginx >/dev/null 2>&1; then \
		helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx; \
		helm repo update; \
		helm install ingress-nginx ingress-nginx/ingress-nginx \
			--namespace ingress-nginx --create-namespace; \
	else \
		echo "[ok] Ingress NGINX already installed."; \
	fi

install: setup-ingress
	@echo "[info] Installing Helm chart..."
	kubectl create namespace $(NAMESPACE) --dry-run=client -o yaml | kubectl apply -f -
	helm install $(RELEASE) $(CHART_PATH) -n $(NAMESPACE) \
		--set activeDeployment=$(ACTIVE)

upgrade:
	@echo "[info] Upgrading to '$(ACTIVE)' deployment..."
	helm upgrade $(RELEASE) $(CHART_PATH) -n $(NAMESPACE) \
		--set activeDeployment=$(ACTIVE)

switch-blue:
	$(MAKE) upgrade ACTIVE=blue

switch-green:
	$(MAKE) upgrade ACTIVE=green

test:
	@echo "[test] Curling the app through Ingress..."
	@curl -s -H "Host: $(HOST)" http://localhost >/dev/null && \
		echo "[ok] App is reachable." || \
		(echo "[error] App not reachable. Check Ingress config." && exit 1)

forward:
	@echo "[info] Port-forwarding service..."
	@kubectl port-forward svc/$(RELEASE) 8080:80 -n $(NAMESPACE)

load:
	@echo "[load] Sending traffic to trigger HPA..."
	@command -v hey >/dev/null 2>&1 || (echo "Missing 'hey'. Please install it." && exit 1)
	hey -z 2m -c 20 http://localhost:8080

uninstall:
	@echo "[cleanup] Uninstalling release and namespace..."
	@helm uninstall $(RELEASE) -n $(NAMESPACE)
	@kubectl delete namespace $(NAMESPACE)

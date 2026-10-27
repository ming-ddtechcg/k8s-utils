# Tempo service discovery

```console
      - job_name: 'otel-collector'
        kubernetes_sd_configs:
        - role: endpoints
        relabel_configs:
        - source_labels: [__meta_kubernetes_service_annotation_prometheus_io_scrape]
          action: keep
          regex: true
        - source_labels: [__address__, __meta_kubernetes_service_annotation_prometheus_io_port]
          action: replace
          target_label: __address__
          regex: ([^:]+)(?::\d+)?;(\d+)
          replacement: $1:$2
        - source_labels: [__meta_kubernetes_endpoints_label_app_kubernetes_io_name]
          action: keep
          regex: (otel-collector?)
```

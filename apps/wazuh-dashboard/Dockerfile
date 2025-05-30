# syntax=docker/dockerfile:1

ARG VERSION
FROM wazuh/wazuh-dashboard:${VERSION}

RUN	/usr/share/wazuh-dashboard/bin/opensearch-dashboards-plugin install anomalyDetectionDashboards

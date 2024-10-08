FROM grafana/grafana-oss AS grafana
RUN grafana cli plugins install frser-sqlite-datasource

# disable login and set anonymous user as admin
ENV GF_AUTH_ANONYMOUS_ENABLED=true
ENV GF_AUTH_ANONYMOUS_ORG_ROLE=Admin
ENV GF_AUTH_BASIC_ENABLED=false
ENV GF_AUTH_DISABLE_LOGIN_FORM=true

# disable some more stuff
ENV GF_USERS_ALLOW_SIGN_UP=false
ENV GF_USERS_ALLOW_ORG_CREATE=false
ENV GF_UNIFIED_ALERTING_ENABLED=false

# set the default dashboard
ENV GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH=/var/lib/grafana/dashboards/dashboard.json


COPY grafana_config/datasources.yaml /etc/grafana/provisioning/datasources/datasources.yaml
COPY grafana_config/dashboards.yaml /etc/grafana/provisioning/dashboards/dashboards.yaml
COPY grafana_config/dashboard.json /var/lib/grafana/dashboards/dashboard.json

COPY helper_scripts /helper_scripts
#
ENTRYPOINT ["/helper_scripts/populate_gpkg_name.sh"]

module Librato.Dashboards where

listDashboards = get "dashboards"
createDashboard = post "dashboards"
getDashboard = get "dashboards/{id}"
updateDashboard = put "dashboards/{id}"
deleteDashboard = delete "dashboards/{id}"
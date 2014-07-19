{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Dashboards where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listDashboards :: Maybe Text -> Librato (Page Dashboard)
listDashboards name = get [uri| dashboards{?name} |]

createDashboard :: Dashboard -> Librato Dashboard
createDashboard = post "dashboards"

getDashboard :: Dashboard -> Librato (Maybe Dashboard)
getDashboard = get [uri| dashboards/{dashboardId} |]

updateDashboard :: Dashboard -> Librato ()
updateDashboard = put [uri| dashboards/{dashboardId} |]

deleteDashboard :: Dashboard -> Librato ()
deleteDashboard = delete [uri| dashboards/{dashboardId} |]

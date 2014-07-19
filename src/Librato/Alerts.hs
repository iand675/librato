{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Alerts where
import Librato.Internal
import Librato.Types
import Network.URI.Template

alerts = "alerts/"
alert alertId = alerts <> segment alertId
alertServices alertId = alert alertId <> "/services"

listAlerts = get alerts
createAlerts = post alerts
getAlert = get (alert alertId)
updateAlert = put (alert alertId)
deleteAlert = delete (alert alertId)
associateAlertService = post (alertServices alertId)
removeAssociatedAlertService = delete (alertServices alertId)

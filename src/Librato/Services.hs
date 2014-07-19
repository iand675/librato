{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Services where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listServices = get "services"
createService = post "services"
getService = get "services/{id}"
updateService = put "services/{id}"
deleteService = delete = "services/{id}"

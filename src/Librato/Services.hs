module Librato.Services where

listServices = get "services"
createService = post "services"
getService = get "services/{id}"
updateService = put "services/{id}"
deleteService = delete = "services/{id}"

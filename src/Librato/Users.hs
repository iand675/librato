{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Users where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listUsers = get "users"
createUser = post "users"
getUser = get "users/{id}"
updateUser = put "users/{id}"
deleteUser = delete "users/{id}"

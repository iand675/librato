module Librato.Users where

listUsers = get "users"
createUser = post "users"
getUser = get "users/{id}"
updateUser = put "users/{id}"
deleteUser = delete "users/{id}"
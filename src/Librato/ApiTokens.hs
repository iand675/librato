{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.ApiTokens where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listApiTokens = get "api_tokens"
createApiToken = post "api_tokens"
getApiToken = get "api_tokens/{id}"
putApiToken = put "api_tokens/{id}"
deleteApiToken = delete "api_tokens/{id}"

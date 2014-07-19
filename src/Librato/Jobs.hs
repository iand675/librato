{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Jobs where
import Librato.Internal
import Librato.Types
import Network.URI.Template

getJob :: JobId a -> Librato (Maybe (JobStatus a))
getJob = get "jobs/{id}"

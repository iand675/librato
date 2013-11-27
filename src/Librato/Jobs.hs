module Librato.Jobs where

getJob :: JobId a -> Librato (Maybe (JobStatus a))
getJob = get "jobs/{id}"
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.ChartTokens where
import Librato.Internal
import Librato.Types
import Network.URI.Template


listChartTokens = get "charts"
createChartToken = post "charts"
getChartToken = get "charts/{token}"
deleteChartToken = delete "charts/{token}"

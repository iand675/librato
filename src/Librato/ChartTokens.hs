module Librato.ChartTokens where


listChartTokens = get "charts"
createChartToken = post "charts"
getChartToken = get "charts/{token}"
deleteChartToken = delete "charts/{token}"
{-# LANGUAGE OverloadedStrings #-}
module Librato.Metrics where
import Data.Aeson
import Data.ByteString (ByteString)
import Data.Monoid ((<>))
import Data.Text (Text)
import Data.Vector (Vector)
import Librato.Internal
import Librato.Types
import Network.HTTP.Types.URI

metrics :: ByteString
metrics = "metrics"

metric :: ByteString -> ByteString
metric name = "metrics/" <> segment name

data ListMetricsRequest = ListMetricsRequest
  { lmreqName :: Text
  , lmreqTag :: [Text]
  }

data Metric = GaugeMetric | CounterMetric

data ListMetricsResponse = ListMetricsResponse
  { lmrespQuery :: PaginationInfo
  , lmrespMetrics :: Vector Metric
  }

data Measurement = Measurement
  { mName :: Text
  , mValue :: Double
  , mSource :: Maybe Text
  , mMeasureTime :: Maybe Int
  } deriving (Show)

--data Gauge = Gauge
--  { gName
--  , gValue
--  , gSource
--  , gMeasureTime
--  , gCount
--  , gSum
--  , gMax
--  , gMin
--  , gSumSquares
--  }

type Gauge = Measurement
type Counter = Measurement

instance ToJSON Measurement where
  toJSON m = object
    [ "name" .= mName m
    , "value" .= mValue m
    , "source" .= mSource m
    , "measure_time" .= mMeasureTime m
    ]

listMetrics :: ListMetricsRequest -> PaginationParameters -> Librato Value
listMetrics _ _ = getResponse (get metrics) >>= decodeResponse

submitMetrics :: Vector Gauge -> Vector Counter -> Librato ()
submitMetrics gauges counters = do
  getResponse (post metrics . jsonBody json)
  return ()
  where
    json = object ["gauges" .= gauges, "counters" .= counters]

--updateMetrics :: -> Librato (Maybe (JobId ()))
--updateMetrics = put metrics

--deleteMetrics :: -> Librato (Maybe (JobId ()))
--deleteMetrics = delete metrics

--getMetric :: MetricName -> Librato (Maybe Metric)
--getMetric name = get (metric name)

--createMetric :: -> Librato (Maybe Metric)
--createMetric name = put (metric name)

--updateMetric :: -> Librato Bool
--updateMetric name = put (metric name)

--deleteMetric :: MetricName -> Librato Bool
--deleteMetric name = delete (metric name)

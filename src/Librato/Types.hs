module Librato.Types where
import Data.ByteString (ByteString)
import Data.HashMap.Strict (HashMap)
import Data.Text (Text)
import Data.Vector (Vector)
import Network.HTTP.Conduit (Manager)

data SortOrder = Ascending | Descending

data PaginationParameters = PaginationParameters
  { paginationOffset :: Maybe Int
  , paginationLength :: Maybe Int
  , paginationSort :: Maybe SortOrder
  }

data PaginationInfo = PaginationInfo
  { paginationInfoLength :: Int
  , paginationInfoOffset :: Int
  , paginationInfoTotal :: Int
  , paginationInfoFound :: Int
  }

data LibratoError
  = ParamErrors
    { paramErrors :: HashMap Text (Vector Text)
    }
  | RequestErrors
    { requestErrors :: Vector Text
    }
  | SystemErrors
    { systemErrors :: Vector Text
    }
  | JsonError
    { decodingError :: String
    }
  deriving (Show)

data LibratoConfig = LibratoConfig
  { libratoAccount :: ByteString
  , libratoToken :: ByteString
  , libratoManager :: Manager
  }
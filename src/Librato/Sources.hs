module Librato.Sources where

data Source = Source
  { sourceName :: Text
  , sourceDisplayName :: Text
  }

data ListSourcesRequestParameters = ListSourcesRequestParameters
  { listSourcesName :: Text
  }

data ListSourcesResponse = ListSourcesResponse
  { listSourcesQuery :: PaginationInfo
  , listSourcesSources :: Vector Source
  }

listSources :: ListSourcesRequestParameters -> PaginationParameters -> Librato ListSourcesResponse
listSources = get "sources"

getSource :: Text -> Librato (Maybe Source)
getSource = get "sources/{name}"

setSource :: Text -> Maybe Text -> Librato (Maybe Source)
setSource = put "sources/{name}"

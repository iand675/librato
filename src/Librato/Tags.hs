{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Tags where
import Librato.Internal
import Librato.Types
import Network.URI.Template

data EntityType = Source | Gauge | Counter | Metric
listTags :: Maybe Text -> Maybe EntityType -> Librato (Page Tag)
listTags name entity_type = get [uri| tags{?name, entity_type} |]

getTag :: Text -> Maybe EntityType -> Librato (Maybe Tag)
getTag name entity_type = get [uri| tags{/name}{?entity_type} |]

createTag :: Tag -> Maybe EntityType -> Librato Tag
createTag name entity_type = post [| tags{/name}{?entity_type} |]

deleteTag :: Text -> EntityType -> Librato ()
deleteTag name entity_type = delete [| tags{/name}{?entity_type} |]

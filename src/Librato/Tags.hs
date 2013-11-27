module Librato.Tags where

listTags = get "tags"
getTag = get "tags/{name}"
createTag = post "tags/{name}"
deleteTag = delete "tags/{name}"
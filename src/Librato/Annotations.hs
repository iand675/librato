{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Annotations where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listAnnotations :: Librato (Page Annotation)
listAnnotations = get "annotations"

createAnnotationEvent :: Annotation -> Librato Annotation
createAnnotationEvent = post [uri| /annotations/{name} |]

data AnnotationFilters = AnnotationFilters { }

listAnnotationEvents :: Text -> AnnotationFilters -> Librato (Page Annotation)
listAnnotationEvents = get (annotation name)


updateAnnotationStream = put (annotation name)
deleteAnnotationStream = delete (annotation name)
getAnnotationEvent = get (annotationEvent name eventId)
updateAnnotationEvent = put (annotationEvent name eventId)
deleteAnnotationEvent = delete (annotationEvent name eventId)
addAnnotationEventLink = post (annotationEventLinks name eventId)
deleteAnnotationEventLink = delete (annotationEventLink name eventId link)

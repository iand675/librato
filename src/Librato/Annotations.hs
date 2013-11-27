module Librato.Annotations where

annotations = "annotations/"
annotation name = annotations <> segment name
annotationEvent name eventId = annotation name <> "/" <> segment eventId
annotationEventLinks name eventId = annotationEvent name eventId <> "/links/"
annotationEventLink name eventId link = annotationEventLinks name eventId <> segment link 

listAnnotations = get annotations
createAnnotationEvent = post (annotation name)
listAnnotationEvents = get (annotation name)
updateAnnotationStream = put (annotation name)
deleteAnnotationStream = delete (annotation name)
getAnnotationEvent = get (annotationEvent name eventId)
updateAnnotationEvent = put (annotationEvent name eventId)
deleteAnnotationEvent = delete (annotationEvent name eventId)
addAnnotationEventLink = post (annotationEventLinks name eventId)
deleteAnnotationEventLink = delete (annotationEventLink name eventId link)
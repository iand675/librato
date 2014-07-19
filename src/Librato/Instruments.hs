{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
module Librato.Instruments where
import Librato.Internal
import Librato.Types
import Network.URI.Template

listInstruments = get "instruments"
createInstrument = post "instruments"
getInstrument = get "instruments/{id}"
updateInstrument = put "instruments/{id}"
deleteInstrument = delete "instruments/{id}"

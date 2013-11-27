module Librato.Instruments where

listInstruments = get "instruments"
createInstrument = post "instruments"
getInstrument = get "instruments/{id}"
updateInstrument = put "instruments/{id}"
deleteInstrument = delete "instruments/{id}"

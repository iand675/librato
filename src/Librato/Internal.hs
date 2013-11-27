{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving #-}
module Librato.Internal where
import Control.Monad.Reader
import Control.Monad.Trans.Either
import Control.Monad.Trans.Resource
import Data.Aeson
import qualified Data.ByteString as B (ByteString)
import Data.ByteString.Lazy (ByteString)
import Data.Maybe
import Data.Monoid
import Librato.Types
import Network.HTTP.Conduit
import Network.HTTP.Types.Method
import Network.HTTP.Types.URI (Query, renderQuery, urlEncode)

newtype Librato a = Librato
  { fromLibrato :: EitherT LibratoError (ReaderT ((Request (ResourceT IO)), Manager) (ResourceT IO)) a
  } deriving (Functor, Monad, MonadIO)

withLibrato :: B.ByteString -> B.ByteString -> (LibratoConfig -> ResourceT IO a) -> IO a
withLibrato username token f = withManager $ \m -> f $ LibratoConfig username token m

librato :: LibratoConfig -> Librato a -> ResourceT IO (Either LibratoError a)
librato s m = runReaderT (runEitherT (fromLibrato m)) $ (request s, libratoManager s)

addUserAgent :: Request m -> Request m
addUserAgent r = r
  { requestHeaders = ("User-Agent", "librato/0.0.1 (Haskell)") : requestHeaders r
  }

libratoRequest :: Request (ResourceT IO)
libratoRequest = fromJust $ parseUrl "https://metrics-api.librato.com/v1/"

request :: LibratoConfig -> Request (ResourceT IO)
request (LibratoConfig account token _) = useJSON $ addUserAgent $ applyBasicAuth account token $ libratoRequest

--libratoTest :: (LibratoConfig -> ResourceT IO a) -> ResourceT IO a
libratoTest = withLibrato "ian@iankduncan.com" "eb3b87e77423c976a63878a1943d1664810ba9c2a168311169401c0af171f4cc"

getResponse :: (Request (ResourceT IO) -> Request (ResourceT IO)) -> Librato (Response ByteString)
getResponse f = Librato $ do
  (req, man) <- lift $ ask
  let modifiedReq = f req
  lift $ lift $ httpLbs modifiedReq man

decodeResponse :: Response ByteString -> Librato Value
decodeResponse resp = Librato $ case decodeToJSON resp of
    Left err -> left $ JsonError err
    Right val -> return val

useJSON :: Request m -> Request m
useJSON r = r
  { requestHeaders = ("Content-Type", "application/json") : ("Accept", "application/json") : requestHeaders r
  }

decodeToJSON :: Response ByteString -> Either String Value
decodeToJSON = eitherDecode . responseBody

appendUrl :: B.ByteString -> Request m -> Request m
appendUrl b r = r
  { path = path r <> b
  }

get :: B.ByteString -> Request m -> Request m
get b r = appendUrl b $ r
  { method = methodGet
  }

put :: B.ByteString -> Request m -> Request m
put b r = appendUrl b $ r
  { method = methodPut
  }

post :: B.ByteString -> Request m -> Request m
post b r = appendUrl b $ r
  { method = methodPost
  }

delete :: B.ByteString -> Request m -> Request m
delete b r = appendUrl b $ r
  { method = methodDelete
  }

query :: Query -> Request m -> Request m
query q r = r
  { queryString = renderQuery True q
  }

jsonBody :: ToJSON a => a -> Request m -> Request m
jsonBody x r = r
  { requestBody = RequestBodyLBS $ encode x
  }

segment :: B.ByteString -> B.ByteString
segment = urlEncode False
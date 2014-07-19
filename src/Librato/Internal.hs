{-# LANGUAGE OverloadedStrings, GeneralizedNewtypeDeriving #-}
module Librato.Internal where
import Control.Applicative
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
  { fromLibrato :: EitherT LibratoError (ReaderT (Request, Manager) (ResourceT IO)) a
  } deriving (Functor, Applicative, Monad, MonadIO)

withLibrato :: B.ByteString -> B.ByteString -> (LibratoConfig -> ResourceT IO a) -> IO a
withLibrato username token f = withManager $ \m -> f $ LibratoConfig username token m

librato :: LibratoConfig -> Librato a -> ResourceT IO (Either LibratoError a)
librato s m = runReaderT (runEitherT (fromLibrato m)) $ (request s, libratoManager s)

addUserAgent :: Request -> Request
addUserAgent r = r
  { requestHeaders = ("User-Agent", "librato/0.0.1 (Haskell)") : requestHeaders r
  }

libratoRequest :: Request
libratoRequest = fromJust $ parseUrl "https://metrics-api.librato.com/v1/"

request :: LibratoConfig -> Request
request (LibratoConfig account token _) = useJSON $ addUserAgent $ applyBasicAuth account token $ libratoRequest

--libratoTest :: (LibratoConfig -> ResourceT IO a) -> ResourceT IO a

getResponse :: (Request -> Request) -> Librato (Response ByteString)
getResponse f = Librato $ do
  (req, man) <- lift $ ask
  let modifiedReq = f req
  lift $ lift $ httpLbs modifiedReq man

decodeResponse :: Response ByteString -> Librato Value
decodeResponse resp = Librato $ case decodeToJSON resp of
    Left err -> left $ JsonError err
    Right val -> return val

useJSON :: Request -> Request
useJSON r = r
  { requestHeaders = ("Content-Type", "application/json") : ("Accept", "application/json") : requestHeaders r
  }

decodeToJSON :: Response ByteString -> Either String Value
decodeToJSON = eitherDecode . responseBody

appendUrl :: B.ByteString -> Request -> Request
appendUrl b r = r
  { path = path r <> b
  }

get :: B.ByteString -> Request -> Request
get b r = appendUrl b $ r
  { method = methodGet
  }

put :: B.ByteString -> Request -> Request
put b r = appendUrl b $ r
  { method = methodPut
  }

post :: B.ByteString -> Request -> Request
post b r = appendUrl b $ r
  { method = methodPost
  }

delete :: B.ByteString -> Request -> Request
delete b r = appendUrl b $ r
  { method = methodDelete
  }

query :: Query -> Request -> Request
query q r = r
  { queryString = renderQuery True q
  }

jsonBody :: ToJSON a => a -> Request -> Request
jsonBody x r = r
  { requestBody = RequestBodyLBS $ encode x
  }

segment :: B.ByteString -> B.ByteString
segment = urlEncode False

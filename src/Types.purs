module Types where

import Control.Monad.Eff.Exception (Error)
import Data.Foreign.Class (class Decode, class Encode)
import Data.Generic.Rep (class Generic)
import Presto.Core.Types.API (class RestEndpoint, Method(GET), defaultDecodeResponse, defaultMakeRequest_)
import Presto.Core.Types.Language.Interaction (class Interact, defaultInteract)
import Presto.Core.Utils.Encoding (defaultDecode, defaultEncode)

---------------------------------SCREEN-----------------------------------------
data InitScreen = InitScreen InitScreenState

data InitScreenState
  = InitScreenInit
  | InitScreenAddTodo String
  | InitScreenRemoveTodo String
  | InitScreenUpdateTodo String

data InitScreenAction
  = AddToDo String
  | RemoveToDo TodoContent
  | UpdateToDo TodoContent

instance initScreenInteract :: Interact Error InitScreen InitScreenAction  where
    interact x = defaultInteract x

derive instance genericInitScreen :: Generic InitScreen _
instance encodeInitScreen :: Encode InitScreen where
    encode = defaultEncode

derive instance genericInitScreenState :: Generic InitScreenState _
instance encodeInitScreenState :: Encode InitScreenState where
    encode = defaultEncode

derive instance genericInitScreenAction :: Generic InitScreenAction _
instance decodeInitScreenAction :: Decode InitScreenAction where
  decode = defaultDecode

-----------------------------------API------------------------------------------

data TimeReq = TimeReq
newtype TimeResp = TimeResp
  { code :: Int
  , status :: String
  , response :: String
  }

instance getTimeReq :: RestEndpoint TimeReq TimeResp where
  makeRequest _ headers = defaultMakeRequest_ GET ("http://localhost:3000/time") headers
  decodeResponse body = defaultDecodeResponse body

derive instance genericTimeReq :: Generic TimeReq _
instance encodeTimeReq :: Encode TimeReq where encode = defaultEncode

derive instance genericTimeResp :: Generic TimeResp _
instance decodeTimeResp :: Decode TimeResp where decode = defaultDecode


---------------------------------------- todo ------------------------------------
newtype TodoContent = TodoContent {
  "data" :: String ,
  date :: String,
  "show" :: Boolean
}

newtype ArrayTodo = ArrayTodo {
   content :: Array TodoContent
}


derive instance genericTodoContent :: Generic TodoContent _
instance encodeTodoContent :: Encode TodoContent where encode = defaultEncode
instance decodeTodoContent :: Decode TodoContent where decode = defaultDecode

derive instance genericArrayTodo :: Generic ArrayTodo _
instance decodeArrayTodo :: Decode ArrayTodo where decode = defaultDecode
instance encodeArrayTodo :: Encode ArrayTodo where encode = defaultEncode


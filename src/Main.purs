module Main where

import Prelude

import Control.Monad.Aff (launchAff, makeAff)
import Control.Monad.Aff.AVar (makeVar')
import Control.Monad.State.Trans (evalStateT)
import Data.Either (Either(..))
import Data.Maybe(Maybe(..))
import Data.StrMap (empty)
import Data.Tuple (Tuple(..))
import Data.Array (cons,filter) 
import Presto.Core.Flow (APIRunner, PermissionCheckRunner, PermissionRunner(PermissionRunner), PermissionTakeRunner, runUI)
import Presto.Core.Language.Runtime.Interpreter (Runtime(..), UIRunner, run)
import Presto.Core.Types.Permission (PermissionStatus(..))
import Remote as API
import Types
import Utils.Runner (mkNativeRequest, showUI', callAPI')
import Presto.Core.Types.Language.Flow

foreign import parse :: forall a b. String ->  ArrayTodo
foreign import logData :: forall a b. a -> Unit
foreign import strToJson :: forall a b. String -> String -> TodoContent
foreign import stringify :: forall a b. a -> String 

launchFreeFlow = do
  let runtime = Runtime uiRunner (PermissionRunner permissionCheckRunner permissionTakeRunner) apiRunner
      freeFlow = evalStateT (run runtime (appFlow InitScreenInit))
  launchAff (makeVar' empty >>= freeFlow)
  where
    uiRunner :: UIRunner
    uiRunner a = makeAff (\err sc -> showUI' sc a)

    apiRunner :: APIRunner
    apiRunner req = makeAff (\err sc -> callAPI' err sc (mkNativeRequest req))

    permissionCheckRunner :: PermissionCheckRunner
    permissionCheckRunner perms = pure PermissionGranted

    permissionTakeRunner :: PermissionTakeRunner
    permissionTakeRunner perms =  pure $ map (\x -> Tuple x PermissionDeclined) perms

appFlow state = do
  action <- runUI (InitScreen state)
  case action of
    AddToDo str ->  do
      date <- API.getTime
      case date of
        Left err -> appFlow (InitScreenAddTodo "FAILURE")
        Right time -> do
          oldData <-  loadS "todos"
          case oldData of
            Nothing -> pure unit
            Just  content -> do
              let resp = strToJson str time
              let oldData = parse content
              case oldData of
                (ArrayTodo {content : arr }) -> saveS "todos" $ stringify $ cons resp  arr
                _ -> saveS "todos" "[]" 
              appFlow (InitScreenAddTodo "SUCCESS" )
    RemoveToDo (TodoContent item) -> do
      arr <- commonFlow
      let bal = removeItem item  arr
      saveS "todos" $ stringify $ bal
      appFlow (InitScreenRemoveTodo "SUCCESS" )
    UpdateToDo (TodoContent item) -> do
      arr <- commonFlow
      let bal = replaceItem item  arr
      saveS "todos" $ stringify $ bal
      appFlow (InitScreenUpdateTodo "SUCCESS" )
  
replaceItem item arr = map func arr
  where
    func :: TodoContent -> TodoContent
    func (TodoContent each) = do
      case item."date" == each."date" of
        true -> (TodoContent item)
        false -> (TodoContent each)

  
removeItem delete arr = filter func arr
  where
    func :: TodoContent -> Boolean
    func (TodoContent item) = item."date" /= delete."date"

commonFlow = do
  oldData <- loadS "todos"
  case oldData of
    Nothing -> pure  []
    Just  content -> do
      let oldData = parse content
      case oldData of
        (ArrayTodo {content : arr }) -> pure arr
        _ -> pure []

main = launchFreeFlow

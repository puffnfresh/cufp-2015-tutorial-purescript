module Main where

import Control.Monad.Eff
import Control.Monad.Eff.Exception hiding (error)
import Node.FS
import Control.Monad.Eff.Console

import Prelude
import Node.Encoding
import Node.FS.Sync

type MainEffects r = (err :: EXCEPTION, fs :: FS, console :: CONSOLE | r)

main :: Eff (MainEffects ()) Unit
main = do
  log "Hello sailor!"
  content <- readTextFile UTF8 "bower.json"
  log content

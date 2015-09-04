module Main where

import Prelude
import qualified Control.Monad.Aff as A
import Control.Monad.Aff.Console

import Halogen
import Halogen.Util
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Events as E

data Input a = Click a

render :: forall p. Render Int Input p
render n = H.div_ [ H.p_ [ H.text $ "Score: " ++ show n ]
                  , H.button [ E.onClick $ E.input_ Click ]
                             [ H.text "Click me!" ]
                  ]

eval :: forall f. Eval Input Int Input f
eval (Click a) = do
  modify (+ 1)
  pure a

ui :: forall f p. Component Int Input f p
ui = component render eval

main = A.launchAff do
  app <- runUI ui 0
  appendToBody app.node
  log "Hello world"

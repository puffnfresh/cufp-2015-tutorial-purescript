module Main where

import Prelude
import Data.Int (toNumber)
import qualified Control.Monad.Aff as A
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Aff.Console
import DOM
import Control.Monad.Free

import Halogen
import Halogen.Util
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Events as E

foreign import updateProgress
  :: forall r. Int -> Int -> Eff (dom :: DOM | r) Unit

updateProgress' :: forall eff. Int -> Int -> A.Aff (HalogenEffects eff) Unit
updateProgress' n m = liftEff $ updateProgress n m

data Input a = Click a
             | Timer a
             | GetScore (Int -> a)

type Game = { score :: Int
            , high :: Int
            }

render :: forall p. Render Game Input p
render n = H.div_ [ H.p_ [ H.text $ "Score: " ++ show n.score ]
                  , H.p_ [ H.text $ "High: " ++ show n.high ]
                  , H.button [ E.onClick $ E.input_ Click ]
                             [ H.text "Click me!" ]
                  ]

click :: Game -> Game
click g = g { score = newScore
            , high = if newScore > g.high
                     then newScore
                     else g.high
            }
  where newScore = g.score + 1

timer :: Game -> Game
timer g = g { score = newScore }
  where newScore = if g.score <= 0
                   then 0
                   else g.score - 1

eval :: forall eff. Eval Input Game Input (A.Aff (HalogenEffects eff))
eval (Click a) = do
  modify click
  g <- get
  liftFI $ updateProgress' g.score g.high
  pure a
eval (Timer a) = do
  modify timer
  pure a
eval (GetScore f) = do
  n <- gets _.score
  pure $ f n

ui :: forall eff p. Component Game Input (A.Aff (HalogenEffects eff)) p
ui = component render eval

main = A.launchAff do
  app <- runUI ui { score: 0, high: 0 }
  appendToBody app.node
  log "Hello world"
  let timer = do
        score <- app.driver $ GetScore id
        A.later' (300 - (score * 4)) do
          app.driver $ Timer unit
          timer
  timer

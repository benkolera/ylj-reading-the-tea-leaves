module Main where

import Prelude
import App as A
import Halogen as H
import Halogen.Aff as HA
import Control.Monad.Aff (delay)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Now (NOW, now)
import Control.Monad.Rec.Class (forever)
import Data.DateTime.Instant (toDateTime)
import Data.Time.Duration (Milliseconds(..))
import Halogen.VDom.Driver (runUI)

main :: Eff (HA.HalogenEffects (now :: NOW)) Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  io <- runUI (H.hoist liftEff A.app) unit body
  forever $ do
    delay (Milliseconds 300.0)
    n <- toDateTime <$> liftEff now
    io.query $ H.action $ A.Tick n
module Route exposing (Route, fromUrl)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s)


type Route
    = Simulation Int


fromUrl : Url -> Maybe Route
fromUrl url =
    Url.Parser.parse routeParser url


routeParser : Parser (Route -> a) a
routeParser =
    oneOf [ map Simulation (s "simulation" </> int) ]

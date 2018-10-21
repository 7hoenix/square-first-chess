module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser exposing ((</>), Parser, int, map, oneOf, s)


type Route
    = Home
    | Simulation Int


fromUrl : Url -> Maybe Route
fromUrl url =
    Url.Parser.parse routeParser url


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Home (s "home")
        , map Simulation (s "simulation" </> int)
        ]

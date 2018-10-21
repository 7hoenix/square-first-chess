module Page exposing (Page(..), view, viewErrors)

import Browser exposing (Document)
import Html exposing (Html)


type Page
    = Simulation


view : Page -> { title : String, content : Html msg } -> Document msg
view page { title, content } =
    { title = title
    , body = [ content ]
    }


viewErrors : msg -> List String -> Html msg
viewErrors dismissErrors errors =
    Html.text "got an error"

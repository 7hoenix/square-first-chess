module Page.Home exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (Html, div, text)
import Session exposing (Session)


type alias Model =
    { session : Session }


init : Session -> Model
init session =
    Model session



-- UPDATE --


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> { title : String, content : Html Msg }
view model =
    { title = "Home"
    , content = div [] [ text "hello world" ]
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

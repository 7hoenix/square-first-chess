module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, b, div, h1, img, li, text, ul)
import Html.Attributes exposing (href, src)
import Page.Home as Home
import Route exposing (Route)
import Session exposing (Session)
import Url



---- MAIN ----


main : Program () Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



---- MODEL ----


type Model
    = Home Home.Model
    | Redirect Session


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRouteTo (Route.fromUrl url)
        (Redirect (Session.init navKey))


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( model, Cmd.none )

        Just Route.Home ->
            Home.init session
                |> updateWith Home GotHomeMsg

        _ ->
            ( model, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
    | GotHomeMsg Home.Msg


toSession : Model -> Session
toSession model =
    case model of
        Home home ->
            Home.toSession home

        Redirect session ->
            session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl (Session.navKey (toSession model)) (Url.toString url)
                    )

                Browser.External href ->
                    ( model, Cmd.none )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( GotHomeMsg subMsg, Home home ) ->
            Home.update subMsg home
                |> updateWith Home GotHomeMsg

        ( _, _ ) ->
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    let
        viewPage page toMsg config =
            let
                { title, body } =
                    Page.view page config
            in
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        Redirect _ ->
            viewPage


viewBody : Model -> Html Msg
viewBody model =
    div
        []
        [ case model of
            Home homeModel ->
                Home.view homeModel

            _ ->
                text "not home"
        , ul []
            [ viewLink "/home"
            , viewLink "/profile"
            , viewLink "/simulation/1"
            ]
        ]


viewLink : String -> Html Msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]

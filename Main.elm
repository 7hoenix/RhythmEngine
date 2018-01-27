module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Time exposing (Time, second)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { countdown : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { countdown = 3 }, Cmd.none )



-- UPDATE


type Msg
    = UserInput
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserInput ->
            ( { model | countdown = 3 }, Cmd.none )

        Tick _ ->
            ( { model | countdown = model.countdown - 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (toString model.countdown) ]
        , div [ onClick UserInput ] [ text "reset" ]
        ]

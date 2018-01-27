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


type Status
    = InProgress
    | Finished String


type alias Model =
    { status : Status
    , countdown : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { status = InProgress
      , countdown = 3
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = UserInput
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserInput ->
            ( { model | countdown = 3, status = InProgress }, Cmd.none )

        Tick _ ->
            if model.countdown < 0 then
                ( { model | status = Finished "failed" }, Cmd.none )
            else
                ( { model | countdown = model.countdown - 1 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.status of
        Finished _ ->
            Sub.none

        _ ->
            Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ displayCountDown model.countdown ]
        , div [ onClick UserInput ] [ text "reset" ]
        ]


displayCountDown countdown =
    if countdown < 0 then
        text (toString 0)
    else
        text (toString countdown)

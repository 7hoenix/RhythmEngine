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


type Result
    = Succeed
    | Fail


type Status
    = InProgress
    | Finished Result


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
    | Reset
    | Tick Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( { model | countdown = 3, status = InProgress }, Cmd.none )

        UserInput ->
            case model.status of
                InProgress ->
                    ( { model | status = Finished Succeed }, Cmd.none )

                Finished result ->
                    ( model, Cmd.none )

        Tick _ ->
            if model.countdown < 0 then
                ( { model | status = Finished Fail }, Cmd.none )
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
        , div [ onClick UserInput ] [ text "click me before the timer runs out" ]
        , div [] [ text (displayResult model.status) ]
        , div [ onClick Reset ] [ text "Reset" ]
        ]


displayCountDown countdown =
    if countdown < 0 then
        text (toString 0)
    else
        text (toString countdown)


displayResult status =
    case status of
        InProgress ->
            "currently playing"

        Finished result ->
            toString result

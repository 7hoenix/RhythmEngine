module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Time exposing (Time, second)


main =
    Html.program
        { init = init 3
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type Status
    = InProgress
    | InBetween
    | Finished


type alias Score =
    { correct : Int
    , incorrect : Int
    }


type alias Model =
    { status : Status
    , countdown : Int
    , duration : Int
    , score : Score
    }


init : Int -> ( Model, Cmd Msg )
init duration =
    ( { status = InProgress
      , countdown = duration
      , duration = duration
      , score = { correct = 0, incorrect = 0 }
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
            ( { model | countdown = model.duration, status = InProgress }, Cmd.none )

        UserInput ->
            case model.status of
                InProgress ->
                    ( { model | status = InBetween, score = scoreCorrect model.score }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Tick _ ->
            if model.countdown < 0 then
                ( { model | status = InBetween, score = scoreIncorrect model.score }, Cmd.none )
            else
                ( { model | countdown = model.countdown - 1 }, Cmd.none )


scoreIncorrect : Score -> Score
scoreIncorrect score =
    { score | incorrect = mapScore score.incorrect increment }


scoreCorrect : Score -> Score
scoreCorrect score =
    { score | correct = mapScore score.correct increment }


mapScore : Int -> (Int -> Int) -> Int
mapScore currentScore fn =
    fn currentScore


increment : Int -> Int
increment score =
    score + 1



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.status of
        InProgress ->
            Time.every second Tick

        _ ->
            Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (toString (displayCountDown model.countdown)) ]
        , div [ onClick UserInput ] [ text "click me before the timer runs out" ]
        , div [] [ text (displayResults model.score) ]
        , div [ onClick Reset ] [ text "Reset" ]
        ]


displayCountDown : Int -> Int
displayCountDown countdown =
    if countdown < 0 then
        0
    else
        countdown


displayResults : Score -> String
displayResults { correct, incorrect } =
    "Correct: " ++ toString correct ++ " || " ++ "Incorrect: " ++ toString incorrect

module Main exposing (..)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Library


main =
    Html.program
        { init = ( Library.init 3, Cmd.none )
        , view = view
        , update = update
        , subscriptions = Library.subscriptions
        }



-- UPDATE


update : Library.Msg userInput -> Library.Model -> ( Library.Model, Cmd (Library.Msg userInput) )
update msg model =
    ( Library.update (\_ -> False) msg model, Cmd.none )



-- VIEW


view : Library.Model -> Html (Library.Msg ())
view model =
    div []
        [ div [] [ text (toString (displayCountDown model.countdown)) ]
        , div [ onClick (Library.UserInput ()) ] [ text "click me before the timer runs out" ]
        , div [] [ text (displayResults model.score) ]
        , div [ onClick Library.Reset ] [ text "Reset" ]
        ]


displayCountDown : Int -> Int
displayCountDown countdown =
    if countdown < 0 then
        0
    else
        countdown


displayResults : Library.Score -> String
displayResults { correct, incorrect } =
    "Correct: " ++ toString correct ++ " || " ++ "Incorrect: " ++ toString incorrect

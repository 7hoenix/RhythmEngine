module Library exposing (..)

import Time exposing (Time, second)


-- MODEL


type Status
    = InProgress
    | InBetween


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


init : Int -> Model
init duration =
    { status = InProgress
    , countdown = duration
    , duration = duration
    , score = { correct = 0, incorrect = 0 }
    }



-- UPDATE


type Msg userInput
    = UserInput userInput
    | Reset
    | Tick Time


update : (userInput -> Bool) -> Msg userInput -> Model -> Model
update scoreFunction msg model =
    case msg of
        Reset ->
            { model | countdown = model.duration, status = InProgress }

        UserInput userInput ->
            case model.status of
                InProgress ->
                    if scoreFunction userInput then
                        { model | status = InBetween, score = scoreCorrect model.score }
                    else
                        { model | status = InBetween, score = scoreIncorrect model.score }

                _ ->
                    model

        Tick _ ->
            if model.countdown < 0 then
                { model | status = InBetween, score = scoreIncorrect model.score }
            else
                { model | countdown = model.countdown - 1 }


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


subscriptions : Model -> Sub (Msg userInput)
subscriptions model =
    case model.status of
        InProgress ->
            Time.every second Tick

        _ ->
            Sub.none

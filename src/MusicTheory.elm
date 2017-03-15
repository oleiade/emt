module MusicTheory exposing (Mode(..), Note, Scale, scale, diatonicDegreeOf, distance, addInterval)

{-| This library fills a bunch of important niches in Elm. A `Maybe` can help
you with optional arguments, error handling, and records with optional fields.

# Definition
@docs Mode, Note, Scale

# Common Helpers
@docs scale, diatonicDegreeOf, distance, addInterval

-}

import Key
    exposing
        ( Key(..)
        , Adjustment(..)
        , Octave
        , keyToValue
        , keyFromValue
        , diatonicKeyValue
        , diatonicKeyFromValue
        , adjustmentToValue
        , adjustmentFromValue
        )
import Interval exposing (Interval(..), intervalToValue, minorIntervals, majorIntervals)
import Degree exposing (Degree(..), degreeToValue, intervalDegree, substractDegree)
import List
import Tuple exposing (first, second)


{-|
-}
type alias Scale =
    List Int


{-|
-}
type Mode
    = Major
    | Minor


{-|
-}
type alias Note =
    { key : Key
    , adjustment : Adjustment
    , octave : Octave
    }


{-| diatonicDegreeOf will compute the note being the given
degree of a starting note on the diatonic scale
-}
diatonicDegreeOf : Degree -> Note -> Note
diatonicDegreeOf degree note =
    let
        diatonicKey =
            diatonicKeyFromValue <| (%) (diatonicKeyValue note.key + degreeToValue degree) 7

        octaveShift =
            (//) (diatonicKeyValue note.key + degreeToValue degree) 7
    in
        case diatonicKey of
            Just dk ->
                { key = dk, adjustment = Natural, octave = note.octave + octaveShift }

            Nothing ->
                note


{-| distance computes the distance in semitones between two notes
-}
distance : Note -> Note -> Int
distance from to =
    (-) (noteToIndex to) (noteToIndex from)


{-|
-}
addInterval : Note -> Interval -> Note
addInterval note interval =
    let
        newNaturalNote =
            diatonicDegreeOf (intervalDegree interval) note

        intervalSemitones =
            intervalToValue interval

        startToNewNaturalSemitones =
            distance note newNaturalNote

        adjustment =
            adjustmentFromValue (intervalSemitones - startToNewNaturalSemitones)
    in
        { key = newNaturalNote.key, adjustment = adjustment, octave = newNaturalNote.octave }


{-|
-}
octaveOf : Int -> Int
octaveOf value =
    value // 12


{-|
-}
noteOf : Int -> Int
noteOf value =
    value % 12


{-|
-}
keyAtOctave : Key -> Int -> Int
keyAtOctave key octave =
    (keyToValue key) + (12 * octave)


{-|
-}
modeToIntervals : Mode -> List Interval
modeToIntervals mode =
    case mode of
        Major ->
            majorIntervals

        Minor ->
            minorIntervals


{-|
-}
noteToIndex : Note -> Int
noteToIndex note =
    note.octave * 12 + (keyToValue note.key) + (adjustmentToValue note.adjustment)


{-|
-}
scale : Note -> Mode -> Scale
scale note mode =
    List.map (\i -> (noteToIndex note) + intervalToValue i) (modeToIntervals mode)


{-|
-}
contains : List a -> a -> Bool
contains seq v =
    let
        head =
            List.filter (\e -> e == v) seq
    in
        (List.length head) /= 0


{-|
-}
notContains : List a -> a -> Bool
notContains seq v =
    let
        head =
            List.filter (\e -> e == v) seq
    in
        (List.length head) == 0

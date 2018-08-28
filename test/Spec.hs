{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}
module Main where

import Data.Matrix.Static
import Test.Tasty
import Test.Tasty.HUnit

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Unit Tests" [ docExamples ]

docExamples :: TestTree
docExamples =
  let mat33 = fromListUnsafe @3 @3 @Int [1..9]
   in testGroup "Doc examples"
  [ testCase "mapRowUnsafe" $
      mapRowUnsafe (\_ x -> x + 1) 2 mat33 @?=
          fromListUnsafe [1,2,3,5,6,7,7,8,9]
  , testCase "mapRow" $
      mapRow @2 (\_ x -> x + 1) mat33 @?=
          fromListUnsafe [1,2,3,5,6,7,7,8,9]
  , testCase "mapColUnsafe" $
      mapColUnsafe (\_ x -> x + 1) 2 mat33 @?=
          fromListUnsafe [1,3,3,4,6,6,7,9,9]
  , testCase "mapCol" $
      mapCol @2 (\_ x -> x + 1) mat33 @?=
          fromListUnsafe [1,3,3,4,6,6,7,9,9]
#if MIN_VERSION_matrix(0,3,6)
  , testCase "mapPos" $
      mapPos (\(r,c) a -> r - c) mat33 @?=
          fromListUnsafe [0,(-1),(-2),1,0,(-1),2,1,0]
#endif
  , testCase "zero" $
      zero @2 @2 @Int @?= fromListUnsafe [0,0,0,0]
  , testCase "matrix" $
      (matrix (\(i,j) -> 2*i-j) :: Matrix 2 4 Int) @?=
          fromListUnsafe [1,0,(-1),(-2),3,2,1,0]
  , testCase "identity" $
      identity @3 @Int @?=
          fromListUnsafe [1,0,0,0,1,0,0,0,1]
  , testCase "fromList" $
      (fromList [1..9] :: Maybe (Matrix 3 3 Int)) @?=
          (Just $ fromListUnsafe [1,2,3,4,5,6,7,8,9])
  , testCase "fromLists" $
      (fromLists [[1,2,3],[4,5,6],[7,8,9]] :: Maybe (Matrix 3 3 Int)) @?=
          (Just $ fromListUnsafe [1,2,3,4,5,6,7,8,9])
  , testCase "fromListsUnsafe" $
      (fromListsUnsafe [[1,2,3],[4,5,6],[7,8,9]] :: Matrix 3 3 Int) @?=
          fromListUnsafe [1,2,3,4,5,6,7,8,9]
  , testCase "toList" $
      toList mat33 @?= [1..9]
  , testCase "toLists" $
      toLists mat33 @?= [[1,2,3],[4,5,6],[7,8,9]]
  , testCase "permMatrix" $
      permMatrix @3 @2 @3 @Int @?= fromListUnsafe [1,0,0,0,0,1,0,1,0]
  , testCase "permMatrixUnsafe" $
      permMatrixUnsafe @3 @Int 2 3 @?= fromListUnsafe [1,0,0,0,0,1,0,1,0]
  , testCase "getElem" $
      getElem @2 @1 (fromListUnsafe @2 @2 [1..4]) @?= (3 :: Int)
  , testCase "unsafeGet" $
      unsafeGet 2 1 (fromListUnsafe @2 @2 [1..4]) @?= (3 :: Int)
  , testCase "setElem" $
      setElem @1 @2 0 (fromListUnsafe @1 @3 @Int [1,2,3]) @?=
          fromListUnsafe [1,0,3]
  , testCase "transpose" $
      transpose mat33 @?= fromListUnsafe [1,4,7,2,5,8,3,6,9]
  , testCase "extendTo" $
      extendTo @4 @5 0 mat33 @?= 
          fromListUnsafe [1,2,3,0,0,4,5,6,0,0,7,8,9,0,0,0,0,0,0,0]
  , testCase "submatrixUnsafe" $
      submatrixUnsafe @2 @2 1 2 mat33 @?= fromListUnsafe [2,3,5,6]
  , testCase "minorMatrixUnsafe" $
      minorMatrixUnsafe 2 2 mat33 @?= fromListUnsafe [1,3,7,9]
  , testCase "minorMatrix" $
      minorMatrix @2 @2 mat33 @?= fromListUnsafe [1,3,7,9]
  , testCase "splitAndJoin" $
      joinBlocks (splitBlocks @2 @2 mat33) @?= mat33
  , testCase "<|>" $
      fromListUnsafe @2 @2 [1,2,3,4] <|> fromListUnsafe @2 @2 [6,7,8,9] @?=
          fromListUnsafe @2 @4 @Int [1,2,6,7,3,4,8,9]
  ]

------------------------------------------------------------------------
-- The Agda standard library
--
-- Typeclass instances for Covec
------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Codata.Sized.Covec.Instances where

open import Codata.Sized.Covec.Effectful

instance
  covecFunctor = functor
  covecApplicative = applicative

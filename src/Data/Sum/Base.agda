------------------------------------------------------------------------
-- The Agda standard library
--
-- Sums (disjoint unions)
------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Data.Sum.Base where

open import Data.Bool.Base using (true; false)
open import Function.Base using (_∘_; _∘′_; _-⟪_⟫-_ ; id)
open import Level using (Level; _⊔_)

private
  variable
    a b c d : Level
    A : Set a
    B : Set b
    C : Set c
    D : Set d

------------------------------------------------------------------------
-- Definition

infixr 1 _⊎_

data _⊎_ (A : Set a) (B : Set b) : Set (a ⊔ b) where
  inj₁ : (x : A) → A ⊎ B
  inj₂ : (y : B) → A ⊎ B

------------------------------------------------------------------------
-- Functions

[_,_] : ∀ {C : A ⊎ B → Set c} →
        ((x : A) → C (inj₁ x)) → ((x : B) → C (inj₂ x)) →
        ((x : A ⊎ B) → C x)
[ f , g ] (inj₁ x) = f x
[ f , g ] (inj₂ y) = g y

[_,_]′ : (A → C) → (B → C) → (A ⊎ B → C)
[_,_]′ = [_,_]

fromInj₁ : (B → A) → A ⊎ B → A
fromInj₁ = [ id ,_]′

fromInj₂ : (A → B) → A ⊎ B → B
fromInj₂ = [_, id ]′

reduce : A ⊎ A → A
reduce = [ id , id ]′

swap : A ⊎ B → B ⊎ A
swap (inj₁ x) = inj₂ x
swap (inj₂ x) = inj₁ x

map : (A → C) → (B → D) → (A ⊎ B → C ⊎ D)
map f g = [ inj₁ ∘ f , inj₂ ∘ g ]′

map₁ : (A → C) → (A ⊎ B → C ⊎ B)
map₁ f = map f id

map₂ : (B → D) → (A ⊎ B → A ⊎ D)
map₂ = map id

assocʳ : (A ⊎ B) ⊎ C → A ⊎ B ⊎ C
assocʳ = [ map₂ inj₁ , inj₂ ∘′ inj₂ ]′

assocˡ : A ⊎ B ⊎ C → (A ⊎ B) ⊎ C
assocˡ = [ inj₁ ∘′ inj₁ , map₁ inj₂ ]′

infixr 1 _-⊎-_
_-⊎-_ : (A → B → Set c) → (A → B → Set d) → (A → B → Set (c ⊔ d))
f -⊎- g = f -⟪ _⊎_ ⟫- g

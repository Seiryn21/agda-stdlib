------------------------------------------------------------------------
-- The Agda standard library
--
-- Products
------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Data.Product.Base where

open import Function.Base
open import Level

private
  variable
    a b c d e f ℓ p q r : Level
    A : Set a
    B : Set b
    C : Set c
    D : Set d
    E : Set e
    F : Set f

------------------------------------------------------------------------
-- Definition of dependent products

open import Agda.Builtin.Sigma public
  renaming (fst to proj₁; snd to proj₂)
  hiding (module Σ)

module Σ = Agda.Builtin.Sigma.Σ
  renaming (fst to proj₁; snd to proj₂)

-- The syntax declaration below is attached to Σ-syntax, to make it
-- easy to import Σ without the special syntax.

infix 2 Σ-syntax

Σ-syntax : (A : Set a) → (A → Set b) → Set (a ⊔ b)
Σ-syntax = Σ

syntax Σ-syntax A (λ x → B) = Σ[ x ∈ A ] B

------------------------------------------------------------------------
-- Definition of non-dependent products

infixr 4 _,′_
infixr 2 _×_

_×_ : ∀ (A : Set a) (B : Set b) → Set (a ⊔ b)
A × B = Σ[ x ∈ A ] B

_,′_ : A → B → A × B
_,′_ = _,_

------------------------------------------------------------------------
-- Operations over dependent products

infix  4 -,_
infixr 2 _-×-_ _-,-_
infixl 2 _<*>_

-- Sometimes the first component can be inferred.

-,_ : ∀ {A : Set a} {B : A → Set b} {x} → B x → Σ _ B
-, y = _ , y

<_,_> : ∀ {A : Set a} {B : A → Set b} {C : ∀ {x} → B x → Set c}
        (f : (x : A) → B x) → ((x : A) → C (f x)) →
        ((x : A) → Σ (B x) C)
< f , g > x = (f x , g x)

map : ∀ {P : A → Set p} {Q : B → Set q} →
      (f : A → B) → (∀ {x} → P x → Q (f x)) →
      Σ A P → Σ B Q
map f g (x , y) = (f x , g y)

map₁ : (A → B) → A × C → B × C
map₁ f = map f id

map₂ : ∀ {A : Set a} {B : A → Set b} {C : A → Set c} →
       (∀ {x} → B x → C x) → Σ A B → Σ A C
map₂ f = map id f

-- A version of map where the output can depend on the input
dmap : ∀ {B : A → Set b} {P : A → Set p} {Q : ∀ {a} → P a → B a → Set q} →
       (f : (a : A) → B a) → (∀ {a} (b : P a) → Q b (f a)) →
       ((a , b) : Σ A P) → Σ (B a) (Q b)
dmap f g (x , y) = f x , g y

zip : ∀ {P : A → Set p} {Q : B → Set q} {R : C → Set r} →
      (_∙_ : A → B → C) →
      (∀ {x y} → P x → Q y → R (x ∙ y)) →
      Σ A P → Σ B Q → Σ C R
zip _∙_ _∘_ (a , p) (b , q) = ((a ∙ b) , (p ∘ q))

curry : ∀ {A : Set a} {B : A → Set b} {C : Σ A B → Set c} →
        ((p : Σ A B) → C p) →
        ((x : A) → (y : B x) → C (x , y))
curry f x y = f (x , y)

uncurry : ∀ {A : Set a} {B : A → Set b} {C : Σ A B → Set c} →
          ((x : A) → (y : B x) → C (x , y)) →
          ((p : Σ A B) → C p)
uncurry f (x , y) = f x y

-- Rewriting dependent products
assocʳ : {B : A → Set b} {C : (a : A) → B a → Set c} →
          Σ (Σ A B) (uncurry C) → Σ A (λ a → Σ (B a) (C a))
assocʳ ((a , b) , c) = (a , (b , c))

assocˡ : {B : A → Set b} {C : (a : A) → B a → Set c} →
          Σ A (λ a → Σ (B a) (C a)) → Σ (Σ A B) (uncurry C)
assocˡ (a , (b , c)) = ((a , b) , c)

-- Alternate form of associativity for dependent products
-- where the C parameter is uncurried.
assocʳ-curried : {B : A → Set b} {C : Σ A B → Set c} →
                 Σ (Σ A B) C → Σ A (λ a → Σ (B a) (curry C a))
assocʳ-curried ((a , b) , c) = (a , (b , c))

assocˡ-curried : {B : A → Set b} {C : Σ A B → Set c} →
          Σ A (λ a → Σ (B a) (curry C a)) → Σ (Σ A B) C
assocˡ-curried (a , (b , c)) = ((a , b) , c)

------------------------------------------------------------------------
-- Operations for non-dependent products

-- Any of the above operations for dependent products will also work for
-- non-dependent products but sometimes Agda has difficulty inferring
-- the non-dependency. Primed (′ = \prime) versions of the operations
-- are therefore provided below that sometimes have better inference
-- properties.

zip′ : (A → B → C) → (D → E → F) → A × D → B × E → C × F
zip′ f g = zip f g

curry′ : (A × B → C) → (A → B → C)
curry′ = curry

uncurry′ : (A → B → C) → (A × B → C)
uncurry′ = uncurry

map₂′ : (B → C) → A × B → A × C
map₂′ f = map₂ f

dmap′ : ∀ {x y} {X : A → Set x} {Y : B → Set y} →
        ((a : A) → X a) → ((b : B) → Y b) →
        ((a , b) : A × B) → X a × Y b
dmap′ f g = dmap f g

_<*>_ : ∀ {x y} {X : A → Set x} {Y : B → Set y} →
        ((a : A) → X a) × ((b : B) → Y b) →
        ((a , b) : A × B) → X a × Y b
_<*>_ = uncurry dmap′

-- Operations that can only be defined for non-dependent products

swap : A × B → B × A
swap (x , y) = (y , x)

_-×-_ : (A → B → Set p) → (A → B → Set q) → (A → B → Set _)
f -×- g = f -⟪ _×_ ⟫- g

_-,-_ : (A → B → C) → (A → B → D) → (A → B → C × D)
f -,- g = f -⟪ _,_ ⟫- g

-- Rewriting non-dependent products
assocʳ′ : (A × B) × C → A × (B × C)
assocʳ′ ((a , b) , c) = (a , (b , c))

assocˡ′ : A × (B × C) → (A × B) × C
assocˡ′ (a , (b , c)) = ((a , b) , c)

------------------------------------------------------------------------
-- The Agda standard library
--
-- Component functions of permutations found in `Data.Fin.Permutation`
------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Data.Fin.Permutation.Components where

open import Data.Fin
open import Data.Fin.Properties
open import Data.Nat as ℕ using (zero; suc; _∸_)
import Data.Nat.Properties as ℕₚ
open import Data.Product using (proj₂)
open import Relation.Nullary using (yes; no)
open import Relation.Binary.PropositionalEquality
open import Algebra.Definitions using (Involutive)
open ≡-Reasoning

--------------------------------------------------------------------------------
--  Functions
--------------------------------------------------------------------------------

-- 'tranpose i j' swaps the places of 'i' and 'j'.

transpose : ∀ {n} → Fin n → Fin n → Fin n → Fin n
transpose i j k with k ≟ i
... | yes _ = j
... | no  _ with k ≟ j
...   | yes _ = i
...   | no  _ = k

-- reverse i = n ∸ 1 ∸ i

reverse : ∀ {n} → Fin n → Fin n
reverse {suc n} i  = inject≤ (n ℕ- i) (ℕₚ.m∸n≤m (suc n) (toℕ i))

--------------------------------------------------------------------------------
--  Properties
--------------------------------------------------------------------------------

transpose-inverse : ∀ {n} (i j : Fin n) {k} →
                    transpose i j (transpose j i k) ≡ k
transpose-inverse i j {k} with k ≟ j
... | yes p rewrite ≡-≟-identity _≟_ {x = i} refl = sym p
... | no ¬p with k ≟ i
...   | no ¬q rewrite proj₂ (≢-≟-identity _≟_ ¬q)
                    | proj₂ (≢-≟-identity _≟_ ¬p) = refl
...   | yes q with j ≟ i
...     | yes r = trans r (sym q)
...     | no ¬r rewrite ≡-≟-identity _≟_ {x = j} refl = sym q

reverse-prop : ∀ {n} → (i : Fin n) → toℕ (reverse i) ≡ n ∸ suc (toℕ i)
reverse-prop {suc n} i = begin
  toℕ (inject≤ (n ℕ- i) _)  ≡⟨ toℕ-inject≤ _ (ℕₚ.m∸n≤m (suc n) (toℕ i)) ⟩
  toℕ (n ℕ- i)              ≡⟨ toℕ‿ℕ- n i ⟩
  n ∸ toℕ i                 ∎

reverse-involutive : ∀ {n} → Involutive _≡_ (reverse {n})
reverse-involutive {suc n} i = toℕ-injective (begin
  toℕ (reverse (reverse i)) ≡⟨ reverse-prop (reverse i) ⟩
  n ∸ (toℕ (reverse i))     ≡⟨ cong (n ∸_) (reverse-prop i) ⟩
  n ∸ (n ∸ (toℕ i))         ≡⟨ ℕₚ.m∸[m∸n]≡n (ℕₚ.≤-pred (toℕ<n i)) ⟩
  toℕ i                     ∎)

reverse-suc : ∀ {n} {i : Fin n} → toℕ (reverse (suc i)) ≡ toℕ (reverse i)
reverse-suc {n} {i} = begin
  toℕ (reverse (suc i))      ≡⟨ reverse-prop (suc i) ⟩
  suc n ∸ suc (toℕ (suc i))  ≡⟨⟩
  n ∸ toℕ (suc i)            ≡⟨⟩
  n ∸ suc (toℕ i)            ≡⟨ sym (reverse-prop i) ⟩
  toℕ (reverse i)            ∎

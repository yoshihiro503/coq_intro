Require Import Ensembles.

Variable U : Type.
Inductive Finite : Ensemble U -> Prop :=
| Empty_is_finite : Finite (Empty_set U)
| Union_is_finite : forall A : Ensemble U, Finite A -> forall x : U, ~ In U A x -> Finite (Add U A x).
Inductive cardinal : Ensemble U -> nat -> Prop :=
| card_empty : cardinal (Empty_set U) 0
| card_add : forall (A : Ensemble U) (n : nat), cardinal A n -> forall x : U, ~ In U A x -> cardinal (Add U A x) (S n).
Lemma cardinal_zero : forall X : Ensemble U, cardinal X O -> forall x : U, ~ In U X x.
Proof.
  intros.
  inversion H.
  intro.
  unfold In in H1.
  inversion H1.
Qed.
Lemma singleton_add : forall x : U, Singleton U x = Add U (Empty_set U) x.
Proof.
  intros.
  apply Extensionality_Ensembles.
  unfold Same_set.
  split.
  unfold Included.
  intros.
  inversion H.
  unfold In.
  unfold Add.
  subst.
  apply Union_intror.
  apply H.
  unfold Included.
  intros.
  unfold In.
  unfold In in H.
  unfold Add in H.
  destruct H.
  destruct H.
  destruct H.
  reflexivity.
Qed.  
Lemma singleton_one : forall x : U, cardinal (Singleton U x) (S O).
Proof.
  intros.
  assert (Singleton U x = Add U (Empty_set U) x).
  apply singleton_add.
  rewrite H.
  apply card_add.
  apply card_empty.
  intro.
  inversion H0. 
Qed.
Lemma cardinal_invert :
  forall (X : Ensemble U) (p : nat),
    cardinal X p ->
    match p with
    | O => X = Empty_set U
    | S n => exists A : _, (exists x : _, X = Add U A x /\ ~ In U A x /\ cardinal A n)
    end.
Proof.
  intros.
  inversion H.
  reflexivity.
  exists A.
  exists x.
  intuition.
Qed.
Lemma cardinal_elim :
  forall (X : Ensemble U) (p : nat),
    cardinal X p ->
    match p with
    | O => X = Empty_set U
    | S n => Inhabited U X
    end.
Proof.
  intros.
  inversion H.
  reflexivity.
  apply (Inhabited_intro U (Add U A x) x).
  unfold In.
  unfold Add.
  apply Union_intror.
  unfold In.
  intuition.
Qed.  
Lemma positive_cardinal : forall (X : Ensemble U) (n : nat), cardinal X (S n) -> exists x : U, In U X x.
Proof.
  intros.
  apply (cardinal_elim X (S n)) in H.
  destruct H.
  exists x.
  apply H.
Qed.
Lemma union_add : forall (X Y : Ensemble U) (x : U), Union U (Add U X x) Y = Add U (Union U X Y) x.
Proof.
  intros.
  apply Extensionality_Ensembles.
  unfold Same_set.
  split.
  unfold Included.
  intros.
  unfold In.
  unfold Add.
  unfold In in H.
  destruct H.
  unfold In in H.
  unfold Add in H.
  destruct H.
  apply Union_introl.
  unfold In.
  apply Union_introl.
  apply H.
  apply Union_intror.
  apply H.
  apply Union_introl.
  unfold In.
  apply Union_intror.
  apply H.
  unfold Included.
  intros.
  unfold In in H.
  unfold Add in H.
  unfold In.
  destruct H.
  unfold In in H.
  destruct H.
  apply Union_introl.
  unfold In.
  unfold Add.
  apply Union_introl.
  apply H.
  apply Union_intror.
  apply H.
  apply Union_introl.
  unfold In.
  unfold Add.
  apply Union_intror.
  apply H.
Qed.
Lemma union_empty : forall X : Ensemble U, Union U (Empty_set U) X = X.
Proof.
  intros.
  apply Extensionality_Ensembles.
  unfold Same_set.
  split.
  subst.
  unfold Included.
  intros.
  unfold In in H.
  case H.
  intros.
  inversion H0.
  intros.
  apply H0.
  unfold Included.
  intros.
  unfold In.
  apply Union_intror.
  apply H.
Qed.  
Lemma cardinal_disjoint_union : forall (X Y : Ensemble U) (n m : nat), cardinal X n -> cardinal Y m -> Intersection U X Y = Empty_set U -> cardinal (Union U X Y) (n + m).
Proof.
  intros.
  

  
(*
Lemma fin_union : forall X Y : Ensemble U, Finite X -> Finite Y -> Finite (Union U X Y).
Proof.
  intros.
*)  
  

  
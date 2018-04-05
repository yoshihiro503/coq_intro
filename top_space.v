(*
http://ccvanishing.hateblo.jp/entry/2013/01/06/212707
https://gist.github.com/y-taka-23/4466805A
*)
Definition Subset (X : Set) : Type := X -> Prop.
Definition whole (X : Set) : Subset X := fun (x : X) => x = x.
Definition empty (X : Set) : Subset X := fun (x : X) => x <> x.
Inductive incl {X : Set} : Subset X -> Subset X -> Prop :=
| Incl_intro : forall S1 S2 : Subset X,
    (forall x : X, S1 x -> S2 x) ->
    incl S1 S2.
Lemma whole_incl_all {X : Set} : forall U : Subset X, incl U (whole X).
Proof.
  intros.
  apply Incl_intro.
  intros.
  unfold whole.
  auto.
Qed.
Lemma all_incl_empty {X : Set} : forall U : Subset X, incl (empty X) U.
Proof.
  intros.
  apply Incl_intro.
  intros.
  unfold empty in H.
  destruct H.
  auto.
Qed.
Lemma incl_trans {X : Set} : forall U V W : Subset X, incl U V -> incl V W -> incl U W.
Proof.
  intros.
  destruct H.
  destruct H0.
  apply Incl_intro.
  intros.
  auto.
Qed.  
Definition bigcap {X : Set} (I : Set) (index : I -> Subset X) : Subset X :=
  fun (x : X) => forall i : I, (index i) x.
Definition intsec {X : Set} (S1 S2 : Subset X) :=
  let index (b : bool) := match b with
                          | true => S1
                          | false  => S2
                          end in
  bigcap bool index.
Lemma intsec_in {X : Set} : forall (U V : Subset X) (x : X), (intsec U V) x -> U x.
Proof.
  intros.  
  unfold intsec in H.  
  unfold bigcap in H.
  specialize H with true.
  simpl in H.
  apply H.
Qed.  
Lemma intsec_incl {X : Set} : forall U V : Subset X, incl (intsec U V) U.
Proof.  
  intros.
  split.
  apply intsec_in.
Qed.
Lemma intsec_equle {X : Set} : forall U V : Subset X, incl U V -> (forall x : X, (intsec U V) x <-> U x).
Proof.
  intros.
  split.
  apply intsec_in.
  intros.
  unfold intsec.
  unfold bigcap.
  induction i.
  apply H0.
  destruct H.
  auto.
Qed.
Definition bigcup {X : Set} (I : Set) (index : I -> Subset X) : Subset X :=
  fun (x : X) => exists i : I, (index i) x.
Definition union {X : Set} (S1 S2 : Subset X) : Subset X :=
  let index (b : bool) := match b with
                          | true => S1
                          | false => S2
                          end in
  bigcup bool index.
Lemma union_in {X : Set} : forall (U V : Subset X) (x : X), U x -> (union U V) x.
Proof.
  intros.  
  unfold union.  
  unfold bigcup.
  exists true.
  auto.
Qed.
Lemma union_incl {X : Set} : forall U V : Subset X, incl U (union U V).
Proof.  
  intros.
  split.
  intros.
  unfold union.
  unfold bigcup.
  exists true.
  auto.  
Qed.
Lemma union_equle {X : Set} : forall U V : Subset X, incl U V -> (forall x : X, (union U V) x <-> V x).
Proof.
  intros.
  split.  
  intros.
  unfold union in H0.
  unfold bigcup in H0.
  destruct H0.
  induction x0.
  destruct H.
  auto.
  auto.
  intros.
  unfold union.
  unfold bigcup.
  exists false.
  auto.
Qed.
Definition composite {X Y Z : Set} (g : Y -> Z) (f : X -> Y) : X -> Z :=
  fun (x : X) => g (f x).
Definition image {X Y : Set} (f : X -> Y) (U : Subset X) : Subset Y :=
  fun (y : Y) => exists x : X, U x /\ f x = y.
Definition preimage {X Y : Set} (f : X -> Y) (V : Subset Y) : Subset X :=
  fun (x : X) => V (f x).
Lemma im_incl : forall {X Y : Set} (f : X -> Y) (U V : Subset X), incl U V -> incl (image f U) (image f V).
Proof.
  intros.
  apply Incl_intro.
  intros.
  unfold image.
  destruct H0.
  destruct H.
  exists x0.
  split.
  apply H.
  apply H0.
  apply H0.
Qed.
Axiom subset_equal : forall {X : Set} (U V : Subset X), U = V <-> forall x : X, U x <-> V x.
Lemma incl_intsec : forall {X : Set} (U V W : Subset X), incl W U -> incl W V -> incl W (intsec U V).
Proof.
  intros.
  apply Incl_intro.
  intros.
  destruct H.
  destruct H0.
  unfold intsec.
  unfold bigcap.
  induction i.
  auto.
  auto.
Qed.
Lemma intsec_comm : forall {X : Set} (U V : Subset X), intsec U V = intsec V U.
Proof.
  intros.
  apply subset_equal.
  intros.
  split.
  intros.
  unfold intsec.
  unfold bigcap.
  induction i.
  unfold intsec in H.
  unfold bigcap in H.
  specialize H with false.
  auto.
  unfold intsec in H.
  unfold bigcap in H.
  specialize H with true.
  auto.
  intros.
  unfold intsec.
  unfold bigcap.
  induction i.
  unfold intsec in H.
  unfold bigcap in H.
  specialize H with false.
  auto.
  unfold intsec in H.
  unfold bigcap in H.
  specialize H with true.
  auto.
Qed.  
Lemma im_intsec : forall {X Y : Set} (f : X -> Y) (U V : Subset X), incl (image f (intsec U V)) (intsec (image f U) (image f V)).
Proof.
  intros.
  assert (incl (image f (intsec U V)) (image f U)).
  apply im_incl.
  apply intsec_incl.
  assert (incl (image f (intsec U V)) (image f V)).
  apply im_incl.
  assert (intsec U V = intsec V U).
  apply intsec_comm.
  rewrite H0.
  apply intsec_incl.
  apply incl_intsec.
  auto.
  auto.
Qed.  
Lemma im_union : forall {X Y : Set} (f : X -> Y) (U V : Subset X), union (image f U) (image f V) = image f (union U V).
Proof.
  intros.
  apply subset_equal.
  split.
  unfold union.
  unfold bigcup.
  intros.
  unfold image.
  destruct H.
  induction x0.
  unfold image in H.
  destruct H.
  exists x0.
  split.
  exists true.
  apply H.
  apply H.
  destruct H.
  exists x0.
  split.
  exists false.
  apply H.
  apply H.
  intros.
  unfold union.
  unfold bigcup.
  destruct H.
  destruct H.
  destruct H.
  induction x1.
  assert ((image f U) x).
  unfold image.
  exists x0.
  auto.
  
  



  
  (* Lemma preim_incl : forall *)
  (* Lemma preim_intsec *)
  (* Lemma preim_union *)
  (* Lemma im_preim *)
  (* Lemma preim_im *)
  (* Lemma compos_preim *)
  (* Lemma compos_im *)
  

Class TopSpace (X : Set) (Open : Subset X -> Prop) :=
  {
    TS_whole : Open (whole X);
    TS_empty : Open (empty X);
    TS_intsec : forall U1 U2 : Subset X,
        Open U1 -> Open U2 -> Open (intsec U1 U2);
    TS_union : forall (I : Set) (index : I -> Subset X),
        (forall i : I, Open (index i)) -> Open (bigcup I index)
  }.
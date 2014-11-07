
module Stlc
open Prims.PURE

type ty =
  | TBool  : ty
  | TArrow : ty -> ty -> ty

type exp =
  | EVar   : int -> exp
  | EApp   : exp -> exp -> exp
  | EAbs   : int -> ty -> exp -> exp
  | ETrue  : exp
  | EFalse : exp
  | EIf    : exp -> exp -> exp -> exp

val is_value : exp -> Tot bool
let is_value e =
  match e with
  | EAbs _ _ _ -> true
  | ETrue      -> true
  | EFalse     -> true
  | _          -> false

(* Because we only consider call-by-value reduction, we will ever only
   substitute closed values, so this definition of substitution is
   good enough *)
val subst : int -> exp -> exp -> Tot exp
let rec subst x e e' =
  match e' with
  | EVar x' -> if x = x' then e else e'
  | EAbs x' t e1 ->
      EAbs x' t (if x = x' then e1 else (subst x e e1))
  | EApp e1 e2 -> EApp (subst x e e1) (subst x e e2)
  | ETrue -> ETrue
  | EFalse -> EFalse
  | EIf e1 e2 e3 -> EIf (subst x e e1) (subst x e e2) (subst x e e3)

val step : exp -> Tot (option exp)
let rec step e =
  match e with
  | EApp e1 e2 ->
      if is_value e1 then
        if is_value e2 then
          match e1 with
          | EAbs x t e' -> Some (subst x e2 e')
          | _           -> None
        else
          match (step e2) with
          | Some e2' -> Some (EApp e1 e2')
          | None     -> None
      else begin
        match (step e1) with
        | Some e1' -> Some (EApp e1' e2)
        | None     -> None
      end
  | EIf e1 e2 e3 ->
      if is_value e1 then
        match e1 with
        | ETrue   -> Some e2
        | EFalse  -> Some e3
        | _       -> None
      else begin
        match (step e1) with
        | Some e1' -> Some (EIf e1' e2 e3)
        | None     -> None
      end
  | _ -> None

type env = int -> Tot (option ty)

val empty : env
let empty _ = None

(* CH: This should work but it seems that F* stumbles upon the type abbreviation
val extend : env -> int -> ty -> Tot env
let extend g x t  = (fun x' -> if x = x' then Some t else g x')
   Now it stumbles a bit later below:
bug23.fst(8,31-8,32) : Error
Too many arguments to function of type (_:env -> _:int -> _:ty -> Tot env)
*)

val extend : env -> int -> ty -> int -> Tot (option ty)
let extend g x t  = (fun x' -> if x = x' then Some t else g x')

let x45 = extend (extend empty 42 TBool) 0 (TArrow TBool TBool)

val extend_eq : g:env -> x:int -> a:ty -> Fact unit
      (ensures ((extend g x a) x) = Some a)
let extend_eq g x a = ()

val extend_neq : g:env -> x1:int -> a:ty -> x2:int -> Pure unit
      (requires (x1 <> x2))
      (ensures \r -> ((extend g x1 a) x2) = g x2)
let extend_neq g x1 a x2 = ()

(* CH: swapped env and exp args until functions are ignored from the
   lex ordering or until we can write decreasing clauses *)
val typing : exp -> env -> Tot (option ty)
let rec typing e g =
  match e with
  | EVar x -> g x
  | EAbs x t e1 -> begin
      match typing e1 (extend g x t) with
      | Some t' -> Some (TArrow t t')
      | None    -> None
      end
  | EApp e1 e2 -> begin
      match typing e1 g, typing e2 g with
      | Some (TArrow t11 t12), Some t2 -> if t11 = t2 then Some t12 else None
      | _                    , _       -> None
      end
  | ETrue  -> Some TBool
  | EFalse -> Some TBool
  | EIf e1 e2 e3 -> begin
      match typing e1 g, typing e2 g, typing e3 g with
      | Some TBool, Some t2, Some t3 -> if t2 = t3 then Some t2 else None
      | _         , _      , _       -> None
       end
  | _ -> None

(* This proof should really be trivial (see canonical_forms_fun below) *)
val canonical_forms_bool : e:exp -> Pure unit
      (requires ((typing e empty = Some TBool) /\ (is_value e = true)))
      (ensures \r -> (e = ETrue) \/ (e = EFalse))
let canonical_forms_bool e =
  match e with
  | EVar x -> ()
  | EAbs x' t e1 -> begin
      admit()
      (* F* can't prove this simple case, we should get a contradition *)
     (* this causes the whole thing to explode! 3 different bogus errors!
      match typing e1 (extend empty x' t) with
      | Some t' -> admit()
      | None    -> admit() *)
      (* This assert fails, but it shouldn't
      assert(exists (t1:ty). exists (t2:ty).
               typing (EAbs x' t e1) empty = Some (TArrow t1 t2) \/
               typing (EAbs x' t e1) empty = None);  *)
      (* this doesn't bring much
      match typing e empty with
      | Some (TArrow t1 t2) -> ()
      | Some TBool -> admit()
      | _ -> () *)
      end
  | EApp e1 e2 -> ()
  | ETrue -> ()
  | EFalse -> ()
  | EIf e1 e2 e3 -> ()

val canonical_forms_fun : e:exp -> t1:ty -> t2:ty -> Pure unit
      (requires ((typing e empty = Some (TArrow t1 t2)) /\ (is_value e = true)))
      (ensures \r -> (is_EAbs e))
let canonical_forms_fun e t1 t2 = ()

(* "An unknown assertion in the term at this location was not provable."
   No wonder that the first case of progress fails.
   Logic encoding of empty looks reasonable, Z3 should be able to prove this.
   Is the encoding of is_None broken? I wasn't able to find any equations for it.
   Only Prims.fst and Prims.snd get equations? *)
val sel_empty : x:int -> Fact unit
      (ensures (is_None (empty x)))
let sel_empty x = ()

(* "An unknown assertion in the term at this location was not provable."
   The (for some reason) unprovable query looks like this:
   (= (Prims.op_Equality (Prims.option Stlc.ty)
                         (Stlc.empty x___844)
                         (Prims.None Stlc.ty))
      (BoxBool true)) *)
val sel_empty' : x:int -> Fact unit
      (ensures (empty x = None))
let sel_empty' x = ()

val progress : e:exp -> t:ty -> Pure unit
      (requires (typing e empty = Some t))
      (ensures \r -> (is_value e \/ (is_Some (step e))))
let rec progress e t =
  match e with
  | EVar x ->
      (* assert(typing (EVar x) empty = None);
         -- this fails and it shouldn't; the case should be trivial
         -- spawned it off as a lemma above for further investigation *)
      admit()
  | EApp e1 e2 -> begin
      match typing e1 empty with
      | Some (TArrow t1 t2) ->
          progress e1 (TArrow t1 t2); progress e2 t1
      end
  | EIf e1 e2 e3 ->
      progress e1 TBool; progress e2 t; progress e3 t;
      if is_value e1 then canonical_forms_bool e1
  | _ -> ()

val appears_free_in : x:int -> e:exp -> Tot bool
let rec appears_free_in x e =
  match e with
  | EVar y -> x = y
  | EApp e1 e2 -> appears_free_in x e1 || appears_free_in x e2
  | EAbs y _ e1 -> x <> y && appears_free_in x e1
  | EIf e1 e2 e3 ->
      appears_free_in x e1 || appears_free_in x e2 || appears_free_in x e3
  | _ -> false

type closed e = (forall (x:int). not (appears_free_in x e))

(* Adding the rec keyword on this one makes it blow up,
   no matter what's inside it, triggered by the function argument?
   Filed as: https://github.com/FStarLang/FStar/issues/43 *)
val free_in_context : x:int -> e:exp -> t:ty -> g:env -> Pure unit
      (requires (appears_free_in x e /\ typing e g = Some t))
      (ensures \r -> (is_Some (g x)))
let (* rec *) free_in_context x e t g =
  match e with
  | EAbs y _ e1 ->
      begin
      match typing e g with
      | Some (TArrow t1 t2) ->
          admit() (* free_in_context x e1 t2 (extend g y t1) *)
      | _ -> admit() (* F* can't prove this is unreachable *)
      end
  | EApp e1 e2 -> begin
      match typing e1 g with
      | Some (TArrow t1 t2) ->
          if appears_free_in x e1 then
            admit() (* free_in_context x e1 (TArrow t1 t2) *)
          else
            admit() (* free_in_context x e2 t1 *)
      end
  | EIf e1 e2 e3 -> begin
      if appears_free_in x e1 then
        admit() (* free_in_context x e1 TBool *)
      else if appears_free_in x e2 then
        admit() (* free_in_context x e2 t *)
      else
        admit() (* free_in_context x e3 t *)
      end
  | _ -> ()

(* Corollary of free_in_context *)
val typable_empty_closed : x:int -> e:exp -> Pure unit
      (requires (is_Some (typing e empty)))
      (ensures \r -> closed e)
let typable_empty_closed x e =
  match typing e empty with
  | Some t -> admit() (* free_in_context x e t empty -- this blows up
                         Filed as: https://github.com/FStarLang/FStar/issues/46 *)

val context_invariance : g:env -> g':env -> e:exp -> t:ty -> Pure unit
      (requires (typing e g = Some t /\
                (forall (x:int). appears_free_in x e ==> g x = g' x)))
      (ensures \r -> (typing e g' = Some t))
let rec context_invariance g g' e t =
  match e with
  | EAbs x t e1 -> begin
      (* bogus incomplete patterns error,
         even when I do write the None pattern,
         (I shouldn't have to, because that's unreachable anyway)
         + equaly bogus bad postcondition error, both branches are admitted!
         Simplified and filed as: https://github.com/FStarLang/FStar/issues/44
         and https://github.com/FStarLang/FStar/issues/45 *)
      match typing e1 (extend g x t) with
      | Some t' ->
          context_invariance (extend g x t) (extend g' x t) e1 t';
          admit()
      | None -> admit()
      end
  | EApp e1 e2 -> begin
      match typing e1 g with
      | Some (TArrow t1 t2) ->
          context_invariance g g' e1 (TArrow t1 t2);
          context_invariance g g' e2 t1
      end
  | EIf e1 e2 e3 ->
      context_invariance g g' e1 TBool;
      context_invariance g g' e2 t;
      context_invariance g g' e3 t
  | _ -> ()

(* This is a complete disaster, the typing e (extend g x u) = Some t
   assumption seems to be not usable at all in the proof *)
val substitution_preserves_typing :
      g:env -> x:int -> e:exp -> u:ty -> t:ty -> v:exp -> Pure unit
          (requires (typing e (extend g x u) = Some t /\
                     typing v empty = Some u))
          (ensures \r -> (typing (subst x v e) g = Some t))
let substitution_preserves_typing g x e u t v =
  typable_empty_closed x v;
  match e with
  | EVar x' -> (* (subst x v e) = if x = x' then e else e' *)
      (* assert(typing e (extend g x u) = (extend g x u) x);
           -- this should work but it fails (just unfolding definition) *)
      if x = x' then begin
        extend_eq g x u;
        assert(x = x'); assert(e = EVar x);
        (* assert(u = t);  -- this should work but it fails *)
        admit()
      end else begin
        assert(x<>x');
        extend_neq g x u x';
        admit()
      end
  | EAbs x' t e1 ->
      admit() (* EAbs x t (if x = x' then e1 else (subst x e e1)) *)
  | EApp e1 e2 ->
      admit() (* EApp (subst x e e1) (subst x e e2) *)
  | ETrue ->
      (* assert(t = TBool); -- this should be provable but it currently fails *)
      admit() (* ETrue *)
  | EFalse ->
      admit() (* EFalse *)
  | EIf e1 e2 e3 ->
      admit() (* EIf (subst x e e1) (subst x e e2) (subst x e e3) *)

val preservation : e:exp -> e':exp -> t:ty -> Pure unit
      (requires (typing e empty = Some t /\ step e = Some e'))
      (ensures \r -> (typing e' empty = Some t))
let rec preservation e e' t =
  match e with
  | EApp e1 e2 -> begin
      match typing e1 empty with
      | Some (TArrow t1 t2) -> begin
          assert(typing e2 empty = Some t1); (* -- works *)
          assert(typing e empty = Some t2); (* -- works *)
          if is_value e1 then
            if is_value e2 then
              match e1 with
              | EAbs x t e' ->
                  assert(step e = Some (subst x e2 e')); (* -- works *)
(*                  assert (t = t1); -- this should work, but it doesn't *)
(*                  assert(typing e' (extend empty x t1) = Some t2);
                      -- this should work, but it doesn't *)
(*                  substitution_preserves_typing empty x e' t1 t2 e2
                      -- this should work, but now precondition fails *)
                  admit()
            else
              match (step e2) with
              | Some e2' -> preservation e2 e2' t1
          else
            match (step e1) with
            | Some e1' -> preservation e1 e1' (TArrow t1 t2)
          end
      end
  | EIf e1 _ _ ->
      if is_value e1 then ()
      else begin
        match (step e1) with
        | Some e1' -> preservation e1 e1' TBool
      end
  | _ -> ()

(* CH: With this purely-executable way of specifying things we can't
   do rule induction, and that is restrictive and will probably lead
   to rather unnatural proofs. *)
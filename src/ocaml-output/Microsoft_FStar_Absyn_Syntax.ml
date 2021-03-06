
exception Err of (string)

exception Error of ((string * Support.Microsoft.FStar.Range.range))

exception Warning of ((string * Support.Microsoft.FStar.Range.range))

type ident =
{idText : string; idRange : Support.Microsoft.FStar.Range.range}

type l__LongIdent =
{ns : ident list; ident : ident; nsstr : string; str : string}

type lident =
l__LongIdent

type ('a, 't) withinfo_t =
{v : 'a; sort : 't; p : Support.Microsoft.FStar.Range.range}

type 't var =
(lident, 't) withinfo_t

type fieldname =
lident

type 'a inst =
'a option ref

type 'a bvdef =
{ppname : ident; realname : ident}

type ('a, 't) bvar =
('a bvdef, 't) withinfo_t

type sconst =
| Const_unit
| Const_uint8 of Support.Prims.byte
| Const_bool of bool
| Const_int32 of Support.Prims.int32
| Const_int64 of Int64.t
| Const_int of int
| Const_char of char
| Const_float of Support.Prims.double
| Const_bytearray of (Support.Prims.byte array * Support.Microsoft.FStar.Range.range)
| Const_string of (Support.Prims.byte array * Support.Microsoft.FStar.Range.range)

type pragma =
| SetOptions of string
| ResetOptions

type 'a memo =
'a option ref

type arg_qualifier =
| Implicit
| Equality

type aqual =
arg_qualifier option

type typ' =
| Typ_btvar of btvar
| Typ_const of ftvar
| Typ_fun of (binders * comp)
| Typ_refine of (bvvar * typ)
| Typ_app of (typ * args)
| Typ_lam of (binders * typ)
| Typ_ascribed of (typ * knd)
| Typ_meta of meta_t
| Typ_uvar of (uvar_t * knd)
| Typ_delayed of (((typ * subst_t), unit  ->  typ) Support.Microsoft.FStar.Util.either * typ memo)
| Typ_unknown and comp_typ =
{effect_name : lident; result_typ : typ; effect_args : args; flags : cflags list} and comp' =
| Total of typ
| Comp of comp_typ and cflags =
| TOTAL
| MLEFFECT
| RETURN
| PARTIAL_RETURN
| SOMETRIVIAL
| LEMMA
| DECREASES of exp and meta_t =
| Meta_pattern of (typ * arg list)
| Meta_named of (typ * lident)
| Meta_labeled of (typ * string * Support.Microsoft.FStar.Range.range * bool)
| Meta_refresh_label of (typ * bool option * Support.Microsoft.FStar.Range.range)
| Meta_slack_formula of (typ * typ * bool ref) and 'a uvar_basis =
| Uvar
| Fixed of 'a and exp' =
| Exp_bvar of bvvar
| Exp_fvar of (fvvar * bool)
| Exp_constant of sconst
| Exp_abs of (binders * exp)
| Exp_app of (exp * args)
| Exp_match of (exp * (pat * exp option * exp) list)
| Exp_ascribed of (exp * typ)
| Exp_let of (letbindings * exp)
| Exp_uvar of (uvar_e * typ)
| Exp_delayed of (exp * subst_t * exp memo)
| Exp_meta of meta_e and meta_e =
| Meta_desugared of (exp * meta_source_info) and meta_source_info =
| Data_app
| Sequence
| Primop
| MaskedEffect and pat' =
| Pat_disj of pat list
| Pat_constant of sconst
| Pat_cons of (fvvar * pat list)
| Pat_var of (bvvar * bool)
| Pat_tvar of btvar
| Pat_wild of bvvar
| Pat_twild of btvar
| Pat_dot_term of (bvvar * exp)
| Pat_dot_typ of (btvar * typ) and knd' =
| Kind_type
| Kind_effect
| Kind_abbrev of (kabbrev * knd)
| Kind_arrow of (binders * knd)
| Kind_uvar of uvar_k_app
| Kind_lam of (binders * knd)
| Kind_delayed of (knd * subst_t * knd memo)
| Kind_unknown and freevars =
{ftvs : btvar Support.Microsoft.FStar.Util.set; fxvs : bvvar Support.Microsoft.FStar.Util.set} and uvars =
{uvars_k : uvar_k Support.Microsoft.FStar.Util.set; uvars_t : (uvar_t * knd) Support.Microsoft.FStar.Util.set; uvars_e : (uvar_e * typ) Support.Microsoft.FStar.Util.set} and ('a, 'b) syntax =
{n : 'a; tk : 'b memo; pos : Support.Microsoft.FStar.Range.range; fvs : freevars memo; uvs : uvars memo} and arg =
((typ, exp) Support.Microsoft.FStar.Util.either * aqual) and args =
arg list and binder =
((btvar, bvvar) Support.Microsoft.FStar.Util.either * arg_qualifier option) and binders =
binder list and typ =
(typ', knd) syntax and comp =
(comp', unit) syntax and uvar_t =
typ uvar_basis Support.Microsoft.FStar.Unionfind.uvar and exp =
(exp', typ) syntax and uvar_e =
exp uvar_basis Support.Microsoft.FStar.Unionfind.uvar and btvdef =
typ bvdef and bvvdef =
exp bvdef and pat =
(pat', (knd, typ) Support.Microsoft.FStar.Util.either option) withinfo_t and knd =
(knd', unit) syntax and uvar_k_app =
(uvar_k * args) and kabbrev =
(lident * args) and uvar_k =
knd uvar_basis Support.Microsoft.FStar.Unionfind.uvar and lbname =
(bvvdef, lident) Support.Microsoft.FStar.Util.either and letbindings =
(bool * (lbname * typ * exp) list) and subst_t =
subst_elt list list and subst_map =
(typ, exp) Support.Microsoft.FStar.Util.either Support.Microsoft.FStar.Util.smap and subst_elt =
((btvdef * typ), (bvvdef * exp)) Support.Microsoft.FStar.Util.either and fvar =
(btvdef, bvvdef) Support.Microsoft.FStar.Util.either and btvar =
(typ, knd) bvar and bvvar =
(exp, typ) bvar and ftvar =
knd var and fvvar =
typ var

type subst =
subst_elt list

type either_var =
(btvar, bvvar) Support.Microsoft.FStar.Util.either

type freevars_l =
either_var list

type formula =
typ

type formulae =
typ list

type qualifier =
| Private
| Assumption
| Opaque
| Logic
| Discriminator of lident
| Projector of (lident * (btvdef, bvvdef) Support.Microsoft.FStar.Util.either)
| RecordType of ident list
| RecordConstructor of ident list
| ExceptionConstructor
| DefaultEffect of lident option
| TotalEffect
| HasMaskedEffect
| Effect

type tycon =
(lident * binders * knd)

type monad_abbrev =
{mabbrev : lident; parms : binders; def : typ}

type sub_eff =
{source : lident; target : lident; lift : typ}

type eff_decl =
{mname : lident; binders : binders; qualifiers : qualifier list; signature : knd; ret : typ; bind_wp : typ; bind_wlp : typ; if_then_else : typ; ite_wp : typ; ite_wlp : typ; wp_binop : typ; wp_as_type : typ; close_wp : typ; close_wp_t : typ; assert_p : typ; assume_p : typ; null_wp : typ; trivial : typ} and sigelt =
| Sig_tycon of (lident * binders * knd * lident list * lident list * qualifier list * Support.Microsoft.FStar.Range.range)
| Sig_kind_abbrev of (lident * binders * knd * Support.Microsoft.FStar.Range.range)
| Sig_typ_abbrev of (lident * binders * knd * typ * qualifier list * Support.Microsoft.FStar.Range.range)
| Sig_datacon of (lident * typ * tycon * qualifier list * lident list * Support.Microsoft.FStar.Range.range)
| Sig_val_decl of (lident * typ * qualifier list * Support.Microsoft.FStar.Range.range)
| Sig_assume of (lident * formula * qualifier list * Support.Microsoft.FStar.Range.range)
| Sig_let of (letbindings * Support.Microsoft.FStar.Range.range * lident list * qualifier list)
| Sig_main of (exp * Support.Microsoft.FStar.Range.range)
| Sig_bundle of (sigelt list * qualifier list * lident list * Support.Microsoft.FStar.Range.range)
| Sig_new_effect of (eff_decl * Support.Microsoft.FStar.Range.range)
| Sig_sub_effect of (sub_eff * Support.Microsoft.FStar.Range.range)
| Sig_effect_abbrev of (lident * binders * comp * qualifier list * Support.Microsoft.FStar.Range.range)
| Sig_pragma of (pragma * Support.Microsoft.FStar.Range.range)

type sigelts =
sigelt list

type modul =
{name : lident; declarations : sigelts; exports : sigelts; is_interface : bool; is_deserialized : bool}

type ktec =
| K of knd
| T of (typ * knd option)
| E of exp
| C of comp

type lcomp =
{eff_name : lident; res_typ : typ; cflags : cflags list; comp : unit  ->  comp}

type path =
string list

let dummyRange = 0L

let withinfo = (fun v s r -> {v = v; sort = s; p = r})

let withsort = (fun v s -> (withinfo v s dummyRange))

let mk_ident = (fun _28758 -> (match (_28758) with
| (text, range) -> begin
{idText = text; idRange = range}
end))

let id_of_text = (fun str -> (mk_ident (str, dummyRange)))

let text_of_id = (fun id -> id.idText)

let text_of_path = (fun path -> (Support.Microsoft.FStar.Util.concat_l "." path))

let path_of_text = (fun text -> (Support.String.split (('.')::[]) text))

let path_of_ns = (fun ns -> (Support.List.map text_of_id ns))

let path_of_lid = (fun lid -> (Support.List.map text_of_id (Support.List.append lid.ns ((lid.ident)::[]))))

let ids_of_lid = (fun lid -> (Support.List.append lid.ns ((lid.ident)::[])))

let lid_of_ids = (fun ids -> (let _28769 = (Support.Microsoft.FStar.Util.prefix ids)
in (match (_28769) with
| (ns, id) -> begin
(let nsstr = (text_of_path (Support.List.map text_of_id ns))
in {ns = ns; ident = id; nsstr = nsstr; str = if (nsstr = "") then begin
id.idText
end else begin
(Support.String.strcat (Support.String.strcat nsstr ".") id.idText)
end})
end)))

let lid_of_path = (fun path pos -> (let ids = (Support.List.map (fun s -> (mk_ident (s, pos))) path)
in (lid_of_ids ids)))

let text_of_lid = (fun lid -> lid.str)

let lid_equals = (fun l1 l2 -> (l1.str = l2.str))

let bvd_eq = (fun bvd1 bvd2 -> (bvd1.realname.idText = bvd2.realname.idText))

let order_bvd = (fun x y -> (match ((x, y)) with
| (Support.Microsoft.FStar.Util.Inl (_), Support.Microsoft.FStar.Util.Inr (_)) -> begin
(- (1))
end
| (Support.Microsoft.FStar.Util.Inr (_), Support.Microsoft.FStar.Util.Inl (_)) -> begin
1
end
| (Support.Microsoft.FStar.Util.Inl (x), Support.Microsoft.FStar.Util.Inl (y)) -> begin
(Support.String.compare x.realname.idText y.realname.idText)
end
| (Support.Microsoft.FStar.Util.Inr (x), Support.Microsoft.FStar.Util.Inr (y)) -> begin
(Support.String.compare x.realname.idText y.realname.idText)
end))

let lid_with_range = (fun lid r -> (let id = (let _28809 = lid.ident
in {idText = _28809.idText; idRange = r})
in (let _28812 = lid
in {ns = _28812.ns; ident = id; nsstr = _28812.nsstr; str = _28812.str})))

let range_of_lid = (fun lid -> lid.ident.idRange)

let range_of_lbname = (fun l -> (match (l) with
| Support.Microsoft.FStar.Util.Inl (x) -> begin
x.ppname.idRange
end
| Support.Microsoft.FStar.Util.Inr (l) -> begin
(range_of_lid l)
end))

let syn = (fun p k f -> (f k p))

let mk_fvs = (fun _28823 -> (match (_28823) with
| () -> begin
(Support.Microsoft.FStar.Util.mk_ref None)
end))

let mk_uvs = (fun _28824 -> (match (_28824) with
| () -> begin
(Support.Microsoft.FStar.Util.mk_ref None)
end))

let new_ftv_set = (fun _28825 -> (match (_28825) with
| () -> begin
(Support.Microsoft.FStar.Util.new_set (fun x y -> (Support.Microsoft.FStar.Util.compare x.v.realname.idText y.v.realname.idText)) (fun x -> (Support.Microsoft.FStar.Util.hashcode x.v.realname.idText)))
end))

let new_uv_set = (fun _28829 -> (match (_28829) with
| () -> begin
(Support.Microsoft.FStar.Util.new_set (fun x y -> ((Support.Microsoft.FStar.Unionfind.uvar_id x) - (Support.Microsoft.FStar.Unionfind.uvar_id y))) (Support.Microsoft.FStar.Unionfind.uvar_id))
end))

let new_uvt_set = (fun _28832 -> (match (_28832) with
| () -> begin
(Support.Microsoft.FStar.Util.new_set (fun _28840 _28844 -> (match ((_28840, _28844)) with
| ((x, _), (y, _)) -> begin
((Support.Microsoft.FStar.Unionfind.uvar_id x) - (Support.Microsoft.FStar.Unionfind.uvar_id y))
end)) (fun _28836 -> (match (_28836) with
| (x, _) -> begin
(Support.Microsoft.FStar.Unionfind.uvar_id x)
end)))
end))

let no_fvs = {ftvs = (new_ftv_set ()); fxvs = (new_ftv_set ())}

let no_uvs = {uvars_k = (new_uv_set ()); uvars_t = (new_uvt_set ()); uvars_e = (new_uvt_set ())}

let memo_no_uvs = (Support.Microsoft.FStar.Util.mk_ref (Some (no_uvs)))

let memo_no_fvs = (Support.Microsoft.FStar.Util.mk_ref (Some (no_fvs)))

let freevars_of_list = (fun l -> ((Support.List.fold_left (fun out _28506 -> (match (_28506) with
| Support.Microsoft.FStar.Util.Inl (btv) -> begin
(let _28850 = out
in {ftvs = (Support.Microsoft.FStar.Util.set_add btv out.ftvs); fxvs = _28850.fxvs})
end
| Support.Microsoft.FStar.Util.Inr (bxv) -> begin
(let _28854 = out
in {ftvs = _28854.ftvs; fxvs = (Support.Microsoft.FStar.Util.set_add bxv out.fxvs)})
end)) no_fvs) l))

let list_of_freevars = (fun fvs -> (Support.List.append ((Support.List.map (fun x -> Support.Microsoft.FStar.Util.Inl (x))) (Support.Microsoft.FStar.Util.set_elements fvs.ftvs)) ((Support.List.map (fun x -> Support.Microsoft.FStar.Util.Inr (x))) (Support.Microsoft.FStar.Util.set_elements fvs.fxvs))))

let get_unit_ref = (fun _28859 -> (match (_28859) with
| () -> begin
(let x = (Support.Microsoft.FStar.Util.mk_ref (Some (())))
in (let _28861 = (x := None)
in x))
end))

let mk_Kind_type = {n = Kind_type; tk = (get_unit_ref ()); pos = dummyRange; fvs = (mk_fvs ()); uvs = (mk_uvs ())}

let mk_Kind_effect = {n = Kind_effect; tk = (get_unit_ref ()); pos = dummyRange; fvs = (mk_fvs ()); uvs = (mk_uvs ())}

let mk_Kind_abbrev = (fun _28865 p -> (match (_28865) with
| (kabr, k) -> begin
{n = Kind_abbrev ((kabr, k)); tk = (get_unit_ref ()); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Kind_arrow = (fun _28869 p -> (match (_28869) with
| (bs, k) -> begin
{n = Kind_arrow ((bs, k)); tk = (get_unit_ref ()); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Kind_arrow' = (fun _28873 p -> (match (_28873) with
| (bs, k) -> begin
(match (bs) with
| [] -> begin
k
end
| _ -> begin
(match (k.n) with
| Kind_arrow ((bs', k')) -> begin
(mk_Kind_arrow ((Support.List.append bs bs'), k') p)
end
| _ -> begin
(mk_Kind_arrow (bs, k) p)
end)
end)
end))

let mk_Kind_uvar = (fun uv p -> {n = Kind_uvar (uv); tk = (get_unit_ref ()); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Kind_lam = (fun _28888 p -> (match (_28888) with
| (vs, k) -> begin
{n = Kind_lam ((vs, k)); tk = (get_unit_ref ()); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Kind_delayed = (fun _28893 p -> (match (_28893) with
| (k, s, m) -> begin
{n = Kind_delayed ((k, s, m)); tk = (get_unit_ref ()); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Kind_unknown = {n = Kind_unknown; tk = (get_unit_ref ()); pos = dummyRange; fvs = (mk_fvs ()); uvs = (mk_uvs ())}

let get_knd_nref = (fun _28895 -> (match (_28895) with
| () -> begin
(let x = (Support.Microsoft.FStar.Util.mk_ref (Some (mk_Kind_unknown)))
in (let _28897 = (x := None)
in x))
end))

let get_knd_ref = (fun k -> (let x = (Support.Microsoft.FStar.Util.mk_ref (Some (mk_Kind_unknown)))
in (let _28901 = (x := k)
in x)))

let mk_Typ_btvar = (fun x k p -> {n = Typ_btvar (x); tk = (get_knd_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Typ_const = (fun x k p -> {n = Typ_const (x); tk = (get_knd_ref k); pos = p; fvs = memo_no_fvs; uvs = memo_no_uvs})

let rec check_fun = (fun bs c p -> (match (bs) with
| [] -> begin
(failwith "Empty binders")
end
| _ -> begin
Typ_fun ((bs, c))
end))

let mk_Typ_fun = (fun _28917 k p -> (match (_28917) with
| (bs, c) -> begin
{n = (check_fun bs c p); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_refine = (fun _28922 k p -> (match (_28922) with
| (x, phi) -> begin
{n = Typ_refine ((x, phi)); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_app = (fun _28927 k p -> (match (_28927) with
| (t1, args) -> begin
{n = (match (args) with
| [] -> begin
(failwith "Empty arg list!")
end
| _ -> begin
Typ_app ((t1, args))
end); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_app' = (fun _28935 k p -> (match (_28935) with
| (t1, args) -> begin
(match (args) with
| [] -> begin
t1
end
| _ -> begin
(mk_Typ_app (t1, args) k p)
end)
end))

let extend_typ_app = (fun _28943 k p -> (match (_28943) with
| (t, arg) -> begin
(match (t.n) with
| Typ_app ((h, args)) -> begin
(mk_Typ_app (h, (Support.List.append args ((arg)::[]))) k p)
end
| _ -> begin
(mk_Typ_app (t, (arg)::[]) k p)
end)
end))

let mk_Typ_lam = (fun _28954 k p -> (match (_28954) with
| (b, t) -> begin
{n = (match (b) with
| [] -> begin
(failwith "Empty binders!")
end
| _ -> begin
Typ_lam ((b, t))
end); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_lam' = (fun _28962 k p -> (match (_28962) with
| (bs, t) -> begin
(match (bs) with
| [] -> begin
t
end
| _ -> begin
(mk_Typ_lam (bs, t) k p)
end)
end))

let mk_Typ_ascribed' = (fun _28970 k' p -> (match (_28970) with
| (t, k) -> begin
{n = Typ_ascribed ((t, k)); tk = (Support.Microsoft.FStar.Util.mk_ref k'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_ascribed = (fun _28975 p -> (match (_28975) with
| (t, k) -> begin
(mk_Typ_ascribed' (t, k) (Some (k)) p)
end))

let mk_Typ_meta' = (fun m k p -> {n = Typ_meta (m); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Typ_meta = (fun m -> (match (m) with
| (Meta_pattern ((t, _))) | (Meta_named ((t, _))) | (Meta_labeled ((t, _, _, _))) | (Meta_refresh_label ((t, _, _))) | (Meta_slack_formula ((t, _, _))) -> begin
(mk_Typ_meta' m (! (t.tk)) t.pos)
end))

let mk_Typ_uvar' = (fun _29012 k' p -> (match (_29012) with
| (u, k) -> begin
{n = Typ_uvar ((u, k)); tk = (get_knd_ref k'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_uvar = (fun _29017 p -> (match (_29017) with
| (u, k) -> begin
(mk_Typ_uvar' (u, k) (Some (k)) p)
end))

let mk_Typ_delayed = (fun _29022 k p -> (match (_29022) with
| (t, s, m) -> begin
{n = (match (t.n) with
| Typ_delayed (_) -> begin
(failwith "NESTED DELAYED TYPES!")
end
| _ -> begin
Typ_delayed ((Support.Microsoft.FStar.Util.Inl ((t, s)), m))
end); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Typ_delayed' = (fun st k p -> {n = Typ_delayed ((st, (Support.Microsoft.FStar.Util.mk_ref None))); tk = (Support.Microsoft.FStar.Util.mk_ref k); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Typ_unknown = {n = Typ_unknown; tk = (get_knd_nref ()); pos = dummyRange; fvs = (mk_fvs ()); uvs = (mk_uvs ())}

let get_typ_nref = (fun _29033 -> (match (_29033) with
| () -> begin
(let x = (Support.Microsoft.FStar.Util.mk_ref (Some (mk_Typ_unknown)))
in (let _29035 = (x := None)
in x))
end))

let get_typ_ref = (fun t -> (let x = (Support.Microsoft.FStar.Util.mk_ref (Some (mk_Typ_unknown)))
in (let _29039 = (x := t)
in x)))

let mk_Total = (fun t -> {n = Total (t); tk = (Support.Microsoft.FStar.Util.mk_ref None); pos = t.pos; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Comp = (fun ct -> {n = Comp (ct); tk = (Support.Microsoft.FStar.Util.mk_ref None); pos = ct.result_typ.pos; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Exp_bvar = (fun x t p -> {n = Exp_bvar (x); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Exp_fvar = (fun _29048 t p -> (match (_29048) with
| (x, b) -> begin
{n = Exp_fvar ((x, b)); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_constant = (fun s t p -> {n = Exp_constant (s); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Exp_abs = (fun _29056 t' p -> (match (_29056) with
| (b, e) -> begin
{n = (match (b) with
| [] -> begin
(failwith "abstraction with no binders!")
end
| _ -> begin
Exp_abs ((b, e))
end); tk = (get_typ_ref t'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_abs' = (fun _29064 t' p -> (match (_29064) with
| (b, e) -> begin
{n = (match ((b, e.n)) with
| (_, Exp_abs ((binders, body))) -> begin
Exp_abs (((Support.List.append b binders), body))
end
| ([], _) -> begin
(failwith "abstraction with no binders!")
end
| _ -> begin
Exp_abs ((b, e))
end); tk = (get_typ_ref t'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_app = (fun _29082 t p -> (match (_29082) with
| (e1, args) -> begin
{n = (match (args) with
| [] -> begin
(failwith "Empty args!")
end
| _ -> begin
Exp_app ((e1, args))
end); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_app_flat = (fun _29090 t p -> (match (_29090) with
| (e1, args) -> begin
(match (e1.n) with
| Exp_app ((e1', args')) -> begin
(mk_Exp_app (e1', (Support.List.append args' args)) t p)
end
| _ -> begin
(mk_Exp_app (e1, args) t p)
end)
end))

let mk_Exp_app' = (fun _29101 t p -> (match (_29101) with
| (e1, args) -> begin
(match (args) with
| [] -> begin
e1
end
| _ -> begin
(mk_Exp_app (e1, args) t p)
end)
end))

let rec pat_vars = (fun p -> (match (p.v) with
| Pat_cons ((_, ps)) -> begin
(let vars = (Support.List.collect pat_vars ps)
in if ((Support.Microsoft.FStar.Util.nodups (fun x y -> (match ((x, y)) with
| (Support.Microsoft.FStar.Util.Inl (x), Support.Microsoft.FStar.Util.Inl (y)) -> begin
(bvd_eq x y)
end
| (Support.Microsoft.FStar.Util.Inr (x), Support.Microsoft.FStar.Util.Inr (y)) -> begin
(bvd_eq x y)
end
| _ -> begin
false
end))) vars) then begin
vars
end else begin
(raise (Error (("Pattern variables may not occur more than once", p.p))))
end)
end
| Pat_var ((x, _)) -> begin
(Support.Microsoft.FStar.Util.Inr (x.v))::[]
end
| Pat_tvar (a) -> begin
(Support.Microsoft.FStar.Util.Inl (a.v))::[]
end
| Pat_disj (ps) -> begin
(let vars = (Support.List.map pat_vars ps)
in if (not (((Support.Microsoft.FStar.Util.for_all (Support.Microsoft.FStar.Util.set_eq (order_bvd) (Support.List.hd vars))) (Support.List.tl vars)))) then begin
(let vars = (Support.Microsoft.FStar.Util.concat_l ";\n" ((Support.List.map (fun v -> (Support.Microsoft.FStar.Util.concat_l ", " (Support.List.map (fun _28507 -> (match (_28507) with
| Support.Microsoft.FStar.Util.Inr (x) -> begin
x.ppname.idText
end
| Support.Microsoft.FStar.Util.Inl (x) -> begin
x.ppname.idText
end)) v)))) vars))
in (raise (Error (((Support.Microsoft.FStar.Util.format1 "Each branch of this pattern binds different variables: %s" vars), p.p)))))
end else begin
(Support.List.hd vars)
end)
end
| (Pat_dot_term (_)) | (Pat_dot_typ (_)) | (Pat_wild (_)) | (Pat_twild (_)) | (Pat_constant (_)) -> begin
[]
end))

let mk_Exp_match = (fun _29162 t p -> (match (_29162) with
| (e, pats) -> begin
{n = Exp_match ((e, pats)); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_ascribed' = (fun _29167 t' p -> (match (_29167) with
| (e, t) -> begin
{n = Exp_ascribed ((e, t)); tk = (get_typ_ref t'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_ascribed = (fun _29172 p -> (match (_29172) with
| (e, t) -> begin
(mk_Exp_ascribed' (e, t) (Some (t)) p)
end))

let mk_Exp_let = (fun _29176 t p -> (match (_29176) with
| (lbs, e) -> begin
{n = Exp_let ((lbs, e)); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_uvar' = (fun _29181 t' p -> (match (_29181) with
| (u, t) -> begin
{n = Exp_uvar ((u, t)); tk = (get_typ_ref t'); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_uvar = (fun _29186 p -> (match (_29186) with
| (u, t) -> begin
(mk_Exp_uvar' (u, t) (Some (t)) p)
end))

let mk_Exp_delayed = (fun _29191 t p -> (match (_29191) with
| (e, s, m) -> begin
{n = Exp_delayed ((e, s, m)); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())}
end))

let mk_Exp_meta' = (fun m t p -> {n = Exp_meta (m); tk = (get_typ_ref t); pos = p; fvs = (mk_fvs ()); uvs = (mk_uvs ())})

let mk_Exp_meta = (fun m -> (match (m) with
| Meta_desugared ((e, _)) -> begin
(mk_Exp_meta' m (! (e.tk)) e.pos)
end))

let mk_subst = (fun s -> s)

let extend_subst = (fun x s -> (x)::s)

let argpos = (fun x -> (match (x) with
| (Support.Microsoft.FStar.Util.Inl (t), _) -> begin
t.pos
end
| (Support.Microsoft.FStar.Util.Inr (e), _) -> begin
e.pos
end))

let tun = mk_Typ_unknown

let kun = mk_Kind_unknown

let ktype = mk_Kind_type

let keffect = mk_Kind_effect

let null_id = (mk_ident ("_", dummyRange))

let null_bvd = {ppname = null_id; realname = null_id}

let null_bvar = (fun k -> {v = (null_bvd); sort = k; p = dummyRange})

let t_binder = (fun a -> (Support.Microsoft.FStar.Util.Inl (a), None))

let v_binder = (fun a -> (Support.Microsoft.FStar.Util.Inr (a), None))

let null_t_binder = (fun t -> (Support.Microsoft.FStar.Util.Inl ((null_bvar t)), None))

let null_v_binder = (fun t -> (Support.Microsoft.FStar.Util.Inr ((null_bvar t)), None))

let itarg = (fun t -> (Support.Microsoft.FStar.Util.Inl (t), Some (Implicit)))

let ivarg = (fun v -> (Support.Microsoft.FStar.Util.Inr (v), Some (Implicit)))

let targ = (fun t -> (Support.Microsoft.FStar.Util.Inl (t), None))

let varg = (fun v -> (Support.Microsoft.FStar.Util.Inr (v), None))

let is_null_pp = (fun b -> (b.ppname.idText = null_id.idText))

let is_null_bvd = (fun b -> (b.realname.idText = null_id.idText))

let is_null_bvar = (fun b -> (is_null_bvd b.v))

let is_null_binder = (fun b -> (match (b) with
| (Support.Microsoft.FStar.Util.Inl (a), _) -> begin
(is_null_bvar a)
end
| (Support.Microsoft.FStar.Util.Inr (x), _) -> begin
(is_null_bvar x)
end))

let freevars_of_binders = (fun bs -> ((Support.List.fold_left (fun out _28508 -> (match (_28508) with
| (Support.Microsoft.FStar.Util.Inl (btv), _) -> begin
(let _29252 = out
in {ftvs = (Support.Microsoft.FStar.Util.set_add btv out.ftvs); fxvs = _29252.fxvs})
end
| (Support.Microsoft.FStar.Util.Inr (bxv), _) -> begin
(let _29259 = out
in {ftvs = _29259.ftvs; fxvs = (Support.Microsoft.FStar.Util.set_add bxv out.fxvs)})
end)) no_fvs) bs))

let binders_of_list = (fun fvs -> ((Support.List.map (fun t -> (t, None))) fvs))

let binders_of_freevars = (fun fvs -> (Support.List.append ((Support.List.map t_binder) (Support.Microsoft.FStar.Util.set_elements fvs.ftvs)) ((Support.List.map v_binder) (Support.Microsoft.FStar.Util.set_elements fvs.fxvs))))

let is_implicit = (fun _28509 -> (match (_28509) with
| Some (Implicit) -> begin
true
end
| _ -> begin
false
end))

let as_implicit = (fun _28510 -> (match (_28510) with
| true -> begin
Some (Implicit)
end
| _ -> begin
None
end))





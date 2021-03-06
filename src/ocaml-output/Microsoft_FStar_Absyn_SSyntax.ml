
exception Err of (string)

let parse_error = (fun _105817 -> (match (_105817) with
| () -> begin
(failwith "Parse error: ill-formed cache")
end))

type l__Writer =
Support.Microsoft.FStar.Util.oWriter

type l__Reader =
Support.Microsoft.FStar.Util.oReader

let serialize_option = (fun writer f l -> (match (l) with
| None -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'n')
end
| Some (l) -> begin
(let _105825 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 's')
in (f writer l))
end))

let deserialize_option = (fun reader f -> (let n = (Support.Microsoft.FStar.Util.MkoReader.read_char reader ())
in if (n = 'n') then begin
None
end else begin
Some ((f reader))
end))

let serialize_list = (fun writer f l -> (let _105835 = (Support.Microsoft.FStar.Util.MkoWriter.write_int writer (Support.List.length l))
in (Support.List.iter (fun elt -> (f writer elt)) (Support.List.rev_append l []))))

let deserialize_list = (fun reader f -> (let n = (Support.Microsoft.FStar.Util.MkoReader.read_int reader ())
in (let rec helper = (fun accum n -> if (n = 0) then begin
accum
end else begin
(helper (((f reader))::accum) (n - 1))
end)
in (helper [] n))))

let serialize_ident = (fun writer ast -> (Support.Microsoft.FStar.Util.MkoWriter.write_string writer ast.Microsoft_FStar_Absyn_Syntax.idText))

let deserialize_ident = (fun reader -> (Microsoft_FStar_Absyn_Syntax.mk_ident ((Support.Microsoft.FStar.Util.MkoReader.read_string reader ()), Microsoft_FStar_Absyn_Syntax.dummyRange)))

let serialize_LongIdent = (fun writer ast -> (let _105850 = (serialize_list writer serialize_ident ast.Microsoft_FStar_Absyn_Syntax.ns)
in (serialize_ident writer ast.Microsoft_FStar_Absyn_Syntax.ident)))

let deserialize_LongIdent = (fun reader -> (Microsoft_FStar_Absyn_Syntax.lid_of_ids (Support.List.append (deserialize_list reader deserialize_ident) (((deserialize_ident reader))::[]))))

let serialize_lident = serialize_LongIdent

let deserialize_lident = deserialize_LongIdent

let serialize_withinfo_t = (fun writer s_v s_sort ast -> (let _105859 = (s_v writer ast.Microsoft_FStar_Absyn_Syntax.v)
in (s_sort writer ast.Microsoft_FStar_Absyn_Syntax.sort)))

let deserialize_withinfo_t = (fun reader ds_v ds_sort -> {Microsoft_FStar_Absyn_Syntax.v = (ds_v reader); Microsoft_FStar_Absyn_Syntax.sort = (ds_sort reader); Microsoft_FStar_Absyn_Syntax.p = Microsoft_FStar_Absyn_Syntax.dummyRange})

let serialize_var = (fun writer s_sort ast -> (serialize_withinfo_t writer serialize_lident s_sort ast))

let deserialize_var = (fun reader ds_sort -> (deserialize_withinfo_t reader deserialize_lident ds_sort))

let serialize_bvdef = (fun writer ast -> (let _105876 = (serialize_ident writer ast.Microsoft_FStar_Absyn_Syntax.ppname)
in (serialize_ident writer ast.Microsoft_FStar_Absyn_Syntax.realname)))

let deserialize_bvdef = (fun ghost reader -> {Microsoft_FStar_Absyn_Syntax.ppname = (deserialize_ident reader); Microsoft_FStar_Absyn_Syntax.realname = (deserialize_ident reader)})

let serialize_bvar = (fun writer s_sort ast -> (serialize_withinfo_t writer (serialize_bvdef) s_sort ast))

let deserialize_bvar = (fun ghost reader ds_sort -> (deserialize_withinfo_t reader (deserialize_bvdef ghost) ds_sort))

let serialize_sconst = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Const_unit -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
end
| Microsoft_FStar_Absyn_Syntax.Const_uint8 (v) -> begin
(let _105896 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (Support.Microsoft.FStar.Util.MkoWriter.write_byte writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_bool (v) -> begin
(let _105900 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_int32 (v) -> begin
(let _105904 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (Support.Microsoft.FStar.Util.MkoWriter.write_int32 writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_int64 (v) -> begin
(let _105908 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (Support.Microsoft.FStar.Util.MkoWriter.write_int64 writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_char (v) -> begin
(let _105912 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
in (Support.Microsoft.FStar.Util.MkoWriter.write_char writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_float (v) -> begin
(let _105916 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (Support.Microsoft.FStar.Util.MkoWriter.write_double writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_bytearray ((v, _)) -> begin
(let _105923 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
in (Support.Microsoft.FStar.Util.MkoWriter.write_bytearray writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_string ((v, _)) -> begin
(let _105930 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
in (Support.Microsoft.FStar.Util.MkoWriter.write_bytearray writer v))
end
| Microsoft_FStar_Absyn_Syntax.Const_int (v) -> begin
(let _105934 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'j')
in (Support.Microsoft.FStar.Util.MkoWriter.write_int writer v))
end))

let deserialize_sconst = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Const_unit
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Const_uint8 ((Support.Microsoft.FStar.Util.MkoReader.read_byte reader ()))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Const_bool ((Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Const_int32 ((Support.Microsoft.FStar.Util.MkoReader.read_int32 reader ()))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Const_int64 ((Support.Microsoft.FStar.Util.MkoReader.read_int64 reader ()))
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.Const_char ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ()))
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Const_float ((Support.Microsoft.FStar.Util.MkoReader.read_double reader ()))
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Const_bytearray (((Support.Microsoft.FStar.Util.MkoReader.read_bytearray reader ()), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Const_string (((Support.Microsoft.FStar.Util.MkoReader.read_bytearray reader ()), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'j' -> begin
Microsoft_FStar_Absyn_Syntax.Const_int ((Support.Microsoft.FStar.Util.MkoReader.read_int reader ()))
end
| _ -> begin
(parse_error ())
end))

let serialize_either = (fun writer s_l s_r ast -> (match (ast) with
| Support.Microsoft.FStar.Util.Inl (v) -> begin
(let _105957 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (s_l writer v))
end
| Support.Microsoft.FStar.Util.Inr (v) -> begin
(let _105961 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (s_r writer v))
end))

let deserialize_either = (fun reader ds_l ds_r -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Support.Microsoft.FStar.Util.Inl ((ds_l reader))
end
| 'b' -> begin
Support.Microsoft.FStar.Util.Inr ((ds_r reader))
end
| _ -> begin
(parse_error ())
end))

let serialize_syntax = (fun writer s_a ast -> (s_a writer ast.Microsoft_FStar_Absyn_Syntax.n))

let deserialize_syntax = (fun reader ds_a ds_b -> {Microsoft_FStar_Absyn_Syntax.n = (ds_a reader); Microsoft_FStar_Absyn_Syntax.tk = (Support.Microsoft.FStar.Util.mk_ref None); Microsoft_FStar_Absyn_Syntax.pos = Microsoft_FStar_Absyn_Syntax.dummyRange; Microsoft_FStar_Absyn_Syntax.fvs = (Support.Microsoft.FStar.Util.mk_ref None); Microsoft_FStar_Absyn_Syntax.uvs = (Support.Microsoft.FStar.Util.mk_ref None)})

let rec serialize_typ' = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Typ_btvar (v) -> begin
(let _105986 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (serialize_btvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (v) -> begin
(let _105990 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (serialize_ftvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Typ_fun ((bs, c)) -> begin
(let _105996 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (let _105998 = (serialize_binders writer bs)
in (serialize_comp writer c)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((v, t)) -> begin
(let _106004 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (let _106006 = (serialize_bvvar writer v)
in (serialize_typ writer t)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_app ((t, ars)) -> begin
(let _106012 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (let _106014 = (serialize_typ writer t)
in (let _106016 = (serialize_args writer ars)
in if ((! (Microsoft_FStar_Options.debug)) <> []) then begin
(match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((_, _)) -> begin
(Support.Microsoft.FStar.Util.print_string "type application node with lam\n")
end
| _ -> begin
()
end)
end)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((bs, t)) -> begin
(let _106030 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
in (let _106032 = (serialize_binders writer bs)
in (serialize_typ writer t)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_ascribed ((t, k)) -> begin
(let _106038 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (let _106040 = (serialize_typ writer t)
in (serialize_knd writer k)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (m) -> begin
(let _106044 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
in (serialize_meta_t writer m))
end
| Microsoft_FStar_Absyn_Syntax.Typ_unknown -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
end
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((_, _)) -> begin
(raise (Err ("typ not impl:1")))
end
| Microsoft_FStar_Absyn_Syntax.Typ_delayed ((_, _)) -> begin
(raise (Err ("typ not impl:2")))
end))
and serialize_meta_t = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Meta_pattern ((t, l)) -> begin
(let _106065 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (let _106067 = (serialize_typ writer t)
in (serialize_list writer serialize_arg l)))
end
| Microsoft_FStar_Absyn_Syntax.Meta_named ((t, lid)) -> begin
(let _106073 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (let _106075 = (serialize_typ writer t)
in (serialize_lident writer lid)))
end
| Microsoft_FStar_Absyn_Syntax.Meta_labeled ((t, s, _, b)) -> begin
(let _106084 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (let _106086 = (serialize_typ writer t)
in (let _106088 = (Support.Microsoft.FStar.Util.MkoWriter.write_string writer s)
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer b))))
end
| _ -> begin
(raise (Err ("unimplemented meta_t")))
end))
and serialize_arg = (fun writer ast -> (let _106094 = (serialize_either writer serialize_typ serialize_exp (Support.Prims.fst ast))
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer (Microsoft_FStar_Absyn_Syntax.is_implicit (Support.Prims.snd ast)))))
and serialize_args = (fun writer ast -> (serialize_list writer serialize_arg ast))
and serialize_binder = (fun writer ast -> (let _106100 = (serialize_either writer serialize_btvar serialize_bvvar (Support.Prims.fst ast))
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer (Microsoft_FStar_Absyn_Syntax.is_implicit (Support.Prims.snd ast)))))
and serialize_binders = (fun writer ast -> (serialize_list writer serialize_binder ast))
and serialize_typ = (fun writer ast -> (serialize_syntax writer serialize_typ' (Microsoft_FStar_Absyn_Util.compress_typ ast)))
and serialize_comp_typ = (fun writer ast -> (let _106108 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let _106110 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.result_typ)
in (let _106112 = (serialize_args writer ast.Microsoft_FStar_Absyn_Syntax.effect_args)
in (serialize_list writer serialize_cflags ast.Microsoft_FStar_Absyn_Syntax.flags)))))
and serialize_comp' = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Total (t) -> begin
(let _106118 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (serialize_typ writer t))
end
| Microsoft_FStar_Absyn_Syntax.Comp (c) -> begin
(let _106122 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (serialize_comp_typ writer c))
end))
and serialize_comp = (fun writer ast -> (serialize_syntax writer serialize_comp' ast))
and serialize_cflags = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.TOTAL -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
end
| Microsoft_FStar_Absyn_Syntax.MLEFFECT -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
end
| Microsoft_FStar_Absyn_Syntax.RETURN -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
end
| Microsoft_FStar_Absyn_Syntax.PARTIAL_RETURN -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
end
| Microsoft_FStar_Absyn_Syntax.SOMETRIVIAL -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
end
| Microsoft_FStar_Absyn_Syntax.LEMMA -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
end
| Microsoft_FStar_Absyn_Syntax.DECREASES (e) -> begin
(let _106136 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (serialize_exp writer e))
end))
and serialize_exp' = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (v) -> begin
(let _106142 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (serialize_bvvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Exp_fvar ((v, b)) -> begin
(let _106148 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (let _106150 = (serialize_fvvar writer v)
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer b)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_constant (c) -> begin
(let _106154 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (serialize_sconst writer c))
end
| Microsoft_FStar_Absyn_Syntax.Exp_abs ((bs, e)) -> begin
(let _106160 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (let _106162 = (serialize_binders writer bs)
in (serialize_exp writer e)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_app ((e, ars)) -> begin
(let _106168 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (let _106170 = (serialize_exp writer e)
in (serialize_args writer ars)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_match ((e, l)) -> begin
(let g = (fun writer eopt -> (match (eopt) with
| Some (e1) -> begin
(let _106181 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (serialize_exp writer e1))
end
| None -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
end))
in (let f = (fun writer _106189 -> (match (_106189) with
| (p, eopt, e) -> begin
(let _106190 = (serialize_pat writer p)
in (let _106192 = (g writer eopt)
in (serialize_exp writer e)))
end))
in (let _106194 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
in (let _106196 = (serialize_exp writer e)
in (serialize_list writer f l)))))
end
| Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e, t)) -> begin
(let _106202 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (let _106204 = (serialize_exp writer e)
in (serialize_typ writer t)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_let ((lbs, e)) -> begin
(let _106210 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
in (let _106212 = (serialize_letbindings writer lbs)
in (serialize_exp writer e)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_meta (m) -> begin
(let _106216 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
in (serialize_meta_e writer m))
end
| _ -> begin
(raise (Err ("unimplemented exp\'")))
end))
and serialize_meta_e = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Meta_desugared ((e, s)) -> begin
(let _106226 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (let _106228 = (serialize_exp writer e)
in (serialize_meta_source_info writer s)))
end))
and serialize_meta_source_info = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Data_app -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
end
| Microsoft_FStar_Absyn_Syntax.Sequence -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
end
| Microsoft_FStar_Absyn_Syntax.Primop -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
end
| Microsoft_FStar_Absyn_Syntax.MaskedEffect -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
end))
and serialize_exp = (fun writer ast -> (serialize_syntax writer serialize_exp' (Microsoft_FStar_Absyn_Util.compress_exp ast)))
and serialize_btvdef = (fun writer ast -> (serialize_bvdef writer ast))
and serialize_bvvdef = (fun writer ast -> (serialize_bvdef writer ast))
and serialize_pat' = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Pat_disj (l) -> begin
(let _106246 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (serialize_list writer serialize_pat l))
end
| Microsoft_FStar_Absyn_Syntax.Pat_constant (c) -> begin
(let _106250 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (serialize_sconst writer c))
end
| Microsoft_FStar_Absyn_Syntax.Pat_cons ((v, l)) -> begin
(let _106256 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (let _106258 = (serialize_fvvar writer v)
in (serialize_list writer serialize_pat l)))
end
| Microsoft_FStar_Absyn_Syntax.Pat_var ((v, b)) -> begin
(let _106264 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (let _106266 = (serialize_bvvar writer v)
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer b)))
end
| Microsoft_FStar_Absyn_Syntax.Pat_tvar (v) -> begin
(let _106270 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (serialize_btvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Pat_wild (v) -> begin
(let _106274 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
in (serialize_bvvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Pat_twild (v) -> begin
(let _106278 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (serialize_btvar writer v))
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_term ((v, e)) -> begin
(let _106284 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
in (let _106286 = (serialize_bvvar writer v)
in (serialize_exp writer e)))
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_typ ((v, t)) -> begin
(let _106292 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
in (let _106294 = (serialize_btvar writer v)
in (serialize_typ writer t)))
end))
and serialize_pat = (fun writer ast -> (serialize_withinfo_t writer serialize_pat' (fun w kt -> ()) ast))
and serialize_knd' = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Kind_type -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
end
| Microsoft_FStar_Absyn_Syntax.Kind_effect -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev ((ka, k)) -> begin
(let _106308 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (let _106310 = (serialize_kabbrev writer ka)
in (serialize_knd writer k)))
end
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((bs, k)) -> begin
(let _106316 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (let _106318 = (serialize_binders writer bs)
in (serialize_knd writer k)))
end
| Microsoft_FStar_Absyn_Syntax.Kind_lam ((bs, k)) -> begin
(let _106324 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (let _106326 = (serialize_binders writer bs)
in (serialize_knd writer k)))
end
| Microsoft_FStar_Absyn_Syntax.Kind_unknown -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
end
| Microsoft_FStar_Absyn_Syntax.Kind_uvar ((uv, args)) -> begin
(raise (Err ("knd\' serialization unimplemented:1")))
end
| Microsoft_FStar_Absyn_Syntax.Kind_delayed ((_, _, _)) -> begin
(raise (Err ("knd\' serialization unimplemented:2")))
end))
and serialize_knd = (fun writer ast -> (serialize_syntax writer serialize_knd' (Microsoft_FStar_Absyn_Util.compress_kind ast)))
and serialize_kabbrev = (fun writer ast -> (let _106345 = (serialize_lident writer (Support.Prims.fst ast))
in (serialize_args writer (Support.Prims.snd ast))))
and serialize_lbname = (fun writer ast -> (serialize_either writer serialize_bvvdef serialize_lident ast))
and serialize_letbindings = (fun writer ast -> (let f = (fun writer _106356 -> (match (_106356) with
| (n, t, e) -> begin
(let _106357 = (serialize_lbname writer n)
in (let _106359 = (serialize_typ writer t)
in (serialize_exp writer e)))
end))
in (let _106361 = (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer (Support.Prims.fst ast))
in (serialize_list writer f (Support.Prims.snd ast)))))
and serialize_fvar = (fun writer ast -> (serialize_either writer serialize_btvdef serialize_bvvdef ast))
and serialize_btvar = (fun writer ast -> (serialize_bvar writer serialize_knd ast))
and serialize_bvvar = (fun writer ast -> (serialize_bvar writer serialize_typ ast))
and serialize_ftvar = (fun writer ast -> (serialize_var writer serialize_knd ast))
and serialize_fvvar = (fun writer ast -> (serialize_var writer serialize_typ ast))

let rec deserialize_typ' = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_btvar ((deserialize_btvar reader))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_const ((deserialize_ftvar reader))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_fun (((deserialize_binders reader), (deserialize_comp reader)))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_refine (((deserialize_bvvar reader), (deserialize_typ reader)))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_app (((deserialize_typ reader), (deserialize_args reader)))
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_lam (((deserialize_binders reader), (deserialize_typ reader)))
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_ascribed (((deserialize_typ reader), (deserialize_knd reader)))
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_meta ((deserialize_meta_t reader))
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Typ_unknown
end
| _ -> begin
(parse_error ())
end))
and deserialize_meta_t = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Meta_pattern (((deserialize_typ reader), (deserialize_list reader deserialize_arg)))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Meta_named (((deserialize_typ reader), (deserialize_lident reader)))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Meta_labeled (((deserialize_typ reader), (Support.Microsoft.FStar.Util.MkoReader.read_string reader ()), Microsoft_FStar_Absyn_Syntax.dummyRange, (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ())))
end
| _ -> begin
(parse_error ())
end))
and deserialize_arg = (fun reader -> ((deserialize_either reader deserialize_typ deserialize_exp), (Microsoft_FStar_Absyn_Syntax.as_implicit (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()))))
and deserialize_args = (fun reader -> (deserialize_list reader deserialize_arg))
and deserialize_binder = (fun reader -> ((deserialize_either reader deserialize_btvar deserialize_bvvar), (Microsoft_FStar_Absyn_Syntax.as_implicit (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()))))
and deserialize_binders = (fun reader -> (deserialize_list reader deserialize_binder))
and deserialize_typ = (fun reader -> (deserialize_syntax reader deserialize_typ' Microsoft_FStar_Absyn_Syntax.mk_Kind_unknown))
and deserialize_comp_typ = (fun reader -> {Microsoft_FStar_Absyn_Syntax.effect_name = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.result_typ = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.effect_args = (deserialize_args reader); Microsoft_FStar_Absyn_Syntax.flags = (deserialize_list reader deserialize_cflags)})
and deserialize_comp' = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Total ((deserialize_typ reader))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Comp ((deserialize_comp_typ reader))
end
| _ -> begin
(parse_error ())
end))
and deserialize_comp = (fun reader -> (deserialize_syntax reader deserialize_comp' ()))
and deserialize_cflags = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.TOTAL
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.MLEFFECT
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.RETURN
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.PARTIAL_RETURN
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.SOMETRIVIAL
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.LEMMA
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.DECREASES ((deserialize_exp reader))
end
| _ -> begin
(parse_error ())
end))
and deserialize_exp' = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_bvar ((deserialize_bvvar reader))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_fvar (((deserialize_fvvar reader), (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ())))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_constant ((deserialize_sconst reader))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_abs (((deserialize_binders reader), (deserialize_exp reader)))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_app (((deserialize_exp reader), (deserialize_args reader)))
end
| 'f' -> begin
(let g = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Some ((deserialize_exp reader))
end
| 'b' -> begin
None
end
| _ -> begin
(parse_error ())
end))
in (let f = (fun reader -> ((deserialize_pat reader), (g reader), (deserialize_exp reader)))
in Microsoft_FStar_Absyn_Syntax.Exp_match (((deserialize_exp reader), (deserialize_list reader f)))))
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_ascribed (((deserialize_exp reader), (deserialize_typ reader)))
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_let (((deserialize_letbindings reader), (deserialize_exp reader)))
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Exp_meta ((deserialize_meta_e reader))
end
| _ -> begin
(parse_error ())
end))
and deserialize_meta_e = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Meta_desugared (((deserialize_exp reader), (deserialize_meta_source_info reader)))
end
| _ -> begin
(parse_error ())
end))
and deserialize_meta_source_info = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Data_app
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Sequence
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Primop
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.MaskedEffect
end
| _ -> begin
(parse_error ())
end))
and deserialize_exp = (fun reader -> (deserialize_syntax reader deserialize_exp' Microsoft_FStar_Absyn_Syntax.mk_Typ_unknown))
and deserialize_btvdef = (fun reader -> (deserialize_bvdef None reader))
and deserialize_bvvdef = (fun reader -> (deserialize_bvdef None reader))
and deserialize_pat' = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_disj ((deserialize_list reader deserialize_pat))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_constant ((deserialize_sconst reader))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_cons (((deserialize_fvvar reader), (deserialize_list reader deserialize_pat)))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_var (((deserialize_bvvar reader), (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ())))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_tvar ((deserialize_btvar reader))
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_wild ((deserialize_bvvar reader))
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_twild ((deserialize_btvar reader))
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_dot_term (((deserialize_bvvar reader), (deserialize_exp reader)))
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Pat_dot_typ (((deserialize_btvar reader), (deserialize_typ reader)))
end
| _ -> begin
(parse_error ())
end))
and deserialize_pat = (fun reader -> (deserialize_withinfo_t reader deserialize_pat' (fun r -> None)))
and deserialize_knd' = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_type
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_effect
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_abbrev (((deserialize_kabbrev reader), (deserialize_knd reader)))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_arrow (((deserialize_binders reader), (deserialize_knd reader)))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_lam (((deserialize_binders reader), (deserialize_knd reader)))
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.Kind_unknown
end
| _ -> begin
(parse_error ())
end))
and deserialize_knd = (fun reader -> (deserialize_syntax reader deserialize_knd' ()))
and deserialize_kabbrev = (fun reader -> ((deserialize_lident reader), (deserialize_args reader)))
and deserialize_lbname = (fun reader -> (deserialize_either reader deserialize_bvvdef deserialize_lident))
and deserialize_letbindings = (fun reader -> (let f = (fun reader -> ((deserialize_lbname reader), (deserialize_typ reader), (deserialize_exp reader)))
in ((Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()), (deserialize_list reader f))))
and deserialize_fvar = (fun reader -> (deserialize_either reader deserialize_btvdef deserialize_bvvdef))
and deserialize_btvar = (fun reader -> (deserialize_bvar None reader deserialize_knd))
and deserialize_bvvar = (fun reader -> (deserialize_bvar None reader deserialize_typ))
and deserialize_ftvar = (fun reader -> (deserialize_var reader deserialize_knd))
and deserialize_fvvar = (fun reader -> (deserialize_var reader deserialize_typ))

let serialize_formula = serialize_typ

let deserialize_formula = deserialize_typ

let serialize_qualifier = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Private -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
end
| Microsoft_FStar_Absyn_Syntax.Assumption -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
end
| Microsoft_FStar_Absyn_Syntax.Logic -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
end
| Microsoft_FStar_Absyn_Syntax.Opaque -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
end
| Microsoft_FStar_Absyn_Syntax.Discriminator (lid) -> begin
(let _106489 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
in (serialize_lident writer lid))
end
| Microsoft_FStar_Absyn_Syntax.Projector ((lid, v)) -> begin
(let _106495 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'j')
in (let _106497 = (serialize_lident writer lid)
in (serialize_either writer serialize_btvdef serialize_bvvdef v)))
end
| Microsoft_FStar_Absyn_Syntax.RecordType (l) -> begin
(let _106501 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'k')
in (serialize_list writer serialize_ident l))
end
| Microsoft_FStar_Absyn_Syntax.RecordConstructor (l) -> begin
(let _106505 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'l')
in (serialize_list writer serialize_ident l))
end
| Microsoft_FStar_Absyn_Syntax.ExceptionConstructor -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'm')
end
| Microsoft_FStar_Absyn_Syntax.HasMaskedEffect -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'o')
end
| Microsoft_FStar_Absyn_Syntax.DefaultEffect (l) -> begin
(let _106511 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'p')
in (serialize_option writer serialize_lident l))
end
| Microsoft_FStar_Absyn_Syntax.TotalEffect -> begin
(Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'q')
end
| _ -> begin
(failwith "Unexpected qualifier")
end))

let deserialize_qualifier = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Private
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Assumption
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Logic
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Opaque
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Discriminator ((deserialize_lident reader))
end
| 'j' -> begin
Microsoft_FStar_Absyn_Syntax.Projector (((deserialize_lident reader), (deserialize_either reader deserialize_btvdef deserialize_bvvdef)))
end
| 'k' -> begin
Microsoft_FStar_Absyn_Syntax.RecordType ((deserialize_list reader deserialize_ident))
end
| 'l' -> begin
Microsoft_FStar_Absyn_Syntax.RecordConstructor ((deserialize_list reader deserialize_ident))
end
| 'm' -> begin
Microsoft_FStar_Absyn_Syntax.ExceptionConstructor
end
| 'o' -> begin
Microsoft_FStar_Absyn_Syntax.HasMaskedEffect
end
| 'p' -> begin
Microsoft_FStar_Absyn_Syntax.DefaultEffect ((deserialize_option reader deserialize_lident))
end
| 'q' -> begin
Microsoft_FStar_Absyn_Syntax.TotalEffect
end
| _ -> begin
(parse_error ())
end))

let serialize_tycon = (fun writer _106535 -> (match (_106535) with
| (lid, bs, k) -> begin
(let _106536 = (serialize_lident writer lid)
in (let _106538 = (serialize_binders writer bs)
in (serialize_knd writer k)))
end))

let deserialize_tycon = (fun reader -> ((deserialize_lident reader), (deserialize_binders reader), (deserialize_knd reader)))

let serialize_monad_abbrev = (fun writer ast -> (let _106543 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.mabbrev)
in (let _106545 = (serialize_binders writer ast.Microsoft_FStar_Absyn_Syntax.parms)
in (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.def))))

let deserialize_monad_abbrev = (fun reader -> {Microsoft_FStar_Absyn_Syntax.mabbrev = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.parms = (deserialize_binders reader); Microsoft_FStar_Absyn_Syntax.def = (deserialize_typ reader)})

let serialize_sub_effect = (fun writer ast -> (let _106550 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.source)
in (let _106552 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.target)
in (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.lift))))

let deserialize_sub_effect = (fun reader -> {Microsoft_FStar_Absyn_Syntax.source = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.target = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.lift = (deserialize_typ reader)})

let rec serialize_new_effect = (fun writer ast -> (let _106557 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.mname)
in (let _106559 = (serialize_list writer serialize_binder ast.Microsoft_FStar_Absyn_Syntax.binders)
in (let _106561 = (serialize_list writer serialize_qualifier ast.Microsoft_FStar_Absyn_Syntax.qualifiers)
in (let _106563 = (serialize_knd writer ast.Microsoft_FStar_Absyn_Syntax.signature)
in (let _106565 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.ret)
in (let _106567 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.bind_wp)
in (let _106569 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.bind_wlp)
in (let _106571 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.if_then_else)
in (let _106573 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.ite_wp)
in (let _106575 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.ite_wlp)
in (let _106577 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.wp_binop)
in (let _106579 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.wp_as_type)
in (let _106581 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.close_wp)
in (let _106583 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.close_wp_t)
in (let _106585 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.assert_p)
in (let _106587 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.assume_p)
in (let _106589 = (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.null_wp)
in (serialize_typ writer ast.Microsoft_FStar_Absyn_Syntax.trivial)))))))))))))))))))
and serialize_sigelt = (fun writer ast -> (match (ast) with
| Microsoft_FStar_Absyn_Syntax.Sig_pragma (_) -> begin
(failwith "NYI")
end
| Microsoft_FStar_Absyn_Syntax.Sig_tycon ((lid, bs, k, l1, l2, qs, _)) -> begin
(let _106606 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'a')
in (let _106608 = (serialize_lident writer lid)
in (let _106610 = (serialize_binders writer bs)
in (let _106612 = (serialize_knd writer k)
in (let _106614 = (serialize_list writer serialize_lident l1)
in (let _106616 = (serialize_list writer serialize_lident l2)
in (serialize_list writer serialize_qualifier qs)))))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_typ_abbrev ((lid, bs, k, t, qs, _)) -> begin
(let _106627 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'b')
in (let _106629 = (serialize_lident writer lid)
in (let _106631 = (serialize_binders writer bs)
in (let _106633 = (serialize_knd writer k)
in (let _106635 = (serialize_typ writer t)
in (serialize_list writer serialize_qualifier qs))))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_datacon ((lid1, t, tyc, qs, mutuals, _)) -> begin
(let t' = (match ((Microsoft_FStar_Absyn_Util.function_formals t)) with
| Some ((f, c)) -> begin
(Microsoft_FStar_Absyn_Syntax.mk_Typ_fun (f, (Microsoft_FStar_Absyn_Syntax.mk_Total (Microsoft_FStar_Absyn_Util.comp_result c))) None Microsoft_FStar_Absyn_Syntax.dummyRange)
end
| None -> begin
t
end)
in (let _106652 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'c')
in (let _106654 = (serialize_lident writer lid1)
in (let _106656 = (serialize_typ writer t')
in (let _106658 = (serialize_tycon writer tyc)
in (let _106660 = (serialize_list writer serialize_qualifier qs)
in (serialize_list writer serialize_lident mutuals)))))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_val_decl ((lid, t, qs, _)) -> begin
(let _106669 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'd')
in (let _106671 = (serialize_lident writer lid)
in (let _106673 = (serialize_typ writer t)
in (serialize_list writer serialize_qualifier qs))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_assume ((lid, fml, qs, _)) -> begin
(let _106682 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'e')
in (let _106684 = (serialize_lident writer lid)
in (let _106686 = (serialize_formula writer fml)
in (serialize_list writer serialize_qualifier qs))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_let ((lbs, _, l, quals)) -> begin
(let _106695 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'f')
in (let _106697 = (serialize_letbindings writer lbs)
in (let _106699 = (serialize_list writer serialize_lident l)
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer ((Support.Microsoft.FStar.Util.for_some (fun _105815 -> (match (_105815) with
| Microsoft_FStar_Absyn_Syntax.HasMaskedEffect -> begin
true
end
| _ -> begin
false
end))) quals)))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_main ((e, _)) -> begin
(let _106710 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'g')
in (serialize_exp writer e))
end
| Microsoft_FStar_Absyn_Syntax.Sig_bundle ((l, qs, lids, _)) -> begin
(let _106719 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'h')
in (let _106721 = (serialize_list writer serialize_sigelt l)
in (let _106723 = (serialize_list writer serialize_qualifier qs)
in (serialize_list writer serialize_lident lids))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_new_effect ((n, _)) -> begin
(let _106730 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'i')
in (serialize_new_effect writer n))
end
| Microsoft_FStar_Absyn_Syntax.Sig_effect_abbrev ((lid, bs, c, qs, _)) -> begin
(let _106740 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'j')
in (let _106742 = (serialize_lident writer lid)
in (let _106744 = (serialize_binders writer bs)
in (let _106746 = (serialize_comp writer c)
in (serialize_list writer serialize_qualifier qs)))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_sub_effect ((se, r)) -> begin
(let _106752 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'k')
in (serialize_sub_effect writer se))
end
| Microsoft_FStar_Absyn_Syntax.Sig_kind_abbrev ((l, binders, k, _)) -> begin
(let _106761 = (Support.Microsoft.FStar.Util.MkoWriter.write_char writer 'l')
in (let _106763 = (serialize_lident writer l)
in (let _106765 = (serialize_list writer serialize_binder binders)
in (serialize_knd writer k))))
end))

let rec deserialize_new_effect = (fun reader -> {Microsoft_FStar_Absyn_Syntax.mname = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.binders = (deserialize_list reader deserialize_binder); Microsoft_FStar_Absyn_Syntax.qualifiers = (deserialize_list reader deserialize_qualifier); Microsoft_FStar_Absyn_Syntax.signature = (deserialize_knd reader); Microsoft_FStar_Absyn_Syntax.ret = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.bind_wp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.bind_wlp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.if_then_else = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.ite_wp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.ite_wlp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.wp_binop = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.wp_as_type = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.close_wp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.close_wp_t = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.assert_p = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.assume_p = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.null_wp = (deserialize_typ reader); Microsoft_FStar_Absyn_Syntax.trivial = (deserialize_typ reader)})
and deserialize_sigelt = (fun reader -> (match ((Support.Microsoft.FStar.Util.MkoReader.read_char reader ())) with
| 'a' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_tycon (((deserialize_lident reader), (deserialize_binders reader), (deserialize_knd reader), (deserialize_list reader deserialize_lident), (deserialize_list reader deserialize_lident), (deserialize_list reader deserialize_qualifier), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'b' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_typ_abbrev (((deserialize_lident reader), (deserialize_binders reader), (deserialize_knd reader), (deserialize_typ reader), (deserialize_list reader deserialize_qualifier), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'c' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_datacon (((deserialize_lident reader), (deserialize_typ reader), (deserialize_tycon reader), (deserialize_list reader deserialize_qualifier), (deserialize_list reader deserialize_lident), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'd' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_val_decl (((deserialize_lident reader), (deserialize_typ reader), (deserialize_list reader deserialize_qualifier), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'e' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_assume (((deserialize_lident reader), (deserialize_formula reader), (deserialize_list reader deserialize_qualifier), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'f' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_let (((deserialize_letbindings reader), Microsoft_FStar_Absyn_Syntax.dummyRange, (deserialize_list reader deserialize_lident), if (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()) then begin
(Microsoft_FStar_Absyn_Syntax.HasMaskedEffect)::[]
end else begin
[]
end))
end
| 'g' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_main (((deserialize_exp reader), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'h' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_bundle (((deserialize_list reader deserialize_sigelt), (deserialize_list reader deserialize_qualifier), (deserialize_list reader deserialize_lident), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| 'i' -> begin
Microsoft_FStar_Absyn_Syntax.Sig_new_effect (((deserialize_new_effect reader), Microsoft_FStar_Absyn_Syntax.dummyRange))
end
| ('j') | ('k') | ('l') -> begin
(failwith "TODO")
end
| _ -> begin
(parse_error ())
end))

let serialize_sigelts = (fun writer ast -> (serialize_list writer serialize_sigelt ast))

let deserialize_sigelts = (fun reader -> (deserialize_list reader deserialize_sigelt))

let serialize_modul = (fun writer ast -> (let _106788 = (serialize_lident writer ast.Microsoft_FStar_Absyn_Syntax.name)
in (let _106790 = (serialize_sigelts writer [])
in (let _106792 = (serialize_sigelts writer ast.Microsoft_FStar_Absyn_Syntax.exports)
in (Support.Microsoft.FStar.Util.MkoWriter.write_bool writer ast.Microsoft_FStar_Absyn_Syntax.is_interface)))))

let deserialize_modul = (fun reader -> (let m = {Microsoft_FStar_Absyn_Syntax.name = (deserialize_lident reader); Microsoft_FStar_Absyn_Syntax.declarations = (deserialize_sigelts reader); Microsoft_FStar_Absyn_Syntax.exports = (deserialize_sigelts reader); Microsoft_FStar_Absyn_Syntax.is_interface = (Support.Microsoft.FStar.Util.MkoReader.read_bool reader ()); Microsoft_FStar_Absyn_Syntax.is_deserialized = true}
in (let _106796 = m
in {Microsoft_FStar_Absyn_Syntax.name = _106796.Microsoft_FStar_Absyn_Syntax.name; Microsoft_FStar_Absyn_Syntax.declarations = m.Microsoft_FStar_Absyn_Syntax.exports; Microsoft_FStar_Absyn_Syntax.exports = _106796.Microsoft_FStar_Absyn_Syntax.exports; Microsoft_FStar_Absyn_Syntax.is_interface = _106796.Microsoft_FStar_Absyn_Syntax.is_interface; Microsoft_FStar_Absyn_Syntax.is_deserialized = _106796.Microsoft_FStar_Absyn_Syntax.is_deserialized})))





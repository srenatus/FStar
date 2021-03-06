
let process_args = (fun _527672 -> (match (_527672) with
| () -> begin
(let file_list = (Support.Microsoft.FStar.Util.mk_ref [])
in (let res = (Support.Microsoft.FStar.Getopt.parse_cmdline (Microsoft_FStar_Options.specs ()) (fun i -> (file_list := (Support.List.append (! (file_list)) ((i)::[])))))
in (let _527679 = (match (res) with
| Support.Microsoft.FStar.Getopt.GoOn -> begin
(Support.Prims.ignore (Microsoft_FStar_Options.set_fstar_home ()))
end
| _ -> begin
()
end)
in (res, (! (file_list))))))
end))

let cleanup = (fun _527681 -> (match (_527681) with
| () -> begin
(Support.Microsoft.FStar.Util.kill_all ())
end))

let has_prims_cache = (fun l -> (Support.List.mem "Prims.cache" l))

let tc_prims = (fun _527683 -> (match (_527683) with
| () -> begin
(let solver = if (! (Microsoft_FStar_Options.verify)) then begin
Microsoft_FStar_ToSMT_Encode.solver
end else begin
Microsoft_FStar_ToSMT_Encode.dummy
end
in (let env = (Microsoft_FStar_Tc_Env.initial_env solver Microsoft_FStar_Absyn_Const.prims_lid)
in (let _527686 = (env.Microsoft_FStar_Tc_Env.solver.Microsoft_FStar_Tc_Env.init env)
in (let p = (Microsoft_FStar_Options.prims ())
in (let _527691 = (Microsoft_FStar_Parser_Driver.parse_file (Microsoft_FStar_Parser_DesugarEnv.empty_env ()) p)
in (match (_527691) with
| (dsenv, prims_mod) -> begin
(let _527694 = (Microsoft_FStar_Tc_Tc.check_module env (Support.List.hd prims_mod))
in (match (_527694) with
| (prims_mod, env) -> begin
(prims_mod, dsenv, env)
end))
end))))))
end))

let report_errors = (fun nopt -> (let errs = (match (nopt) with
| None -> begin
(Microsoft_FStar_Tc_Errors.get_err_count ())
end
| Some (n) -> begin
n
end)
in if (errs > 0) then begin
(let _527700 = (Support.Microsoft.FStar.Util.fprint1 "Error: %s errors were reported (see above)\n" (Support.Microsoft.FStar.Util.string_of_int errs))
in (exit (1)))
end))

let tc_one_file = (fun dsenv env fn -> (let _527707 = (Microsoft_FStar_Parser_Driver.parse_file dsenv fn)
in (match (_527707) with
| (dsenv, fmods) -> begin
(let _527717 = ((Support.List.fold_left (fun _527710 m -> (match (_527710) with
| (env, all_mods) -> begin
(let _527714 = (Microsoft_FStar_Tc_Tc.check_module env m)
in (match (_527714) with
| (ms, env) -> begin
(env, ms)
end))
end)) (env, [])) fmods)
in (match (_527717) with
| (env, all_mods) -> begin
(dsenv, env, (Support.List.rev all_mods))
end))
end)))

let tc_one_fragment = (fun curmod dsenv env frag -> (Support.Prims.try_with (fun _527723 -> (match (_527723) with
| () -> begin
(match ((Microsoft_FStar_Parser_Driver.parse_fragment curmod dsenv frag)) with
| Support.Microsoft.FStar.Util.Inl ((dsenv, modul)) -> begin
(let env = (match (curmod) with
| None -> begin
env
end
| Some (_) -> begin
(raise (Microsoft_FStar_Absyn_Syntax.Err ("Interactive mode only supports a single module at the top-level")))
end)
in (let _527750 = (Microsoft_FStar_Tc_Tc.tc_partial_modul env modul)
in (match (_527750) with
| (modul, npds, env) -> begin
Some ((Some ((modul, npds)), dsenv, env))
end)))
end
| Support.Microsoft.FStar.Util.Inr ((dsenv, decls)) -> begin
(match (curmod) with
| None -> begin
(failwith "Fragment without an enclosing module")
end
| Some ((modul, npds)) -> begin
(let _527763 = (Microsoft_FStar_Tc_Tc.tc_more_partial_modul env modul decls)
in (match (_527763) with
| (modul, npds', env) -> begin
Some ((Some ((modul, (Support.List.append npds npds'))), dsenv, env))
end))
end)
end)
end)) (fun _527722 -> (match (_527722) with
| Microsoft_FStar_Absyn_Syntax.Error ((msg, r)) -> begin
(let _527729 = (Microsoft_FStar_Tc_Errors.add_errors env (((msg, r))::[]))
in None)
end
| Microsoft_FStar_Absyn_Syntax.Err (msg) -> begin
(let _527733 = (Microsoft_FStar_Tc_Errors.add_errors env (((msg, Microsoft_FStar_Absyn_Syntax.dummyRange))::[]))
in None)
end
| e -> begin
(raise (e))
end))))

type input_chunks =
| Push of string
| Pop of string
| Code of (string * (string * string))

type stack_elt =
((Microsoft_FStar_Absyn_Syntax.modul * Microsoft_FStar_Absyn_Syntax.sigelt list) option * Microsoft_FStar_Parser_DesugarEnv.env * Microsoft_FStar_Tc_Env.env)

type stack =
stack_elt list

let interactive_mode = (fun dsenv env -> (let should_log = ((! (Microsoft_FStar_Options.debug)) <> [])
in (let log = if should_log then begin
(let transcript = (Support.Microsoft.FStar.Util.open_file_for_writing "transcript")
in (fun line -> (let _527775 = (Support.Microsoft.FStar.Util.append_to_file transcript line)
in (Support.Microsoft.FStar.Util.flush_file transcript))))
end else begin
(fun line -> ())
end
in (let _527781 = if (Support.Option.isSome (! (Microsoft_FStar_Options.codegen))) then begin
(let _527779 = (Support.Microsoft.FStar.Util.print_string "Code-generation is not supported in interactive mode")
in (exit (1)))
end
in (let chunk = (Support.Microsoft.FStar.Util.new_string_builder ())
in (let stdin = (Support.Microsoft.FStar.Util.open_stdin ())
in (let rec fill_chunk = (fun _527786 -> (match (_527786) with
| () -> begin
(let line = (match ((Support.Microsoft.FStar.Util.read_line stdin)) with
| None -> begin
(exit (0))
end
| Some (l) -> begin
l
end)
in (let _527791 = (log line)
in (let l = (Support.Microsoft.FStar.Util.trim_string line)
in if (Support.Microsoft.FStar.Util.starts_with l "#end") then begin
(let responses = (match ((Support.Microsoft.FStar.Util.split l " ")) with
| _::ok::fail::[] -> begin
(ok, fail)
end
| _ -> begin
("ok", "fail")
end)
in (let str = (Support.Microsoft.FStar.Util.string_of_string_builder chunk)
in (let _527803 = (Support.Microsoft.FStar.Util.clear_string_builder chunk)
in Code ((str, responses)))))
end else begin
if (Support.Microsoft.FStar.Util.starts_with l "#pop") then begin
(let _527805 = (Support.Microsoft.FStar.Util.clear_string_builder chunk)
in Pop (l))
end else begin
if (Support.Microsoft.FStar.Util.starts_with l "#push") then begin
(let _527807 = (Support.Microsoft.FStar.Util.clear_string_builder chunk)
in Push (l))
end else begin
if (l = "#finish") then begin
(exit (0))
end else begin
(let _527809 = (Support.Microsoft.FStar.Util.string_builder_append chunk line)
in (let _527811 = (Support.Microsoft.FStar.Util.string_builder_append chunk "\n")
in (fill_chunk ())))
end
end
end
end)))
end))
in (let rec go = (fun stack curmod dsenv env -> (match ((fill_chunk ())) with
| Pop (msg) -> begin
(let _527820 = ((Support.Prims.ignore) (Microsoft_FStar_Tc_Env.pop env msg))
in (let _527822 = (env.Microsoft_FStar_Tc_Env.solver.Microsoft_FStar_Tc_Env.refresh ())
in (let _527824 = ((Support.Prims.ignore) (Microsoft_FStar_Options.reset_options ()))
in (let _527835 = (match (stack) with
| [] -> begin
(failwith "Too many pops")
end
| hd::tl -> begin
(hd, tl)
end)
in (match (_527835) with
| ((curmod, dsenv, env), stack) -> begin
(go stack curmod dsenv env)
end)))))
end
| Push (msg) -> begin
(let stack = ((curmod, dsenv, env))::stack
in (let dsenv = (Microsoft_FStar_Parser_DesugarEnv.push dsenv)
in (let env = (Microsoft_FStar_Tc_Env.push env msg)
in (go stack curmod dsenv env))))
end
| Code ((text, (ok, fail))) -> begin
(let mark = (fun dsenv env -> (let dsenv = (Microsoft_FStar_Parser_DesugarEnv.mark dsenv)
in (let env = (Microsoft_FStar_Tc_Env.mark env)
in (dsenv, env))))
in (let reset_mark = (fun dsenv env -> (let dsenv = (Microsoft_FStar_Parser_DesugarEnv.reset_mark dsenv)
in (let env = (Microsoft_FStar_Tc_Env.reset_mark env)
in (dsenv, env))))
in (let commit_mark = (fun dsenv env -> (let dsenv = (Microsoft_FStar_Parser_DesugarEnv.commit_mark dsenv)
in (let env = (Microsoft_FStar_Tc_Env.commit_mark env)
in (dsenv, env))))
in (let fail = (fun curmod dsenv_mark env_mark -> (let _527866 = ((Support.Prims.ignore) (Microsoft_FStar_Tc_Errors.report_all ()))
in (let _527868 = (Microsoft_FStar_Tc_Errors.num_errs := 0)
in (let _527870 = (Support.Microsoft.FStar.Util.fprint1 "%s\n" fail)
in (let _527874 = (reset_mark dsenv_mark env_mark)
in (match (_527874) with
| (dsenv, env) -> begin
(go stack curmod dsenv env)
end))))))
in (let _527877 = (mark dsenv env)
in (match (_527877) with
| (dsenv_mark, env_mark) -> begin
(let res = (tc_one_fragment curmod dsenv_mark env_mark text)
in (match (res) with
| Some ((curmod, dsenv, env)) -> begin
if ((! (Microsoft_FStar_Tc_Errors.num_errs)) = 0) then begin
(let _527884 = (Support.Microsoft.FStar.Util.fprint1 "\n%s\n" ok)
in (let _527888 = (commit_mark dsenv env)
in (match (_527888) with
| (dsenv, env) -> begin
(go stack curmod dsenv env)
end)))
end else begin
(fail curmod dsenv_mark env_mark)
end
end
| _ -> begin
(fail curmod dsenv_mark env_mark)
end))
end))))))
end))
in (go [] None dsenv env)))))))))

let batch_mode_tc = (fun filenames -> (let _527895 = (tc_prims ())
in (match (_527895) with
| (prims_mod, dsenv, env) -> begin
(let _527908 = ((Support.List.fold_left (fun _527899 f -> (match (_527899) with
| (all_mods, dsenv, env) -> begin
(let _527904 = (tc_one_file dsenv env f)
in (match (_527904) with
| (dsenv, env, ms) -> begin
((Support.List.append all_mods ms), dsenv, env)
end))
end)) (prims_mod, dsenv, env)) filenames)
in (match (_527908) with
| (all_mods, dsenv, env) -> begin
(let _527909 = if ((! (Microsoft_FStar_Options.interactive)) && ((Microsoft_FStar_Tc_Errors.get_err_count ()) = 0)) then begin
(env.Microsoft_FStar_Tc_Env.solver.Microsoft_FStar_Tc_Env.refresh ())
end else begin
(env.Microsoft_FStar_Tc_Env.solver.Microsoft_FStar_Tc_Env.finish ())
end
in (all_mods, dsenv, env))
end))
end)))

let finished_message = (fun fmods -> if (not ((! (Microsoft_FStar_Options.silent)))) then begin
(let msg = if (! (Microsoft_FStar_Options.verify)) then begin
"Verified"
end else begin
if (! (Microsoft_FStar_Options.pretype)) then begin
"Lax type-checked"
end else begin
"Parsed and desugared"
end
end
in (let _527914 = ((Support.List.iter (fun m -> if (Microsoft_FStar_Options.should_verify m.Microsoft_FStar_Absyn_Syntax.name.Microsoft_FStar_Absyn_Syntax.str) then begin
(Support.Microsoft.FStar.Util.print_string (Support.Microsoft.FStar.Util.format2 "%s module: %s\n" msg (Microsoft_FStar_Absyn_Syntax.text_of_lid m.Microsoft_FStar_Absyn_Syntax.name)))
end)) fmods)
in (Support.Microsoft.FStar.Util.print_string "All verification conditions discharged successfully\n")))
end)

let codegen = (fun fmods -> if ((! (Microsoft_FStar_Options.codegen)) = Some ("OCaml")) then begin
(Support.Prims.try_with (fun _527918 -> (match (_527918) with
| () -> begin
(let mllib = (Microsoft_FStar_Backends_OCaml_ASTTrans.mlmod_of_fstars (Support.List.tail fmods))
in (let doc = (Microsoft_FStar_Backends_OCaml_Code.doc_of_mllib mllib)
in (Support.List.iter (fun _527932 -> (match (_527932) with
| (n, d) -> begin
(Support.Microsoft.FStar.Util.write_file (Microsoft_FStar_Options.prependOutputDir (Support.String.strcat n ".ml")) (FSharp_Format.pretty 120 d))
end)) doc)))
end)) (fun _527917 -> (match (_527917) with
| Microsoft_FStar_Backends_OCaml_ASTTrans.OCamlFailure ((rg, error)) -> begin
(let _527924 = (Support.Microsoft.FStar.Util.print_string (Support.Microsoft.FStar.Util.format2 "OCaml Backend Error: %s %s\n" (Support.Microsoft.FStar.Range.string_of_range rg) (Microsoft_FStar_Backends_OCaml_ASTTrans.string_of_error error)))
in (exit (1)))
end)))
end)

let go = (fun _527933 -> (let _527937 = (process_args ())
in (match (_527937) with
| (res, filenames) -> begin
(match (res) with
| Support.Microsoft.FStar.Getopt.Help -> begin
(Microsoft_FStar_Options.display_usage (Microsoft_FStar_Options.specs ()))
end
| Support.Microsoft.FStar.Getopt.Die (msg) -> begin
(Support.Microsoft.FStar.Util.print_string msg)
end
| Support.Microsoft.FStar.Getopt.GoOn -> begin
(let filenames = if ((! (Microsoft_FStar_Options.use_build_config)) || ((Support.List.length filenames) = 1)) then begin
(match (filenames) with
| f::[] -> begin
(Microsoft_FStar_Parser_Driver.read_build_config f)
end
| _ -> begin
(let _527946 = (Support.Microsoft.FStar.Util.print_string "--use_build_config expects just a single file on the command line and no other arguments")
in (exit (1)))
end)
end else begin
filenames
end
in (let _527952 = (batch_mode_tc filenames)
in (match (_527952) with
| (fmods, dsenv, env) -> begin
(let _527953 = (report_errors None)
in if (! (Microsoft_FStar_Options.interactive)) then begin
(interactive_mode dsenv env)
end else begin
(let _527955 = (codegen fmods)
in (finished_message fmods))
end)
end)))
end)
end)))

let main = (fun _527957 -> (match (_527957) with
| () -> begin
(Support.Prims.try_with (fun _527959 -> (match (_527959) with
| () -> begin
(let _527970 = (go ())
in (let _527972 = (cleanup ())
in (exit (0))))
end)) (fun _527958 -> (match (_527958) with
| e -> begin
(let _527962 = if (Microsoft_FStar_Absyn_Util.handleable e) then begin
(Microsoft_FStar_Absyn_Util.handle_err false () e)
end
in (let _527964 = if (! (Microsoft_FStar_Options.trace_error)) then begin
(Support.Microsoft.FStar.Util.fprint2 "\nUnexpected error\n%s\n%s\n" (Support.Microsoft.FStar.Util.message_of_exn e) (Support.Microsoft.FStar.Util.trace_of_exn e))
end else begin
if (not ((Microsoft_FStar_Absyn_Util.handleable e))) then begin
(Support.Microsoft.FStar.Util.fprint1 "\nUnexpected error; please file a bug report, ideally with a minimized version of the source program that triggered the error.\n%s\n" (Support.Microsoft.FStar.Util.message_of_exn e))
end
end
in (let _527966 = (cleanup ())
in (exit (1)))))
end)))
end))





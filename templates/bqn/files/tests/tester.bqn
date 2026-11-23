# "name" Ok <flag>
#
# Twelve lines rather than a dependency: BQN has no test framework, and a
# namespace holding two counters is the whole of one. The output is TAP, so the
# runner can tell a failed assertion from a program that stopped part way
# through.

cases ← 0
failed ← 0

Plan ⇐ {•Out "1.." ∾ •Repr 𝕩}

# ↩ modifies a name this file already declared, which is how a function
# reaches the state outside it. ← here would declare a new local and the
# counters would never move.
Ok ⇐ {name 𝕊 pass:
  cases ↩ cases + 1
  failed ↩ failed + ¬ pass
  •Out (pass ⊑ ⟨"not ok ", "ok "⟩) ∾ (•Repr cases) ∾ " - " ∾ name
}

# •Exit sets the process status, so a file run on its own is already a test
# command. The runner checks the plan as well, because an error ends the
# program before this line.
TapDone ⇐ {𝕤 ⋄ •Exit 0 < failed}

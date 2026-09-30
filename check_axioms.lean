import QEkr

-- Expected output (v1.1, Lean v4.29.0 / Mathlib 8a178386):
--   'QEkr.q_ekr' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound]
-- `sorryAx` is expected: the proof of `q_ekr` is not formalized (see
-- capability/qekr_substrate.gap.md). Run with `lake env lean check_axioms.lean`.
#check @QEkr.q_ekr
#print axioms QEkr.q_ekr

/-
Copyright (c) 2026 papanokechi. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: papanokechi
-/

-- QEkr root file. Lake's `lean_lib QEkr` builds this file as the default target.
-- v1.1: it also imports the module containing `q_ekr`; in v1.0 the default
-- `lake build` never compiled that theorem.

import QEkr.Substrate
import QEkr.PointPencilCounting.Basic

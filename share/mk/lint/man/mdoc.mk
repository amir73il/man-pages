########################################################################
# Copyright 2023, Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier: GPL-3.0-or-later
########################################################################


ifndef MAKEFILE_LINT_MAN_MDOC_INCLUDED
MAKEFILE_LINT_MAN_MDOC_INCLUDED := 1


include $(MAKEFILEDIR)/cmd.mk
include $(MAKEFILEDIR)/build/_.mk
include $(MAKEFILEDIR)/lint/_.mk
include $(MAKEFILEDIR)/lint/man/_.mk
include $(MAKEFILEDIR)/src.mk


_LINT_mdoc_mandoc:=$(patsubst $(MANDIR)/%,$(_MANDIR)/%.lint-mdoc.mandoc.touch,$(NONSO_MDOC))


linters_mdoc := mandoc
lint_mdoc    := $(foreach x,$(linters_mdoc),lint-mdoc-$(x))


$(_LINT_mdoc_mandoc): $(_MANDIR)/%.lint-mdoc.mandoc.touch: $(MANDIR)/% | $$(@D)/
	$(info LINT (mandoc)	$@)
	! ($(MANDOC) -mdoc $(MANDOCFLAGS) $< 2>&1 \
	   | $(GREP) -v 'STYLE: legacy man(7) date format: Dd ' \
	   | $(GREP) -v 'STYLE: lower case character in document title: Dt ' \
	   | $(GREP) -v 'STYLE: operating system explicitly specified: Os ' \
	   | $(GREP) -v 'WARNING: cross reference to self: Xr ' \
	   ||:; \
	) \
	| $(GREP) ^ >&2
	touch $@


.PHONY: $(lint_mdoc)
$(lint_mdoc): lint-mdoc-%: $$(_LINT_mdoc_%);

.PHONY: lint-mdoc
lint-mdoc: $(lint_mdoc);


endif  # include guard
# Copyright 2024 Alejandro Colomar <alx@kernel.org>
# SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception


ifndef MAKEFILE_DIST_CHECK_TAR_INCLUDED
MAKEFILE_DIST_CHECK_TAR_INCLUDED := 1


include $(MAKEFILEDIR)/configure/build-depends/coreutils.mk
include $(MAKEFILEDIR)/configure/build-depends/tar.mk
include $(MAKEFILEDIR)/configure/version.mk
include $(MAKEFILEDIR)/dist/check/_.mk
include $(MAKEFILEDIR)/dist/tar.mk


$(_DISTCHECKDIR)/$(DISTNAME).tar: $(DISTFILE) $(MK) | $$(@D)/
	$(info	$(INFO_)CP		$@)
	$(CP) -T $< $@

$(_DISTCHECKSRCDIR): %: %.tar $(MK) | $$(@D)/
	$(info	$(INFO_)TAR xf		$<)
	$(RM) -rf $@
	cd $(dir $<) \
	&& $(TAR) xf $(notdir $<)
	$(TOUCH) $@


endif  # include guard
# Included custom configs change the value of MAKEFILE_LIST
# Extract the required reference beforehand so we can use it for help target
MAKEFILE_NAME := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
override MAKE_CUR := $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
override MAKE_DIR := $(shell dirname $(MAKE_CUR))

# Include custom config if it is available to apply any overrides
-include Makefile.config

## --- DGGRID Examples ---

# default location if https://github.com/sahrk/DGGRID
# is cloned and built at the same leval as this repository
# otherwise, adjust accordingly with env variable
DGGRID_EXE ?= $(MAKE_DIR)/../DGGRID/build/src/apps/dggrid/dggrid
dggrid_check_exists = $(if $(wildcard $(DGGRID_EXE)),($(shell realpath $(DGGRID_EXE))),(!) DGGRID_EXE not found)

# Find all .meta files in subdirectories
DGGRID_META_FILES := $(shell find . -type f -name '*.meta')
DGGRID_META_OUTS := $(DGGRID_META_FILES:%=%.out)

# Pattern rule: .meta.out depends on .meta
%.meta.out: %.meta
	cd "$(shell dirname "$<")"; $(realpath $(DGGRID_EXE)) $(shell realpath "$<") > $(shell realpath "$@")

# Add dependency on inputs subdirectory files if present
define add_inputs_deps
$1.out: $$(shell [ -d "$$(dirname $1)inputs" ] && find "$$(dirname $1)inputs" -type f)
endef
$(foreach f,$(DGGRID_META_FILES),$(eval $(call add_inputs_deps,$(f))))

.PHONY: meta-info
dggrid-info:
	@echo "DGGRID_EXE:        [$(DGGRID_EXE)] $(dggrid_check_exists)"
	@echo "DGGRID_META_FILES: [$(DGGRID_META_FILES)]"
	@echo "DGGRID_META_OUTS:  [$(DGGRID_META_OUTS)]"

# Run the command for every .meta file in subdirectories if they or their inputs were modified
dggrid-run: $(DGGRID_META_OUTS)

.PHONY: dggrid-run-force
dggrid-run-force:
	$(MAKE) --always-make dggrid-run

.PHONY: dggrid-clean
dggrid-clean:
	@rm -f $(DGGRID_META_OUTS)
	@rm -fr $(foreach f,$(DGGRID_META_FILES),$(shell find -path "$$(dirname $(f))/outputs/*" ! -name .gitkeep))

### --- Conda Management ---

CONDA_TOOL ?= mamba

.PHONY: conda-create
conda-create:
	$(CONDA_TOOL) env create -f "$(MAKE_DIR)/environment.yml"

.PHONY: conda-update
conda-update:
	$(CONDA_TOOL) env update -f "$(MAKE_DIR)/environment.yml"

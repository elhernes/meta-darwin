# "-lreadline" resolves to the macOS SDK's libreadline.tbd stub (found via
# the runtime/usr/lib -L path, which comes before -L./lib/readline) instead
# of the readline built in-tree, which leaves all rl_* symbols undefined.
# Link the in-tree archive by path.
EXTRA_OEMAKE:append:darwin21 = " 'READLINE_LIB=$(READLINE_LIBRARY)'"

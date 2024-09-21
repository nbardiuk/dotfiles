-- [nfnl] Compiled from fnl/dotfiles/init.fnl by https://github.com/Olical/nfnl, do not edit.
local autopairs = require("nvim-autopairs")
local c = require("nfnl.core")
local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local conform = require("conform")
local dressing = require("dressing")
local fidget = require("fidget")
local jdtls = require("jdtls")
local lspconfig = require("lspconfig")
local lualine = require("lualine")
local luasnip = require("luasnip")
local metals = require("metals")
local null_ls = require("null-ls")
local oil = require("oil")
local surround = require("nvim-surround")
local tel = require("telescope.builtin")
local telescope = require("telescope")
local themes = require("telescope.themes")
local tree_context = require("treesitter-context")
local tree_conf = require("nvim-treesitter.configs")
local other = require("other-nvim")
local wiki_telescope = require("wiki.telescope")
local tsc = require("tsc")
vim.opt.exrc = true
tree_context.setup({enable = true, separator = "\194\183"})
local function au(group_name, event, pattern, body)
  local callback
  local function _1_()
    body()
    return nil
  end
  callback = _1_
  local group = vim.api.nvim_create_augroup(group_name, {clear = true})
  local nested = true
  return vim.api.nvim_create_autocmd(event, {group = group, pattern = pattern, callback = callback, nested = nested})
end
tree_conf.setup({indent = {enable = true}, highlight = {enable = true}, textobjects = {select = {enable = true, lookahead = true, keymaps = {aa = "@parameter.outer", ia = "@parameter.inner", ac = "@comment.outer", as = "@statement.outer"}}, swap = {enable = true, swap_next = {[">a"] = "@parameter.inner"}, swap_previous = {["<lt>a"] = "@parameter.inner"}}}, matchup = {enable = true}, auto_install = false})
vim.g.mapleader = " "
vim.g.maplocalleader = "\t"
local function indexed__3enamed(keys, tbl)
  for index = #tbl, 1, -1 do
    local key = tbl[index]
    local _2_ = keys[key]
    if (nil ~= _2_) then
      local value = _2_
      table.remove(tbl, index)
      tbl[key] = value
    else
    end
  end
  return tbl
end
local function keymap(m, args)
  local options = {buffer = true, silent = true, remap = true, noremap = true}
  local args0 = indexed__3enamed(options, args)
  local lhs = args0[1]
  local rhs = args0[2]
  local opts = c["select-keys"](args0, c.keys(options))
  return vim.keymap.set(m, lhs, rhs, opts)
end
local function nmap(...)
  return keymap("n", {"remap", ...})
end
local function nnoremap(...)
  return keymap("n", {"noremap", ...})
end
local function omap(...)
  return keymap("o", {"remap", ...})
end
local function tnoremap(...)
  return keymap("t", {"noremap", ...})
end
local function vnoremap(...)
  return keymap("v", {"noremap", ...})
end
local function xmap(...)
  return keymap("x", {"remap", ...})
end
local function xnoremap(...)
  return keymap("x", {"noremap", ...})
end
local bottom_height = 15
telescope.setup({defaults = themes.get_ivy({layout_config = {height = bottom_height}, preview = false}), extensions = {fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case"}}, pickers = {live_grep = {mappings = {i = {["<c-f>"] = "to_fuzzy_refine"}}}}})
telescope.load_extension("fzf")
nnoremap("<Leader>r", tel.resume)
nnoremap("<Leader>k", tel.help_tags)
local function _4_()
  return tel.man_pages({sections = "ALL"})
end
nnoremap("<Leader>m", _4_)
nnoremap("<Leader><Leader>", tel.commands)
local function _5_()
  return tel.find_files({find_command = {"fd", "--hidden", "--exclude", ".git"}})
end
nnoremap("<Leader>n", _5_)
local function _6_()
  return tel.buffers({sort_lastused = true, ignore_current_buffer = false})
end
nnoremap("<Leader>e", _6_)
dressing.setup({select = {telescope = themes.get_ivy({layout_config = {height = bottom_height}})}})
local function _7_()
  return vim.api.nvim_list_bufs()
end
local function _8_(_241)
  return luasnip.lsp_expand(_241.body)
end
local function _9_(_241)
  if cmp.visible() then
    return cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    return luasnip.expand_or_jump()
  else
    return _241()
  end
end
local function _11_(_241)
  if cmp.visible() then
    return cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    return luasnip.jump(-1)
  else
    return _241()
  end
end
cmp.setup({sources = {{name = "nvim_lsp"}, {name = "conjure"}, {name = "treesitter"}, {name = "lausnip"}, {name = "path"}, {name = "buffer", keyword_length = 5, options = {get_bufnrs = _7_}}, {name = "spell", keyword_length = 5}}, snippet = {expand = _8_}, mapping = {["<C-n>"] = cmp.mapping(_9_, {"i", "s"}), ["<C-p>"] = cmp.mapping(_11_, {"i", "s"}), ["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-u>"] = cmp.mapping.scroll_docs(4), ["<C-e>"] = cmp.mapping.close(), ["<Space>"] = cmp.mapping.confirm({select = false})}})
cmp.setup.cmdline("/", {mapping = cmp.mapping.preset.cmdline(), sources = {{name = "buffer"}}})
cmp.setup.cmdline(":", {mapping = cmp.mapping.preset.cmdline(), sources = {{name = "path"}, {name = "cmdline"}}, matching = {disallow_symbol_nonprefix_matching = false}})
local lsp_capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_nvim_lsp.default_capabilities(), {workspace = {workspaceEdit = {documentChanges = true}}})
surround.setup({})
do
  local escape
  local function _13_(_241)
    return vim.fn.escape(_241, ";,.\"|\\")
  end
  escape = _13_
  local ua = "\208\185\209\134\209\131\208\186\208\181\208\189\208\179\209\136\209\137\208\183\209\132\209\150\208\178\208\176\208\191\209\128\208\190\208\187\208\180\209\148\209\143\209\135\209\129\208\188\208\184\209\130\209\140\208\177\209\142\208\153\208\166\208\163\208\154\208\149\208\157\208\147\208\168\208\169\208\151\208\164\208\134\208\146\208\144\208\159\208\160\208\158\208\155\208\148\208\132\208\175\208\167\208\161\208\156\208\152\208\162\208\172\208\145\208\174\208\150\208\182"
  local en = "qwertyuiopasdfghjkl'zxcvbnm,.QWERTYUIOPASDFGHJKL\"ZXCVBNM<?:;"
  vim.opt.langmap = (escape(ua) .. ";" .. escape(en))
end
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.complete:remove("t")
vim.opt.shortmess:append("c")
vim.opt.shortmess:append("I")
vim.opt.shortmess:append("W")
vim.opt.shortmess:remove("F")
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.startofline = false
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup_setpos"
vim.opt.clipboard = "unnamedplus"
local function _14_()
  return vim.highlight.on_yank({higroup = "Visual"})
end
au("yank", "TextYankPost", "*", _14_)
vim.opt.virtualedit = "block"
vim.opt.matchpairs:append("<:>")
vim.opt.joinspaces = false
vim.opt.signcolumn = "yes:1"
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.colorcolumn = {100}
vim.opt.spelllang = "en_us"
vim.opt.spell = false
vim.opt.spellsuggest:append(("" .. bottom_height))
nnoremap("silent", "]s", "<Cmd>execute ':setlocal spell'| normal! ]s<CR>")
nnoremap("silent", "]S", "<Cmd>execute ':setlocal spell'| normal! ]S<CR>")
nnoremap("silent", "[s", "<Cmd>execute ':setlocal spell'| normal! [s<CR>")
nnoremap("silent", "[S", "<Cmd>execute ':setlocal spell'| normal! [S<CR>")
vim.opt.wildmode = {"list:longest", "full"}
vim.opt.wildignorecase = true
vim.opt.list = true
vim.opt.listchars = {trail = "\194\183", tab = "\226\150\184 ", nbsp = "+"}
vim.opt.showbreak = "\226\134\179 "
vim.opt.shell = "/usr/bin/env zsh"
local function _15_()
  return vim.cmd.wincmd("=")
end
au("autoresize", "VimResized", "*", _15_)
vim.opt.winwidth = 80
vim.opt.winminwidth = 8
vim.opt.winheight = 24
vim.opt.winminheight = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
nnoremap("<Leader>x", "<Cmd>bd!<CR>")
nnoremap("<Leader>X", "<Cmd>%bd!<CR>")
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
vim.opt.formatoptions = ("c" .. "j" .. "l" .. "n" .. "o" .. "q" .. "r")
vim.opt.background = "light"
do
  vim.cmd("colorscheme grey")
  do
    local to_clear = {"Identifier", "Function", "Statement", "Conditional", "Repeat", "Label", "Operator", "Exception", "PreProc", "Include", "Define", "Macro", "PreCondit", "Type", "StorageClass", "Structure", "Typedef", "Special", "Tag"}
    for _, group in pairs(to_clear) do
      vim.cmd(("highlight clear " .. group))
    end
  end
  local to_link = {Delimiter = "NonText", Comment = "Directory", Whitespace = "VertSplit", TermCursorNC = "Cursor", Boolean = "Yellow", ["@symbol"] = "Keyword", ["@lsp.type.namespace"] = "@namespace", ["@lsp.type.type"] = "@type", ["@lsp.type.class"] = "@type", ["@lsp.type.enum"] = "@type", ["@lsp.type.interface"] = "@type", ["@lsp.type.struct"] = "@structure", ["@lsp.type.parameter"] = "@parameter", ["@lsp.type.variable"] = "@variable", ["@lsp.type.property"] = "@property", ["@lsp.type.enumMember"] = "@constant", ["@lsp.type.function"] = "@function", ["@lsp.type.method"] = "@method", ["@lsp.type.macro"] = "@macro", ["@lsp.type.decorator"] = "@function", OilDir = "Directory", OilLink = "Yellow"}
  for src, dest in pairs(to_link) do
    vim.api.nvim_set_hl(0, src, {link = dest, default = false})
  end
end
vim.opt.ruler = false
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.title = true
vim.opt.titlestring = "%f"
vim.opt.winbar = "%f"
lualine.setup({options = {icons_enabled = true, globalstatus = true}, extensions = {"oil", "fugitive", "quickfix"}, sections = {lualine_y = {"progress", {"searchcount", maxcount = 99999, timeout = 500}}}})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevelstart = 999
vim.opt.fillchars = "fold:\226\128\167"
nnoremap("<BS>", "za")
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.inccommand = "nosplit"
vim.opt.gdefault = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
vnoremap("/", "y/\\V<C-r>\"<CR>")
nnoremap("/", "/\\v")
nnoremap("<Leader>f", tel.live_grep)
nnoremap("<Leader>q", tel.quickfix)
vim.g.FerretMaxResults = 10000
vim.g.FerretQFHandler = ("botright copen " .. bottom_height)
vim.g.FerretExecutable = "rg"
vim.g.FerretExecutableArguments = {rg = (" --vimgrep" .. " --no-heading" .. " --smart-case" .. " --sort path" .. " --hidden" .. " --glob=!.git")}
vim.g.FerretMap = false
nmap("<Leader>*", "<Plug>(FerretAckWord)")
vnoremap("<Leader>*", "y:Ack <C-r>\"<CR>")
nmap("<Leader>/", "<Plug>(FerretAck)")
vnoremap("<Leader>/", "y:Ack <C-r>\"")
vim.opt.path = {".", "**"}
oil.setup({columns = {{"permissions", highlight = "NonText"}, {"size", highlight = "String"}, {"ctime", highlight = "Number", format = "%Y-%m-%d %H:%M"}, "icon"}, view_options = {show_hidden = true}, keymaps = {["g?"] = "actions.show_help", ["<CR>"] = "actions.select", ["<C-s>"] = "actions.select_vsplit", ["<C-r>"] = "actions.refresh", ["<C-p>"] = "actions.preview", ["<C-c>"] = "actions.close", ["-"] = "actions.parent", _ = "actions.open_cwd", ["g."] = "actions.toggle_hidden", ["."] = "actions.open_cmdline", [","] = "actions.open_cmdline_dir", gy = "actions.copy_entry_path"}, use_default_keymaps = false})
nmap("-", oil.open)
vim.opt.updatetime = 100
vim.opt.diffopt:append({"indent-heuristic", "internal", "algorithm:histogram", "linematch:60"})
vim.g.gitgutter_map_keys = false
nnoremap("silent", "<Leader>gd", "<Cmd>Gdiffsplit<CR>")
nnoremap("silent", "<Leader>gs", "<Cmd>Git|only<CR>")
nnoremap("silent", "<Leader>gc", tel.git_status)
nnoremap("silent", "<Leader>gl", "<Cmd>Gclog<CR>")
local function _16_()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if string.match(buf_name, "^fugitive://.*$") then
      vim.api.nvim_buf_delete(buf, {})
    else
    end
  end
  return nil
end
nnoremap("silent", "<Leader>gq", _16_)
nmap("<Leader>hp", "<Plug>(GitGutterPreviewHunk)")
nmap("<Leader>hs", "<Plug>(GitGutterStageHunk)")
nmap("<Leader>hu", "<Plug>(GitGutterUndoHunk)")
nmap("[h", "<Plug>(GitGutterPrevHunk)")
nmap("]h", "<Plug>(GitGutterNextHunk)")
omap("ih", "<Plug>(GitGutterTextObjectInnerPending)")
xmap("ih", "<Plug>(GitGutterTextObjectInnerVisual)")
omap("ah", "<Plug>(GitGutterTextObjectOuterPending)")
xmap("ah", "<Plug>(GitGutterTextObjectOuterVisual)")
nnoremap("yoh", "<Cmd>GitGutterSignsToggle<CR>")
local function _18_()
  if vim.tbl_contains(vim.opt.diffopt:get(), "iwhite") then
    vim.opt.diffopt:remove("iwhite")
    return vim.notify("noiwhite")
  else
    vim.opt.diffopt:append("iwhite")
    return vim.notify("iwhite")
  end
end
nnoremap("<Leader>dw", _18_)
local function _20_()
  vim.opt_local.spell = true
  return nil
end
au("gitcommit", "FileType", "gitcommit", _20_)
local function _21_(_241)
  return vim.ui.open(_241.args)
end
vim.api.nvim_create_user_command("Browse", _21_, {nargs = 1})
vim.g.fugitive_summary_format = "%aN [%ah] %d %s"
vim.g.wiki_root = "~/Notes"
vim.g.wiki_mappings_global = {["<Plug>(wiki-open)"] = "<Leader>we"}
vim.g.wiki_mappings_local = {["<Plug>(wiki-journal-copy-tonext)"] = "", ["<Plug>(wiki-link-next)"] = "", ["<Plug>(wiki-link-return)"] = "", ["<Plug>(wiki-link-toggle)"] = "", ["<Plug>(wiki-page-toc)"] = ""}
nnoremap("<Leader>wn", wiki_telescope.pages)
local function _22_()
  return tel.live_grep({prompt_title = "Wiki grep", cwd = vim.g.wiki_root})
end
nnoremap("<Leader>wf", _22_)
null_ls.setup({sources = {null_ls.builtins.diagnostics.vale.with({filetypes = {"markdown", "gitcommit"}}), null_ls.builtins.diagnostics.hadolint, null_ls.builtins.diagnostics.codespell}})
conform.setup({formatters_by_ft = {bash = {"shfmt"}, json = {"jq"}, sh = {"shfmt"}, sql = {"pg_format"}, xml = {"xmllint"}, yaml = {"yamlfmt"}}, formatters = {shfmt = {prepend_args = {"--indent", "2", "--space-redirects"}}, pg_format = {prepend_args = {"--spaces", "2", "--comma-break", "--function-case", "2", "--placeholder", "\\?[a-zA-Z]+\\?"}}}, default_format_opts = {lsp_format = "fallback", async = true, stop_after_first = true}})
vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
nnoremap("<Leader>lf", conform.format)
nnoremap("<Leader>la", vim.lsp.buf.code_action)
local function lsp_buffer_mappings()
  nnoremap("buffer", "gd", vim.lsp.buf.definition)
  nnoremap("buffer", "<Leader>lt", vim.lsp.buf.type_definition)
  nnoremap("buffer", "<Leader>li", vim.lsp.buf.implementation)
  nnoremap("buffer", "}", vim.lsp.buf.references)
  return nnoremap("buffer", "<Leader>lr", vim.lsp.buf.rename)
end
vim.diagnostic.config({underline = true, float = {show_header = false}, severity_sort = true, signs = true, virtual_text = false})
local function _23_()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  local _24_
  if vim.diagnostic.is_enabled() then
    _24_ = "enabled"
  else
    _24_ = "disabled"
  end
  return vim.notify(("diagnostic " .. _24_))
end
nnoremap("yol", _23_)
nnoremap("<Leader>dg", vim.diagnostic.setqflist)
nnoremap("<Leader>dl", vim.diagnostic.setloclist)
nnoremap("<Leader>do", vim.diagnostic.open_float)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "single"})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.singature_help, {border = "single"})
fidget.setup({})
vim.g["conjure#eval#result_register"] = "e"
vim.g["conjure#log#botright"] = true
local function _26_()
  return vim.diagnostic.disable(0)
end
au("conjure-log", "BufNewFile", "conjure-log-*", _26_)
vim.g["conjure#filetypes"] = {"clojure", "fennel"}
vim.g["conjure#eval#gsubs"] = {["do-comment"] = {"^%(comment[%s%c]", "(do "}}
vim.g["conjure#mapping#doc_word"] = "k"
local function _27_()
  return lsp_buffer_mappings()
end
au("python", "FileType", "python", _27_)
lspconfig.pylsp.setup({capabilities = lsp_capabilities})
local function _28_()
  return lsp_buffer_mappings()
end
au("typescript", "FileType", {"typescript", "javascript", "typescriptreact", "javascriptreact"}, _28_)
lspconfig.ts_ls.setup({capabilities = lsp_capabilities})
tsc.setup({auto_start_watch_mode = true, flags = {watch = true}})
local function _29_()
  lsp_buffer_mappings()
  local conf = {init_options = {statusBarProvider = "on"}, settings = {showImplicitArguments = true, showImplicitConversionsAndClasses = true, showInferredType = true, superMethodLensesEnabled = true, enableSemanticHighlighting = true, excludedPackages = {"akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl"}}}
  return metals.initialize_or_attach(vim.tbl_deep_extend("force", metals.bare_config(), conf))
end
au("scala", "FileType", {"scala", "sbt", "java"}, _29_)
local function _30_()
  lsp_buffer_mappings()
  local root_dir = vim.fs.dirname(vim.fs.find({".git", "pom.xml"}, {upward = true})[1])
  local workspace_dir = vim.fn.expand(("~/.local/state/jdtls" .. root_dir))
  local conf = {cmd = {"jdtls", "-data", workspace_dir}, root_dir = root_dir, settings = {java = {configuration = {maven = {globalSettings = "/opt/homebrew/Cellar/atlassian-plugin-sdk/8.2.10/libexec/apache-maven-3.9.5/conf/settings.xml"}}, maven = {downloadSources = true}}}}
  return jdtls.start_or_attach(conf)
end
au("java", "FileType", {"java"}, _30_)
local function _31_()
  return lsp_buffer_mappings()
end
au("rust", "FileType", "rust", _31_)
lspconfig.rust_analyzer.setup({capabilities = lsp_capabilities})
local function _32_()
  lsp_buffer_mappings()
  vim.opt_local.tabstop = 2
  vim.opt_local.softtabstop = 2
  vim.opt_local.shiftwidth = 2
  vim.opt_local.expandtab = true
  return nil
end
au("c", "FileType", {"c", "cpp"}, _32_)
lspconfig.ccls.setup({capabilities = lsp_capabilities})
vim.g.sexp_filetypes = "clojure,scheme,lisp,fennel"
local function _33_()
  xmap("buffer", "ip", "<Plug>(sexp_inner_element)<Plug>(sexp_move_to_next_element_tail)")
  omap("buffer", "ip", "<Cmd>normal vip<CR>")
  xmap("buffer", "iP", "<Plug>(sexp_inner_element)o<Plug>(sexp_move_to_prev_element_head)")
  omap("buffer", "iP", "<Cmd>normal viP<CR>")
  nmap("buffer", ">p", "vip>eo<Esc>")
  nmap("buffer", "<p", "vip<eo<Esc>")
  xmap("buffer", ">e", "<Plug>(sexp_swap_element_forward)")
  xmap("buffer", "<e", "<Plug>(sexp_swap_element_backward)")
  xmap("buffer", ">f", "<Plug>(sexp_swap_list_forward)")
  return xmap("buffer", "<f", "<Plug>(sexp_swap_list_backward)")
end
au("sexp", "FileType", {"clojure", "scheme", "lisp", "fennel"}, _33_)
vim.g.sexp_enable_insert_mode_mappings = false
autopairs.setup({disable_in_visualblock = true, enable_check_bracket_line = false})
local function clj_ignore()
  vim.cmd("normal `[")
  return vim.cmd("normal i#_")
end
local function do_clj_ignore(form)
  vim.opt.operatorfunc = "v:lua.require'dotfiles'.clj_ignore"
  return vim.api.nvim_feedkeys(("g@" .. (form or "")), "m", false)
end
local function conjure_eval(form)
  return vim.cmd.ConjureEval(form)
end
local function _34_()
  lsp_buffer_mappings()
  xnoremap("buffer", "<Leader>cc", do_clj_ignore)
  nnoremap("buffer", "<Leader>cc", do_clj_ignore)
  nnoremap("buffer", "<Leader>cu", "<Cmd>let s=@/<CR>l?\\v(#_)+<CR>dgn:let @/=s<CR>")
  local function _35_()
    return vim.lsp.buf.execute_command({command = "move-form", arguments = {("file://" .. vim.fn.expand("%:p")), (vim.fn.line(".") - 1), (vim.fn.col(".") - 1), vim.fn.input("File: ", vim.fn.expand("%:p:h"), "file")}})
  end
  nnoremap("buffer", "<Leader>lm", _35_)
  local function _36_()
    return conjure_eval("((requiring-resolve 'portal.api/open))")
  end
  nnoremap("buffer", "<LocalLeader>po", _36_)
  local function _37_()
    return conjure_eval("((requiring-resolve 'portal.api/close))")
  end
  nnoremap("buffer", "<LocalLeader>pc", _37_)
  local function _38_()
    return conjure_eval("((requiring-resolve 'portal.api/clear))")
  end
  nnoremap("buffer", "<LocalLeader>pr", _38_)
  vim.opt_local.tabstop = 2
  vim.opt_local.softtabstop = 2
  vim.opt_local.shiftwidth = 2
  vim.opt_local.expandtab = true
  vim.opt_local.includeexpr = "substitute(substitute(v:fname,'\\.','/','g'),'-','_','g')"
  vim.opt_local.suffixesadd = ".clj"
  return nil
end
au("clojure", "FileType", "clojure", _34_)
vim.g["conjure#client#clojure#nrepl#test#runner"] = "clojure"
vim.g["conjure#client#clojure#nrepl#eval#raw_out"] = true
vim.g["conjure#client#clojure#nrepl#refresh#backend"] = "clj-reload"
lspconfig.clojure_lsp.setup({capabilities = lsp_capabilities})
conform.formatters_by_ft.clojure = {"zprint"}
local function _39_()
  return lsp_buffer_mappings()
end
au("fennel", "FileType", "fennel", _39_)
lspconfig.fennel_ls.setup({capabilities = lsp_capabilities, settings = {["fennel-ls"] = {["extra-globals"] = "vim"}}})
conform.formatters_by_ft.fennel = {"fnlfmt"}
vim.g.slime_target = "tmux"
vim.g.slime_dont_ask_default = true
vim.g.slime_default_config = {socket_name = "default", target_pane = "{right-of}"}
vim.g.slime_no_mappings = true
xmap("<Leader>s", "<Plug>SlimeRegionSend")
nmap("<Leader>s", "<Plug>SlimeMotionSend")
nmap("<Leader>ss", "<Plug>SlimeLineSend")
nmap("<Leader>sc", "<Plug>SlimeConfig")
xnoremap("<Leader>sy", "\"sy")
nnoremap("<Leader>sp", "<Cmd>SlimeSend1 <C-R>s<CR>")
local function scm_ignore()
  vim.cmd("normal `[")
  return vim.cmd("normal i#;")
end
local function do_scm_ignore(form)
  vim.opt.operatorfunc = "v:lua.require'dotfiles'.scm_ignore"
  return vim.api.nvim_feedkeys(("g@" .. (form or "")), "m", false)
end
local function _40_()
  xnoremap("buffer", "<Leader>c", do_scm_ignore)
  local function _41_()
    return do_scm_ignore("aF")
  end
  nnoremap("buffer", "<Leader>cc", _41_)
  nmap("buffer", "<Leader>cu", "<Cmd>let s=@/<CR>l?\11(#;)+<CR>dgn:let @/=s<CR>")
  nmap("buffer", "<Leader>pp", "<Plug>SlimeMotionSend<Plug>(sexp_outer_top_list)``")
  nnoremap("buffer", "K", "<Cmd>SlimeSend1 (pp <C-R><C-W>)<CR>")
  return nmap("buffer", "<Leader>lf", "ggvG=``")
end
au("scheme", "FileType", "scheme", _40_)
vim.g.vrc_curl_opts = {["--connect-timeout"] = 10, ["--include"] = "", ["--location"] = "", ["--max-time"] = 60, ["--show-error"] = "", ["--silent"] = ""}
vim.g.vrc_auto_format_response_patterns = {json = "jq", xml = "grep \"\\S\" | xmllint --format --nonet --recover -"}
local function _42_()
  local function _43_()
    vim.b.vrc_debug = not vim.b.vrc_debug
    vim.b.vrc_show_command = vim.b.vrc_debug
    local function _44_()
      if vim.b.vrc_debug then
        return "debug"
      else
        return "nodebug"
      end
    end
    return vim.notify(_44_())
  end
  nnoremap("buffer", "<Leader>cd", _43_)
  local function _45_()
    vim.b.vrc_allow_get_request_body = not vim.b.vrc_allow_get_request_body
    local function _46_()
      if vim.b.vrc_allow_get_request_body then
        return "allow body"
      else
        return "disallow body"
      end
    end
    return vim.notify(_46_())
  end
  nnoremap("buffer", "<Leader>cb", _45_)
  local function _47_()
    vim.b.vrc_split_request_body = not vim.b.vrc_split_request_body
    local function _48_()
      if vim.b.vrc_split_request_body then
        return "split"
      else
        return "nosplit"
      end
    end
    return vim.notify(_48_())
  end
  nnoremap("buffer", "<Leader>cs", _47_)
  local function _49_()
    vim.b.vrc_output_buffer_name = ("[" .. vim.fn.expand("%:t") .. "@" .. vim.fn.strftime("%H:%M:%S") .. "]" .. string.gsub(vim.api.nvim_get_current_line(), "\"", "\\\""))
    return vim.fn.VrcQuery()
  end
  return nnoremap("buffer", "<Leader>cc", _49_)
end
au("rest", "FileType", "rest", _42_)
local function _50_()
  return vnoremap("buffer", "<Leader>tj", ":!pandoc -f gfm -t jira<CR>")
end
au("markdown", "FileType", "markdown", _50_)
vim.g.markdown_syntax_conceal = false
vim.g.markdown_folding = 1
local function _51_()
  vim.opt_local.filetype = "glsl"
  return nil
end
au("glsl-detect", {"BufNewFile", "BufRead"}, {"*.glsl", "*.vert", "*.geom", "*.frag"}, _51_)
conform.formatters_by_ft.glsl = {"clang-format"}
local function _52_()
  return lsp_buffer_mappings()
end
au("nix", "FileType", "nix", _52_)
lspconfig.nixd.setup({capabilities = lsp_capabilities})
conform.formatters_by_ft.nix = {"nixpkgs_fmt"}
nnoremap("<Leader>aa", "<Cmd>Other<CR>")
nnoremap("<Leader>av", "<Cmd>OtherVSplit<CR>")
other.setup({mappings = {{pattern = "(.*)/src/(.*).clj", target = "%1/test/%2_test.clj"}, {pattern = "(.*)/test/(.*)_test.clj", target = "%1/src/%2.clj"}, {pattern = "(.*)/fnl/(.*).fnl", target = "%1/lua/%2.lua"}, {pattern = "(.*)/lua/(.*).lua", target = "%1/fnl/%2.fnl"}, {pattern = "(.*)/main/(.*).scala", target = "%1/test/%2Test.scala"}, {pattern = "(.*)/test/(.*)Test.scala", target = "%1/main/%2.scala"}, {pattern = "(.*)/main/(.*).scala", target = "%1/test/%2Spec.scala"}, {pattern = "(.*)/test/(.*)Spec.scala", target = "%1/main/%2.scala"}}})
tnoremap("<Esc>", "<C-\\><C-n>")
tnoremap("<C-v><Esc>", "<Esc>")
local function _53_()
  vim.opt_local.winbar = "%{b:term_title}"
  vim.opt_local.bufhidden = "hide"
  return nil
end
au("terminal-open", "TermOpen", "*", _53_)
local function _54_()
  if (vim.b.terminal_job_pid and vim.b.term_title) then
    return vim.cmd.file(("term:" .. vim.b.terminal_job_pid .. ":" .. vim.b.term_title))
  else
    return nil
  end
end
au("terminal-leave", "TermLeave", "*", _54_)
local function _57_(_56_)
  local path = _56_["args"]
  local path0
  if (path == "") then
    path0 = "%:h"
  else
    path0 = path
  end
  vim.cmd(table.concat({"vsplit", ("lcd " .. path0), "terminal"}, "|"))
  return vim.api.nvim_feedkeys("i", "n", false)
end
vim.api.nvim_create_user_command("Term", _57_, {nargs = "?", desc = "Open terminal"})
local function _60_(_59_)
  local suffix = _59_["args"]
  return vim.cmd.edit((vim.fn.tempname() .. "_" .. suffix))
end
vim.api.nvim_create_user_command("Scratch", _60_, {nargs = "?", desc = "New temporary file"})
local function _61_()
  local file_path = vim.api.nvim_buf_get_name(0)
  local protocol = string.match(file_path, "^[%w-]+://")
  if not protocol then
    return vim.cmd("silent! update")
  else
    return nil
  end
end
au("autosave", {"FocusLost", "BufLeave", "CursorHold"}, {"*"}, _61_)
local function _63_()
  return vim.cmd("silent! checktime")
end
au("autoread", {"FocusGained", "BufEnter", "CursorHold"}, {"*"}, _63_)
local function _64_()
  local _let_65_ = vim.api.nvim_buf_get_mark(0, "\"")
  local line = _let_65_[1]
  local col = _let_65_[2]
  local line_count = vim.api.nvim_buf_line_count(0)
  if (((1 <= line) and (line <= line_count)) and (vim.opt.ft:get() ~= "commit")) then
    return vim.api.nvim_win_set_cursor(0, {line, col})
  else
    return nil
  end
end
au("jump-to-last-postion", "BufReadPost", "*", _64_)
nmap("ga", "<Plug>(EasyAlign)")
xmap("ga", "<Plug>(EasyAlign)")
local function _67_()
  local word_under_cursor = vim.fn.expand("<cWORD>")
  local task = string.match(word_under_cursor, "NT%-%d+")
  if task then
    return vim.ui.open(("https://notion.so/" .. task))
  else
    return vim.notify(("Not a notion task '" .. word_under_cursor .. "'"), vim.log.levels.WARN)
  end
end
nnoremap("<Leader>gn", _67_)
return {clj_ignore = clj_ignore, scm_ignore = scm_ignore}
